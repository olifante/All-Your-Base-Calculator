//
//  Digits.swift
//  AllYourBase
//
//  Swift port of the original Objective-C Digits.h/.m (2011). Represents the
//  signed digit string of one operand, in any base from 2 to 100 (bases above
//  62 cannot actually contain a valid digit, same limitation as the original).
//
//  `signedDigits == nil` means "nothing has been typed yet", which is a
//  distinct state from `signedDigits == ""` or `"0"` - callers throughout the
//  app rely on that distinction (e.g. "is there a second operand yet?"), so
//  it is preserved here rather than collapsing to a single empty state.
//
//  The original project also had a `FloatingDigits : Digits` subclass adding
//  a "." digit and double-based arithmetic. It is folded into this single
//  type as the `allowsPoint` flag instead of being ported as a separate
//  subclass: `AllYourBaseModel` never actually instantiated `FloatingDigits`
//  (it only imported the header, with the double-based code path commented
//  out - see `setBase:` in the original AllYourBaseModel.m), so it was dead
//  code duplicating ~90% of this file. Folding it in keeps that logic and
//  its test coverage without carrying an unused, divergence-prone subclass.
//

import Foundation

struct DigitsError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

final class Digits: CustomStringConvertible {

    static let allDigits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    static let divideErrorMessage = "m \u{00f7} 0 undefined"
    static let invertErrorMessage = "1 \u{00f7} 0 undefined"
    static let zeroPowerOfZeroErrorMessage = "0 \u{2191} 0 undefined"
    static let negativePowerOfZeroErrorMessage = "0 \u{2191} -n undefined"
    static let negativePowerErrorMessage = "m \u{2191} -n undefined"
    static let fractionalPowerOfNegativeErrorMessage = "-m \u{2191} 1/n undefined"

    /// U+2027 HYPHENATION POINT - the point glyph `Digits` itself knows about.
    /// Distinct from the keypad's decimal-point button glyph, see CalculatorSymbols.
    static let pointString = "\u{2027}"
    static let negativeString = "-"

    private(set) var base: Int
    var signedDigits: String?
    private(set) var allowedDigits: String
    private(set) var allowedDigitCharacters: Set<Character>
    private(set) var digitValues: [Character: Int]
    /// True for a "FloatingDigits"-flavored instance: allows a "." digit and
    /// uses double-based arithmetic instead of overflow-checked Int64 math.
    private(set) var allowsPoint: Bool

    init?(string someString: String?, base someBase: Int, allowsPoint someAllowsPoint: Bool = false) {
        guard let someString else { return nil }
        guard someBase >= 2, someBase <= 100 else { return nil }

        base = someBase
        allowsPoint = someAllowsPoint
        allowedDigits = String(Digits.allDigits.prefix(someBase)) + (someAllowsPoint ? "." : "")
        allowedDigitCharacters = Set(allowedDigits)
        var values: [Character: Int] = [:]
        for (index, character) in allowedDigits.enumerated() {
            values[character] = index
        }
        digitValues = values
        signedDigits = nil

        signedDigits = Digits.scanSignedDigits(from: someString, allowed: allowedDigitCharacters)
    }

    convenience init?(base someBase: Int) {
        self.init(string: "", base: someBase)
    }

    convenience init() {
        self.init(string: "", base: 10)!
    }

    convenience init(longLong someInt: Int64, base someBase: Int) {
        let someDigits = Digits.convertInteger(someInt, toBase: someBase)
        self.init(string: someDigits, base: someBase)!
    }

    convenience init(longLong someInt: Int64) {
        self.init(longLong: someInt, base: 10)
    }

    /// Equivalent of `[[FloatingDigits alloc] initWithDouble:base:]`.
    convenience init?(double someDouble: Double, base someBase: Int) {
        guard let someDigits = Digits.convertDouble(someDouble, toBase: someBase) else { return nil }
        self.init(string: someDigits, base: someBase, allowsPoint: true)
    }

