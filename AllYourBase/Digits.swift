//
//  Digits.swift
//  AllYourBase
//
//  A signed string of digits in an arbitrary base (2...62), together with
//  the arithmetic operations the calculator needs. Ported from the
//  Objective-C `Digits` class.
//

import Foundation

/// Errors produced by `Digits` arithmetic, matching the calculator's
/// original error messages (including the mathematical symbols it used).
enum DigitsError: Error, LocalizedError, Equatable {
    case divideByZero
    case invertByZero
    case zeroPowerOfZero
    case negativePowerOfZero
    case negativePower
    case fractionalPowerOfNegative
    case overflow(String)

    var errorDescription: String? {
        switch self {
        case .divideByZero: return "m \u{00F7} 0 undefined"
        case .invertByZero: return "1 \u{00F7} 0 undefined"
        case .zeroPowerOfZero: return "0 \u{2191} 0 undefined"
        case .negativePowerOfZero: return "0 \u{2191} -n undefined"
        case .negativePower: return "m \u{2191} -n undefined"
        case .fractionalPowerOfNegative: return "-m \u{2191} 1/n undefined"
        case .overflow(let operation): return "\(operation) overflow"
        }
    }
}

/// Parses the "sign + digits, stop at the first character outside the
/// allowed alphabet" grammar shared by `Digits` and `FloatingDigits`.
enum DigitsParsing {
    static func parseSignedDigits(from string: String, allowedInputCharacters: String) -> String? {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil

        _ = scanner.scanString(" ")

        var negativePrefix = ""
        if scanner.scanString("-") != nil {
            negativePrefix = "-"
            _ = scanner.scanString(" ")
        }

        let forbidden = CharacterSet(charactersIn: allowedInputCharacters).inverted
        guard let someSignedDigits = scanner.scanUpToCharacters(from: forbidden) else {
            return nil
        }
        return negativePrefix + someSignedDigits
    }
}

struct Digits: CustomStringConvertible {
    /// 62 characters: every digit `pushDigit`/`convertInteger` can produce.
    static let digitAlphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static let minBase = 2
    /// The original allowed bases up to 100, but the alphabet above only has
    /// 62 characters, so anything past 62 would read out of bounds. Capped
    /// here to the alphabet's actual length.
    static let maxBase = digitAlphabet.count

    private(set) var base: Int
    var signedDigits: String?

    // MARK: Initializers

    init?(base: Int) {
        self.init(string: "", base: base)
    }

    init() {
        self.init(base: 10)!
    }

    init?(longLong value: Int64, base: Int) {
        self.init(string: Digits.convertInteger(value, toBase: base), base: base)
    }

    init(longLong value: Int64) {
        self.init(longLong: value, base: 10)!
    }

    init?(string: String, base: Int) {
        guard base >= Digits.minBase, base <= Digits.maxBase else {
            print("only bases from \(Digits.minBase) to \(Digits.maxBase) are supported")
            return nil
        }
        self.base = base
        self.signedDigits = DigitsParsing.parseSignedDigits(
            from: string,
            allowedInputCharacters: Digits.allowedInputCharacters(forBase: base)
        )
    }

    init(string: String) {
        self.init(string: string, base: 10)!
    }

    // MARK: Digit alphabets

    /// The digits that carry numeric value in this base, e.g. "0123456789" for base 10.
    var digitAlphabet: String { Digits.allowedDigits(forBase: base) }

    /// The alphabet allowed while entering a number: digits plus the decimal point.
    var allowedInputCharacters: String { Digits.allowedInputCharacters(forBase: base) }

    // MARK: Computed properties

    var unsignedDigits: String? {
        guard let signed = signedDigits else { return nil }
        if signed == "-" { return nil }
        if startsWithMinus { return String(signed.dropFirst()) }
        return signed
    }

    var isEmpty: Bool { Digits.isEmpty(signedDigits) }
    var startsWithMinus: Bool { Digits.startsWithMinus(signedDigits) }
    var startsWithPoint: Bool { Digits.startsWithPoint(unsignedDigits) }
    var containsPoint: Bool { Digits.containsPoint(signedDigits) }
    var zeroChar: Character { digitAlphabet.first! }

    /// The value of `signedDigits`, parsed against this base's own alphabet
    /// (rather than `strtoll`, which only understands bases up to 36 and so
    /// can't tell apart the extra lowercase digits used by bases 37...62).
    var integerValue: Int64 {
        guard let signed = signedDigits else { return 0 }
        var chars = Substring(signed)
        var negative = false
        if chars.first == "-" {
            negative = true
            chars = chars.dropFirst()
        }

        let alphabet = digitAlphabet
        var result: Int64 = 0
        var overflowed = false
        for ch in chars {
            guard let idx = alphabet.firstIndex(of: ch) else { break }
            let digitValue = Int64(alphabet.distance(from: alphabet.startIndex, to: idx))
            let (multiplied, mulOverflow) = result.multipliedReportingOverflow(by: Int64(base))
            if mulOverflow {
                overflowed = true
                break
            }
            let (added, addOverflow) = multiplied.addingReportingOverflow(digitValue)
            if addOverflow {
                overflowed = true
                break
            }
            result = added
        }

        if overflowed {
            return negative ? Int64.min : Int64.max
        }
        return negative ? -result : result
    }

    var description: String {
        guard let signed = signedDigits else { return "" }
        if signed == "-" { return "-" }
        var zeroPrefix = ""
        if startsWithMinus { zeroPrefix = "-" }
        if startsWithPoint { zeroPrefix = "0" }
        return zeroPrefix + (unsignedDigits ?? "")
    }

