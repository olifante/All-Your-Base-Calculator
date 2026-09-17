//
//  FloatingDigits.swift
//  AllYourBase
//
//  A `Digits` value that also knows how to evaluate itself (and do
//  arithmetic) as a `Double`. The original Objective-C `FloatingDigits`
//  subclassed `Digits`; since `Digits` is now a Swift struct, this wraps
//  one instead (composition instead of inheritance).
//
//  Nothing in the live calculator UI actually creates a `FloatingDigits`
//  today (the app only ever uses plain integer `Digits`), but the type is
//  kept because it has full unit test coverage and represents real, usable
//  behavior.
//

import Foundation

struct FloatingDigits: CustomStringConvertible {
    private var digits: Digits

    // MARK: Initializers

    init?(base: Int) {
        guard let digits = Digits(base: base) else { return nil }
        self.digits = digits
    }

    init() {
        self.init(base: 10)!
    }

    init?(double value: Double, base: Int) {
        guard let converted = FloatingDigits.convertDouble(value, toBase: base) else { return nil }
        self.init(string: converted, base: base)
    }

    init(double value: Double) {
        self.init(double: value, base: 10)!
    }

    init?(string: String, base: Int) {
        guard let digits = Digits(string: string, base: base) else { return nil }
        self.digits = digits
    }

    init(string: String) {
        self.init(string: string, base: 10)!
    }

    // MARK: Passthrough properties

    var base: Int { digits.base }
    var signedDigits: String? {
        get { digits.signedDigits }
        set { digits.signedDigits = newValue }
    }
    var unsignedDigits: String? { digits.unsignedDigits }
    var startsWithMinus: Bool { digits.startsWithMinus }
    var startsWithPoint: Bool { digits.startsWithPoint }
    var containsPoint: Bool { digits.containsPoint }
    var description: String { digits.description }

    mutating func pushDigit(_ digit: String) { digits.pushDigit(digit) }

    @discardableResult
    mutating func popDigit() -> String? { digits.popDigit() }

    mutating func negate() { digits.negate() }

    // MARK: Floating-point value

    /// The value of `signedDigits` interpreted as a fixed-point number in
    /// this base (integral part, optional ".", fractional part).
    var doubleValue: Double {
        guard let signed = digits.signedDigits else { return 0 }
        guard let pointIndex = signed.firstIndex(of: ".") else {
            return Double(digits.integerValue)
        }

        let integralValue = Double(digits.integerValue)
        let fractionalPart = signed[signed.index(after: pointIndex)...]
        let alphabet = digits.digitAlphabet
        var fractionalMagnitude: Double = 0
        for ch in fractionalPart {
            guard let idx = alphabet.firstIndex(of: ch) else { break }
            let value = Double(alphabet.distance(from: alphabet.startIndex, to: idx))
            fractionalMagnitude = fractionalMagnitude * Double(base) + value
        }
        let unsignedFractionalValue = fractionalMagnitude * pow(Double(base), -Double(fractionalPart.count))

        if digits.startsWithMinus {
            return -unsignedFractionalValue - abs(integralValue)
        } else {
            return unsignedFractionalValue + abs(integralValue)
        }
    }

    // MARK: Arithmetic

    func plus(_ other: FloatingDigits) throws -> FloatingDigits {
        try FloatingDigits.makeResult(doubleValue + other.doubleValue, base: base)
    }

    func minus(_ other: FloatingDigits) throws -> FloatingDigits {
        try FloatingDigits.makeResult(doubleValue - other.doubleValue, base: base)
    }

    func times(_ other: FloatingDigits) throws -> FloatingDigits {
        try FloatingDigits.makeResult(doubleValue * other.doubleValue, base: base)
    }

    func divide(_ other: FloatingDigits) throws -> FloatingDigits {
        guard other.doubleValue != 0 else { throw DigitsError.divideByZero }
        return try FloatingDigits.makeResult(doubleValue / other.doubleValue, base: base)
    }

    func invert() throws -> FloatingDigits {
        guard doubleValue != 0 else { throw DigitsError.invertByZero }
        return try FloatingDigits.makeResult(1.0 / doubleValue, base: base)
    }

    /// Unlike `Digits.power`, negative exponents are allowed here (e.g. `2 ^ -1 == 0.5`)
    /// since floating point can represent the fractional result.
    func power(_ other: FloatingDigits) throws -> FloatingDigits {
        let a = doubleValue
        let b = other.doubleValue

        if a == 0 && b == 0 { throw DigitsError.zeroPowerOfZero }
        if a == 0 && b < 0 { throw DigitsError.negativePowerOfZero }
        if a < 0 && other.containsPoint { throw DigitsError.fractionalPowerOfNegative }

        return try FloatingDigits.makeResult(pow(a, b), base: base)
    }

    private static func makeResult(_ value: Double, base: Int) throws -> FloatingDigits {
        guard let result = FloatingDigits(double: value, base: base) else {
            throw DigitsError.overflow("result")
        }
        return result
    }

    // MARK: Base conversion

    /// Converts a double to its digit string in the given base, e.g.
    /// `convertDouble(0.1, toBase: 10)` -> `"0.1"`. Returns `nil` for NaN/infinite values.
    static func convertDouble(_ value: Double, toBase base: Int) -> String? {
        guard value.isFinite else { return nil }

        let alphabet = Digits.allowedDigits(forBase: base)
        let negative = value.sign == .minus
        let absoluteValue = abs(value)

        if absoluteValue == 0 {
            return String(alphabet.first!)
        }

        let integralValue = absoluteValue.rounded(.towardZero)
        let fractionalValue = absoluteValue - integralValue
        let integralDigits = Digits.convertInteger(clampedInt64(integralValue), toBase: base)

        var fractionalDigits = ""
        if fractionalValue != 0 {
            if base == 10 {
                // Matches the original implementation exactly: format with
                // the same 6-digit precision as "%f", then trim.
                var formatted = String(format: "%f", fractionalValue) // e.g. "0.100000"
                formatted.removeFirst() // drop the leading "0" -> ".100000"
                while formatted.hasSuffix("0") {
                    formatted.removeLast()
                }
                fractionalDigits = formatted
            } else {
                // The original always formatted the fractional part in base
                // 10 regardless of `base`, which was a bug for non-decimal
                // bases (never exercised by any test). This converts the
                // fractional part into the target base instead.
                fractionalDigits = fractionalDigitsInBase(fractionalValue, base: base, alphabet: Array(alphabet))
            }
        }

        return (negative ? "-" : "") + integralDigits + fractionalDigits
    }

    private static func fractionalDigitsInBase(_ fractionalValue: Double, base: Int, alphabet: [Character]) -> String {
        var remaining = fractionalValue
        var chars: [Character] = []
        let maxDigits = 32
        for _ in 0..<maxDigits {
            remaining *= Double(base)
            let digit = min(max(Int(remaining.rounded(.towardZero)), 0), base - 1)
            chars.append(alphabet[digit])
            remaining -= Double(digit)
            if remaining <= 0 { break }
        }
        while chars.last == alphabet.first {
            chars.removeLast()
        }
        return chars.isEmpty ? "" : "." + String(chars)
    }

    private static func clampedInt64(_ value: Double) -> Int64 {
        if value >= Double(Int64.max) { return Int64.max }
        if value <= Double(Int64.min) { return Int64.min }
        return Int64(value)
    }
}