    convenience init?(double someDouble: Double) {
        self.init(double: someDouble, base: 10)
    }

    /// Mirrors the NSScanner-based parsing in -[Digits initWithString:base:]:
    /// skip one optional leading space, an optional "-" (and one optional
    /// space after it), then take the longest prefix made only of allowed
    /// digit characters. If that prefix is empty, the whole scan "fails" and
    /// yields nil (matching `scanUpToCharactersFromSet:intoString:` returning
    /// NO and leaving the output untouched) - even the "-" is discarded.
    static func scanSignedDigits(from input: String, allowed: Set<Character>) -> String? {
        var remainder = Substring(input)

        if remainder.first == " " {
            remainder = remainder.dropFirst()
        }

        var negativePrefix = ""
        if remainder.first == "-" {
            negativePrefix = "-"
            remainder = remainder.dropFirst()
            if remainder.first == " " {
                remainder = remainder.dropFirst()
            }
        }

        var scanned = ""
        for character in remainder {
            guard allowed.contains(character) else { break }
            scanned.append(character)
        }

        guard !scanned.isEmpty else { return nil }
        return negativePrefix + scanned
    }

    // MARK: computed properties

    var integerValue: Int64 {
        guard let signedDigits else { return 0 }
        return Digits.parseIntegerLiteral(signedDigits, base: base)
    }

    /// Equivalent of `FloatingDigits.doubleValue`. Always available (not
    /// gated on `allowsPoint`) since it is a pure, harmless read of whatever
    /// digits happen to be present; it is only ever meaningfully used on an
    /// `allowsPoint` instance in practice.
    var doubleValue: Double {
        guard let signedDigits else { return 0 }
        guard let pointIndex = signedDigits.firstIndex(of: ".") else {
            return Double(Digits.parseIntegerLiteral(signedDigits, base: base))
        }
        let integralValue = Double(Digits.parseIntegerLiteral(signedDigits, base: base))
        let fractionalPart = String(signedDigits[signedDigits.index(after: pointIndex)...])
        let fractionalDigitsAsInteger = Digits.parseIntegerLiteral(fractionalPart, base: base)
        let fractionalValue = Double(fractionalDigitsAsInteger) * pow(Double(base), -Double(fractionalPart.count))
        return startsWithMinus ? -fractionalValue - abs(integralValue) : fractionalValue + abs(integralValue)
    }

    var unsignedDigits: String? {
        guard let signedDigits else { return nil }
        if signedDigits == "-" { return nil }
        if startsWithMinus { return String(signedDigits.dropFirst()) }
        return signedDigits
    }

    var isEmpty: Bool {
        Digits.isEmpty(signedDigits)
    }

    var startsWithMinus: Bool {
        Digits.startsWithMinus(signedDigits)
    }

    var startsWithPoint: Bool {
        Digits.startsWithPoint(unsignedDigits)
    }

    var containsPoint: Bool {
        Digits.containsPoint(signedDigits)
    }

    var zeroChar: Character {
        allowedDigits[allowedDigits.startIndex]
    }

    var description: String {
        guard let signedDigits else { return "" }
        if signedDigits == "" { return "0" }
        if signedDigits == "-" { return "-" }

        var zeroPrefix = ""
        if startsWithMinus { zeroPrefix = "-" }
        if startsWithPoint { zeroPrefix = "0" }
        return zeroPrefix + (unsignedDigits ?? "")
    }

    // MARK: mutating methods

    func pushDigit(_ digit: String) {
        guard isDigit(digit) else { return }

        let currentValue = integerValue
        let base64 = Int64(base)
        if currentValue > Int64.max / base64 || currentValue < Int64.min / base64 {
            return
        }

        if digit == "." && containsPoint {
            return
        }

        if digit == "-" {
            negate()
            return
        }

        if digit == "." && signedDigits == nil {
            signedDigits = "0" + digit
        } else if digit == "." && signedDigits == "0" {
            signedDigits = "0" + digit
        } else if digit == "." && signedDigits == "-0" {
            signedDigits = "-0" + digit
        } else if signedDigits == nil {
            signedDigits = digit
        } else if signedDigits == "0" {
            signedDigits = digit
        } else if signedDigits == "-0" {
            signedDigits = "-" + digit
        } else {
            signedDigits = (signedDigits ?? "") + digit
        }
    }