    // MARK: Mutating methods

    mutating func pushDigit(_ digit: String) {
        guard isDigit(digit) else {
            print("digit '\(digit)' is not an allowed digit")
            return
        }

        let currentValue = integerValue
        let base64 = Int64(base)
        if currentValue > Int64.max / base64 || currentValue < Int64.min / base64 {
            print("adding a digit would cause integer overflow")
            return
        }

        if digit == "." && containsPoint {
            print("digit '.' already present in signed digits '\(signedDigits ?? "")'")
            return
        }

        switch (digit, signedDigits) {
        case (".", .none): signedDigits = "0."
        case (".", "0"): signedDigits = "0."
        case (".", "-0"): signedDigits = "-0."
        case (_, .none): signedDigits = digit
        case (_, "0"): signedDigits = digit
        case (_, "-0"): signedDigits = "-" + digit
        default: signedDigits! += digit
        }
    }

    @discardableResult
    mutating func popDigit() -> String? {
        guard let signed = signedDigits, !signed.isEmpty else { return nil }
        if signed.count == 1 {
            signedDigits = nil
            return signed
        }
        let lastDigit = String(signed.suffix(1))
        signedDigits = String(signed.dropLast())
        return lastDigit
    }

    mutating func negate() {
        if signedDigits == nil {
            signedDigits = "-0"
        } else if signedDigits == "-0" {
            signedDigits = "0"
        } else if startsWithMinus {
            if integerValue != Int64.min {
                signedDigits = unsignedDigits
            }
        } else {
            signedDigits = "-" + signedDigits!
        }
    }

    // MARK: Arithmetic

    func plus(_ other: Digits) throws -> Digits {
        let (result, overflow) = integerValue.addingReportingOverflow(other.integerValue)
        if overflow { throw DigitsError.overflow("addition") }
        return Digits(longLong: result, base: base)!
    }

    func minus(_ other: Digits) throws -> Digits {
        let (result, overflow) = integerValue.subtractingReportingOverflow(other.integerValue)
        if overflow { throw DigitsError.overflow("subtraction") }
        return Digits(longLong: result, base: base)!
    }

    func times(_ other: Digits) throws -> Digits {
        let (result, overflow) = integerValue.multipliedReportingOverflow(by: other.integerValue)
        if overflow { throw DigitsError.overflow("multiplication") }
        return Digits(longLong: result, base: base)!
    }

    func divide(_ other: Digits) throws -> Digits {
        let a = integerValue
        let b = other.integerValue
        if b == 0 || (a == Int64.min && b == -1) {
            throw DigitsError.divideByZero
        }
        return Digits(longLong: a / b, base: base)!
    }

    func invert() throws -> Digits {
        let value = integerValue
        guard value != 0 else { throw DigitsError.invertByZero }
        return Digits(longLong: 1 / value, base: base)!
    }

    func power(_ other: Digits) throws -> Digits {
        let a = integerValue
        let b = other.integerValue

        if a == 0 && b == 0 { throw DigitsError.zeroPowerOfZero }
        if a == 0 && b < 0 { throw DigitsError.negativePowerOfZero }
        if a != 0 && b < 0 { throw DigitsError.negativePower }
        if a < 0 && other.containsPoint { throw DigitsError.fractionalPowerOfNegative }

        // Checked directly against the computed result rather than with a
        // pre-flight estimate (the original used `db * log(da) < log(LLONG_MAX)`,
        // which is razor-thin - and wrong in `Double` precision - exactly at
        // powers of two near the `Int64` boundary, e.g. 2^63).
        let doubleResult = pow(Double(a), Double(b)).rounded()
        guard let result = Int64(exactly: doubleResult) else {
            throw DigitsError.overflow("power")
        }
        return Digits(longLong: result, base: base)!
    }

    // MARK: Convenience

    func isDigit(_ candidate: String) -> Bool {
        guard candidate.count == 1, let ch = candidate.first else { return false }
        return allowedInputCharacters.contains(ch)
    }

    // MARK: Static helpers

    static func allowedDigits(forBase base: Int) -> String {
        String(digitAlphabet.prefix(base))
    }

    static func allowedInputCharacters(forBase base: Int) -> String {
        allowedDigits(forBase: base) + "."
    }

    /// Converts an integer to its digit string in the given base, e.g.
    /// `convertInteger(46656, toBase: 16)` -> `"B640"`.
    static func convertInteger(_ value: Int64, toBase base: Int) -> String {
        let alphabet = Array(allowedDigits(forBase: base))
        if value == 0 {
            return String(alphabet[0])
        }

        let negative = value < 0
        var magnitude = value.magnitude
        let baseMagnitude = UInt64(base)
        var chars: [Character] = []
        while magnitude > 0 {
            let digit = Int(magnitude % baseMagnitude)
            chars.append(alphabet[digit])
            magnitude /= baseMagnitude
        }

        let digitsString = String(chars.reversed())
        return negative ? "-" + digitsString : digitsString
    }

    static func startsWithMinus(_ string: String?) -> Bool {
        guard let string, !string.isEmpty else { return false }
        return string.first == "-"
    }

    static func startsWithPoint(_ string: String?) -> Bool {
        guard let string, !string.isEmpty else { return false }
        return string.first == "."
    }

    static func containsPoint(_ string: String?) -> Bool {
        guard let string else { return false }
        return string.contains(".")
    }

    static func isEmpty(_ string: String?) -> Bool {
        guard let string else { return false }
        return string.isEmpty
    }
}
