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

    static let divideErrorMessage = "m ÷ 0 undefined"
    static let invertErrorMessage = "1 ÷ 0 undefined"
    static let zeroPowerOfZeroErrorMessage = "0 ↑ 0 undefined"
    static let negativePowerOfZeroErrorMessage = "0 ↑ -n undefined"
    static let negativePowerErrorMessage = "m ↑ -n undefined"
    static let fractionalPowerOfNegativeErrorMessage = "-m ↑ 1/n undefined"

    /// U+2027 HYPHENATION POINT - the point glyph `Digits` itself knows about.
    /// Distinct from the keypad's decimal-point button glyph, see CalculatorSymbols.
    static let pointString = "‧"
    static let negativeString = "-"

    /// Separates a `Rational` result's numerator and denominator when
    /// `denominator != 1` (see `description` below and `Rational.swift`).
    /// Deliberately distinct from both the plain ASCII `/` used internally
    /// as the division *operator*'s token, and from `÷`
    /// (`CalculatorSymbols.divide`) that operator is prettified to for
    /// display: `CalculatorSymbols.prettify` blindly substitutes `/` for
    /// `÷` across the whole display string, so if a fraction's
    /// separator were also `/`, an exact division *result* like `7/2` would
    /// render indistinguishably from a still-*pending* `7 ÷ 2`
    /// expression. `:` is not one of `prettify`'s substitution targets, so
    /// it stays a fraction wherever it appears.
    static let rationalSeparator = ":"

    private(set) var base: Int
    var signedDigits: String?
    private(set) var allowedDigits: String
    private(set) var allowedDigitCharacters: Set<Character>
    private(set) var digitValues: [Character: Int]
    /// True for a "FloatingDigits"-flavored instance: allows a "." digit and
    /// uses double-based arithmetic instead of overflow-checked Int64 math.
    private(set) var allowsPoint: Bool
    /// `1` for a plain integer (every typed value, and every non-fractional
    /// result); a genuine, already-reduced fraction's denominator otherwise.
    /// Only ever set via `init(rational:base:)`, which a division or
    /// inversion result comes from - see `rationalValue`/`Rational.swift`.
    private(set) var denominator: Int64 = 1

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

        signedDigits = Digits.scanSignedDigits(
            from: someString,
            allowed: allowedDigitCharacters.union([Character(".")])
        )
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

    /// Builds a `Digits` holding an exact fraction: `signedDigits` is the
    /// numerator's digit string (via the same `convertInteger` any plain
    /// integer result already goes through), plus a stored `denominator`.
    /// `rational` is always already reduced (see `Rational.init`), so no
    /// further normalization happens here.
    convenience init(rational: Rational, base someBase: Int) {
        let numeratorDigits = Digits.convertInteger(rational.numerator, toBase: someBase)
        self.init(string: numeratorDigits, base: someBase)!
        denominator = rational.denominator
    }

    /// Mirrors the NSScanner-based parsing in -[Digits initWithString:base:]:
    /// skip one optional leading space, an optional "-" (and one optional
    /// space after it), then take the longest prefix made only of allowed
    /// digit characters. If that prefix is empty, the whole scan "fails" and
    /// yields nil (matching `scanUpToCharactersFromSet:intoString:` returning
    /// NO and leaving the output untouched) - even the "-" is discarded.
    static func scanSignedDigits(from input: String, allowed: Set<Character>) -> String? {
        var remainder = Substring(input)

        remainder = remainder.drop(while: { $0.isWhitespace })

        var negativePrefix = ""
        if remainder.first == "-" {
            negativePrefix = "-"
            remainder = remainder.dropFirst()
            remainder = remainder.drop(while: { $0.isWhitespace })
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

    /// The exact value as a reduced fraction - `denominator` is `1` for
    /// everything except a genuine division/inversion result. This is what
    /// `plus`/`minus`/`times`/`divide`/`invert`/`power` actually compute
    /// with now, instead of `integerValue` alone, which is what lets
    /// `7 ÷ 2` stay exact instead of truncating to `3`.
    /// Force-unwrapped because `numerator`/`denominator` here are always
    /// already-reduced values `Rational.init` has already accepted once
    /// (via `init(rational:base:)`) or, for a plain integer, the trivially
    /// valid `(n, 1)` - never a value that would fail its own guard.
    var rationalValue: Rational {
        Rational(numerator: integerValue, denominator: denominator)!
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
        let numeratorPart = zeroPrefix + (unsignedDigits ?? "")

        guard denominator != 1 else { return numeratorPart }
        return numeratorPart + Digits.rationalSeparator + Digits.convertInteger(denominator, toBase: base)
    }

    // MARK: mutating methods

    func pushDigit(_ digit: String) {
        if digit == "-" {
            negate()
            return
        }

        guard isDigit(digit) else { return }

        let currentValue = integerValue
        let base64 = Int64(base)
        if currentValue > Int64.max / base64 || currentValue < Int64.min / base64 {
            return
        }

        if digit == "." && containsPoint {
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
        guard let result = rationalValue + secondOperand.rationalValue else {
            throw DigitsError(message: "addition overflow")
        }
        return Digits(rational: result, base: base)
    }

    func minus(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: "subtraction error: no second operand")
        }
        if allowsPoint {
            return Digits(double: doubleValue - secondOperand.doubleValue, base: base)
        }
        guard let result = rationalValue - secondOperand.rationalValue else {
            throw DigitsError(message: "subtraction overflow")
        }
        return Digits(rational: result, base: base)
    }

    func times(_ secondOperand: Digits?) throws -> Digits? {
        guard let secondOperand else {
            throw DigitsError(message: "multiplication error: no second operand")
        }
        if allowsPoint {
            return Digits(double: doubleValue * secondOperand.doubleValue, base: base)
        }
        guard let result = rationalValue * secondOperand.rationalValue else {
            throw DigitsError(message: "multiplication overflow")
        }
        return Digits(rational: result, base: base)
    }

    /// Now produces the *exact* quotient as a reduced fraction (via
    /// `Rational`) instead of the old truncating `Int64` division -
    /// `7 ÷ 2` is the exact value `7:2`, not the truncated `3`. A
    /// plain integer's `denominator` is always `1`, so this still divides
    /// evenly whenever the original truncating version would have (nothing
    /// changes for e.g. `24 ÷ 4`); it's only the previously-lossy
    /// remainder case that's different now.
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
        guard secondOperand.integerValue != 0 else {
            throw DigitsError(message: Digits.divideErrorMessage)
        }
        guard let result = rationalValue / secondOperand.rationalValue else {
            throw DigitsError(message: "division overflow")
        }
        return Digits(rational: result, base: base)
    }

    /// Now produces the *exact* reciprocal as a reduced fraction - `1 ÷ 3`
    /// used to truncate to `0` (`Int64` division), now gives the exact
    /// `1:3`.
    func invert() throws -> Digits? {
        if allowsPoint {
            guard doubleValue != 0 else {
                throw DigitsError(message: Digits.invertErrorMessage)
            }
            return Digits(double: 1.0 / doubleValue, base: base)
        }
        guard integerValue != 0 else {
            throw DigitsError(message: Digits.invertErrorMessage)
        }
        guard let result = rationalValue.inverse() else {
            throw DigitsError(message: "invert overflow")
        }
        return Digits(rational: result, base: base)
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

        // The exponent is always a plain typed integer in practice (digit
        // entry never produces a fraction), so only the base needs to be
        // `Rational`-aware; `secondOperandValue` stays a plain `Int64`
        // exactly as before.
        let baseValue = rationalValue
        let secondOperandValue = secondOperand.integerValue

        if baseValue.numerator == 0 && secondOperandValue == 0 {
            throw DigitsError(message: Digits.zeroPowerOfZeroErrorMessage)
        } else if baseValue.numerator == 0 && secondOperandValue < 0 {
            throw DigitsError(message: Digits.negativePowerOfZeroErrorMessage)
        } else if baseValue.numerator != 0 && secondOperandValue < 0 {
            // Preserved restriction: even though a negative exponent of a
            // nonzero `Rational` base is now exactly representable (just
            // flip numerator/denominator), this app never exposed negative
            // exponents through `^` before, and nothing here was asked to
            // change that - `inversePressed()` is the new, dedicated way to
            // get an exact `1/x`.
            throw DigitsError(message: Digits.negativePowerErrorMessage)
        } else if baseValue.numerator < 0 && secondOperand.containsPoint {
            throw DigitsError(message: Digits.fractionalPowerOfNegativeErrorMessage)
        }

        guard let result = baseValue.power(secondOperandValue) else {
            throw DigitsError(message: "power overflow")
        }
        return Digits(rational: result, base: base)
    }

    /// Multiplies by `base` (append a zero digit) - the calculator's "shift
    /// left" key. Overflow-checked like the other arithmetic methods.
    /// Undefined for a genuine fraction (see `shiftedRight` for why).
    func shiftedLeft() throws -> Digits {
        guard denominator == 1 else {
            throw DigitsError(message: "shift undefined for a fraction")
        }
        let (result, overflow) = integerValue.multipliedReportingOverflow(by: Int64(base))
        guard !overflow else { throw DigitsError(message: "shift overflow") }
        return Digits(longLong: result, base: base)
    }

    /// Truncating-toward-zero divide by `base` (drops the last digit) - the
    /// calculator's "shift right" key. Deliberately lossy for the dropped
    /// digit, unlike the exact `÷` operator: a real digit/bit shift is
    /// expected to discard whatever falls off the end, not preserve it as a
    /// fraction. Because of that, shifting a genuine (non-integer) fraction
    /// has no sensible meaning here and throws instead of silently
    /// discarding its denominator.
    func shiftedRight() throws -> Digits {
        guard denominator == 1 else {
            throw DigitsError(message: "shift undefined for a fraction")
        }
        return Digits(longLong: integerValue / Int64(base), base: base)
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
        // Swift's own radix conversion covers every base this app actually
        // ships (2...36 across both idioms) exactly, including `Int64.min`,
        // with no floating point involved. It only goes up to radix 36
        // (`0`-`9`,`A`-`Z`), so bases 37...62 - reachable only via `allDigits`'s
        // lowercase extension, not by anything in the shipped UI - fall
        // through to the plain repeated-division algorithm below instead of
        // the previous `log`/`pow`-based digit extraction.
        if someBase <= 36 {
            return String(someInt, radix: someBase, uppercase: true)
        }

        let allowedDigits = Array(allDigits.prefix(someBase))
        let negative = someInt < 0
        // `Int64.magnitude` (unlike `abs`) correctly handles Int64.min,
        // whose magnitude (2^63) does not fit back into an Int64.
        let absoluteValue: UInt64 = someInt.magnitude

        if absoluteValue == 0 {
            return String(allowedDigits[0])
        }

        var remainder = absoluteValue
        let baseAsUInt64 = UInt64(someBase)
        var digits: [Character] = []
        while remainder > 0 {
            digits.append(allowedDigits[Int(remainder % baseAsUInt64)])
            remainder /= baseAsUInt64
        }

        return (negative ? "-" : "") + String(digits.reversed())
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