    @discardableResult
    func popDigit() -> String? {
        guard let current = signedDigits, !current.isEmpty else { return nil }

        if current.count == 1 {
            signedDigits = nil
            return current
        } else {
            let lastDigit = String(current.suffix(1))
            signedDigits = String(current.dropLast())
            return lastDigit
        }
    }

    func negate() {
        if signedDigits == nil {
            signedDigits = "-0"
        } else if signedDigits == "-0" {
            signedDigits = "0"
        } else if startsWithMinus {
            if integerValue != Int64.min {
                signedDigits = unsignedDigits
            }
        } else {
            signedDigits = "-" + (signedDigits ?? "")
        }
    }

    // MARK: arithmetic methods
    // A plain Digits does overflow-checked Int64 math (Swift's overflow-
    // reporting operators stand in for the original's manual C bit
    // twiddling - same detected cases, far less error prone to transcribe).
    // An `allowsPoint` ("FloatingDigits") instance instead does plain
    // Double math with no overflow checking, matching the original
    // FloatingDigits overrides exactly (they never checked for overflow).

    // These return an Optional because an `allowsPoint` result can be NaN or
    // infinite (e.g. dividing into a huge result), in which case there is no
    // valid digit string to build - exactly mirroring the original
    // `FloatingDigits` overrides, which silently produced a nil object in
    // that case rather than raising an error.

    func plus(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: "addition error: no second operand")
        }
        if allowsPoint {
            return Digits(double: doubleValue + secondOperand.doubleValue, base: base)
        }
        let (result, overflow) = integerValue.addingReportingOverflow(secondOperand.integerValue)
        guard !overflow else { throw DigitsError(message: "addition overflow") }
        return Digits(longLong: result, base: base)
    }

    func minus(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: "subtraction error: no second operand")
        }
        if allowsPoint {
            return Digits(double: doubleValue - secondOperand.doubleValue, base: base)
        }
        let (result, overflow) = integerValue.subtractingReportingOverflow(secondOperand.integerValue)
        guard !overflow else { throw DigitsError(message: "subtraction overflow") }
        return Digits(longLong: result, base: base)
    }

    func times(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: "multiplication error: no second operand")
        }
        if allowsPoint {
            return Digits(double: doubleValue * secondOperand.doubleValue, base: base)
        }
        let (result, overflow) = integerValue.multipliedReportingOverflow(by: secondOperand.integerValue)
        guard !overflow else { throw DigitsError(message: "multiplication overflow") }
        return Digits(longLong: result, base: base)
    }

    func divide(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: Digits.divideErrorMessage)
        }
        if allowsPoint {
            guard secondOperand.doubleValue != 0 else {
                throw DigitsError(message: Digits.divideErrorMessage)
            }
            return Digits(double: doubleValue / secondOperand.doubleValue, base: base)
        }
        let dividend = integerValue
        let divisor = secondOperand.integerValue
        guard divisor != 0, !(dividend == Int64.min && divisor == -1) else {
            throw DigitsError(message: Digits.divideErrorMessage)
        }
        return Digits(longLong: dividend / divisor, base: base)
    }

    func invert() throws -> Digits? {
        if allowsPoint {
            guard doubleValue != 0 else {
                throw DigitsError(message: Digits.invertErrorMessage)
            }
            return Digits(double: 1.0 / doubleValue, base: base)
        }
        let operandValue = integerValue
        guard operandValue != 0 else {
            throw DigitsError(message: Digits.invertErrorMessage)
        }
        return Digits(longLong: 1 / operandValue, base: base)
    }

    func power(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: "power error: no second operand")
        }

        if allowsPoint {
            let a = doubleValue
            let b = secondOperand.doubleValue
            if a == 0 && b == 0 {
                throw DigitsError(message: Digits.zeroPowerOfZeroErrorMessage)
            } else if a == 0 && b < 0 {
                throw DigitsError(message: Digits.negativePowerOfZeroErrorMessage)
            } else if a < 0 && secondOperand.containsPoint {
                throw DigitsError(message: Digits.fractionalPowerOfNegativeErrorMessage)
            }
            return Digits(double: pow(a, b), base: base)
        }

        let firstOperandValue = integerValue
        let secondOperandValue = secondOperand.integerValue

        if firstOperandValue == 0 && secondOperandValue == 0 {
            throw DigitsError(message: Digits.zeroPowerOfZeroErrorMessage)
        } else if firstOperandValue == 0 && secondOperandValue < 0 {
            throw DigitsError(message: Digits.negativePowerOfZeroErrorMessage)
        } else if firstOperandValue != 0 && secondOperandValue < 0 {
            throw DigitsError(message: Digits.negativePowerErrorMessage)
        } else if firstOperandValue < 0 && secondOperand.containsPoint {
            throw DigitsError(message: Digits.fractionalPowerOfNegativeErrorMessage)
        } else if !Digits.exponentiationIsSafe(firstOperandValue, secondOperandValue) {
            throw DigitsError(message: "power overflow")
        }

        let result = Digits.int64(clamping: pow(Double(firstOperandValue), Double(secondOperandValue)))
        return Digits(longLong: result, base: base)
    }

    private static func exponentiationIsSafe(_ a: Int64, _ b: Int64) -> Bool {
        let da = abs(Double(a))
        let db = abs(Double(b))
        return db * log(da) < log(Double(Int64.max))
    }

    /// `Int64(someDouble)` traps if `someDouble` is outside Int64's range;
    /// the original C code did an implicit (UB, but in-practice-truncating)
    /// double-to-long-long cast here instead of trapping, so this clamps to
    /// the nearest representable Int64 rather than crashing the app.
    private static func int64(clamping value: Double) -> Int64 {
        guard value.isFinite else { return value > 0 ? Int64.max : Int64.min }
        if value >= Double(Int64.max) { return Int64.max }
        if value <= Double(Int64.min) { return Int64.min }
        return Int64(value)
    }

    // MARK: convenience methods

    func isZero(_ digitString: String) -> Bool {
        guard digitString.count == 1, let character = digitString.first else { return false }
        return character == zeroChar
    }

    func isDigit(_ digitString: String) -> Bool {
        guard digitString.count == 1, let character = digitString.first else { return false }
        return allowedDigitCharacters.contains(character)
    }

    // MARK: class utility methods

    static func allowedDigits(forBase someBase: Int) -> String {
        String(allDigits.prefix(someBase))
    }

    static func log(_ operand: Double, base: Int) -> Double {
        Foundation.log(operand) / Foundation.log(Double(base))
    }

    /// Mirrors `strtoll(signedDigits, NULL, base)`: parses a leading optional
    /// sign followed by digits valid in `base`, stopping (without failing) at
    /// the first invalid character, and clamping on overflow instead of
    /// trapping. This is what makes e.g. "0.5" parse as plain "0" (stops at
    /// the "."), and "1234567890abc" (in base 10) parse as "1234567890".
    static func parseIntegerLiteral(_ string: String, base: Int) -> Int64 {
        var characters = Substring(string)
        var negative = false
        if characters.first == "-" {
            negative = true
            characters = characters.dropFirst()
        } else if characters.first == "+" {
            characters = characters.dropFirst()
        }

        var result: Int64 = 0
        let base64 = Int64(base)
        for character in characters {
            guard let digit = digitValue(of: character, base: base) else { break }
            let (multiplied, multiplyOverflow) = result.multipliedReportingOverflow(by: base64)
            if multiplyOverflow { return negative ? Int64.min : Int64.max }
            let (added, addOverflow) = multiplied.addingReportingOverflow(Int64(digit))
            if addOverflow { return negative ? Int64.min : Int64.max }
            result = added
        }
        return negative ? -result : result
    }

    static func digitValue(of character: Character, base: Int) -> Int? {
        let value: Int
        if let ascii = character.asciiValue, ascii >= 48, ascii <= 57 {
            value = Int(ascii - 48)
        } else if let ascii = character.uppercased().first?.asciiValue, ascii >= 65, ascii <= 90 {
            value = Int(ascii - 65) + 10
        } else {
            return nil
        }
        return value < base ? value : nil
    }

    static func convertInteger(_ someInt: Int64, toBase someBase: Int) -> String {
        let allowedDigits = Array(allDigits.prefix(someBase))
        let negative = someInt < 0
        // `Int64.magnitude` (unlike `abs`) correctly handles Int64.min,
        // whose magnitude (2^63) does not fit back into an Int64.
        let absoluteValue: UInt64 = someInt.magnitude

        if absoluteValue == 0 {
            return String(allowedDigits[0])
        }

        var result = ""
        let baseAsUInt64 = UInt64(someBase)

        if absoluteValue < baseAsUInt64 {
            result.append(allowedDigits[Int(absoluteValue)])
        } else {
            var remainder = absoluteValue
            let maximumBasePower = UInt64(min(
                ceil(log(Double(remainder), base: someBase)),
                floor(log(Double(Int64.max), base: someBase))
            ))

            var exponent = maximumBasePower
            while exponent > 0 {
                let power = UInt64(pow(Double(someBase), Double(exponent)))
                let quotient = remainder / power
                remainder = remainder % power
                result.append(allowedDigits[Int(quotient)])
                exponent -= 1
            }
            result.append(allowedDigits[Int(remainder)])

            if result.first == allowedDigits[0] {
                result.removeFirst()
            }
        }

        return negative ? "-" + result : result
    }

    /// Equivalent of `+[FloatingDigits convertDouble:toBase:]`. Returns nil
    /// for NaN/infinite input, matching the original.
    static func convertDouble(_ someDouble: Double, toBase someBase: Int) -> String? {
        guard someDouble.isFinite else { return nil }

        let allowedDigits = Array(allDigits.prefix(someBase))
        let negative = someDouble.sign == .minus
        let absoluteValue = abs(someDouble)

        if absoluteValue == 0 {
            return String(allowedDigits[0])
        }

        let integralValue = absoluteValue.rounded(.towardZero)
        let fractionalValue = absoluteValue - integralValue
        let integralDigits = convertInteger(int64(clamping: integralValue), toBase: someBase)

        var trimmedFractionalDigits = ""
        if fractionalValue != 0 {
            // "%.6f" of e.g. 0.1 is "0.100000"; drop the leading "0" (as the
            // original does with `substringFromIndex:1`) then trim trailing
            // zeros, leaving ".1".
            var fractionalDigits = String(format: "%.6f", fractionalValue)
            fractionalDigits.removeFirst()
            while fractionalDigits.hasSuffix("0") {
                fractionalDigits.removeLast()
            }
            trimmedFractionalDigits = fractionalDigits
        }

        return (negative ? "-" : "") + integralDigits + trimmedFractionalDigits
    }

    // MARK: class predicates

    static func startsWithMinus(_ someString: String?) -> Bool {
        guard let someString, !someString.isEmpty else { return false }
        return someString.first == "-"
    }

    static func startsWithPoint(_ digitString: String?) -> Bool {
        guard let digitString, !digitString.isEmpty else { return false }
        return digitString.first == "."
    }

    static func containsPoint(_ digitString: String?) -> Bool {
        digitString?.contains(".") ?? false
    }

    static func isEmpty(_ digitString: String?) -> Bool {
        digitString == ""
    }
}
