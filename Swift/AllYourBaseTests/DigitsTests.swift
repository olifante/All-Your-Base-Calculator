//
//  DigitsTests.swift
//  AllYourBaseTests
//
//  Ported from LogicTests/DigitsTests.m (and the FloatingDigits half of
//  LogicTests/FloatingDigitsTests.m, folded in since FloatingDigits itself
//  was folded into Digits's `allowsPoint` flag - see Digits.swift).
//
//  Not every original test made the trip: a handful in DigitsTests.m
//  constructed values via out-of-range hex literals like
//  `0x8000000000000000LL` relying on C's implementation-defined/undefined
//  double<->long long conversion behavior for a value that doesn't actually
//  fit in a `long long`. That behavior isn't something to faithfully
//  reproduce in Swift (Swift traps instead of silently reinterpreting bits),
//  so those specific edge cases were dropped rather than ported as-is.
//

import XCTest
@testable import AllYourBase

final class DigitsTests: XCTestCase {

    // MARK: convertInteger

    func testConvert0ToBase10() {
        XCTAssertEqual(Digits.convertInteger(0, toBase: 10), "0")
    }

    func testConvertNegative1ToBase10() {
        XCTAssertEqual(Digits.convertInteger(-1, toBase: 10), "-1")
    }

    func testConvert46656ToBase16() {
        XCTAssertEqual(Digits.convertInteger(46656, toBase: 16), "B640")
    }

    func testConvert46656ToBase2() {
        XCTAssertEqual(Digits.convertInteger(46656, toBase: 2), "1011011001000000")
    }

    func testConvert65535ToBase16() {
        XCTAssertEqual(Digits.convertInteger(65535, toBase: 16), "FFFF")
    }

    func testConvert65536ToBase16() {
        XCTAssertEqual(Digits.convertInteger(65536, toBase: 16), "10000")
    }

    func testConvertNegative65536ToBase2() {
        XCTAssertEqual(Digits.convertInteger(-65536, toBase: 2), "-10000000000000000")
    }

    func testConvertInt64MinToBase10() {
        // Digits.min's magnitude doesn't fit back in an Int64 - this is the
        // one edge case from the dropped hex-literal tests worth keeping,
        // expressed in a way that doesn't rely on C-specific UB.
        XCTAssertEqual(Digits.convertInteger(Int64.min, toBase: 10), "-9223372036854775808")
    }

    /// Covers the lowercase-digit range (base 37...62) that Swift's own
    /// `String(_:radix:)` doesn't support (it caps at 36) and that no base
    /// in the shipped UI ever actually requests - `convertInteger` falls
    /// back to a plain repeated-division loop for it instead of delegating.
    /// 37 in base 40 is a single digit past "Z": allDigits[37] is "b"
    /// ("0"-"9","A"-"Z" take indices 0...35, "a" is 36, "b" is 37).
    func testConvertAboveStdlibRadixLimitUsesLowercaseDigits() {
        XCTAssertEqual(Digits.convertInteger(37, toBase: 40), "b")
        XCTAssertEqual(Digits.convertInteger(-77, toBase: 40), "-1b")
    }

    // MARK: init

    func testInitDefaultsToBase10Empty() {
        let digits = Digits()
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testInitWithLongLong0() {
        let digits = Digits(longLong: 0)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
    }

    func testInitWithLongLong1234567890Base16() {
        let digits = Digits(longLong: 1234567890, base: 16)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.signedDigits, "499602D2")
    }

    func testInitWithLongLong1234567890Base2() {
        let digits = Digits(longLong: 1234567890, base: 2)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.signedDigits, "1001001100101100000001011010010")
    }

    func testInitWithLongLongNegative0x80000000() {
        let digits = Digits(longLong: -0x8000_0000)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, -0x8000_0000)
        XCTAssertEqual(digits.unsignedDigits, "2147483648")
        XCTAssertEqual(digits.signedDigits, "-2147483648")
    }

    func testInitWithStringNil() {
        XCTAssertNil(Digits(string: nil, base: 10))
    }

    func testInitWithStringEmptyBase1IsInvalid() {
        XCTAssertNil(Digits(string: "", base: 1))
    }

    func testInitWithString1234567890() {
        let digits = Digits(string: "1234567890", base: 10)
        XCTAssertNotNil(digits)
        XCTAssertEqual(digits?.integerValue, 1234567890)
        XCTAssertEqual(digits?.signedDigits, "1234567890")
    }

    func testInitWithStringStopsAtFirstForbiddenCharacter() {
        // In base 10, "abc" isn't part of the allowed digit set, so the
        // scan stops there - the trailing "abc" is discarded, not kept.
        let digits = Digits(string: "1234567890abc", base: 10)
        XCTAssertEqual(digits?.integerValue, 1234567890)
        XCTAssertEqual(digits?.signedDigits, "1234567890")
    }

    func testInitWithStringBinary() {
        let digits = Digits(string: "1001001100101100000001011010010", base: 2)
        XCTAssertEqual(digits?.integerValue, 1234567890)
        XCTAssertEqual(digits?.base, 2)
    }

    func testInitWithStringNegative12() {
        let digits = Digits(string: "-12", base: 10)
        XCTAssertTrue(digits?.startsWithMinus ?? false)
        XCTAssertEqual(digits?.integerValue, -12)
        XCTAssertEqual(digits?.unsignedDigits, "12")
        XCTAssertEqual(digits?.signedDigits, "-12")
    }

    func testInitWithStringSurroundedBySpaces() {
        let digits = Digits(string: "  123 ", base: 10)
        XCTAssertEqual(digits?.integerValue, 123)
        XCTAssertEqual(digits?.signedDigits, "123")
    }

    func testInitWithStringSpaceNegativeMixedDigits() {
        let digits = Digits(string: "  -123abc456 ", base: 10)
        XCTAssertTrue(digits?.startsWithMinus ?? false)
        XCTAssertEqual(digits?.integerValue, -123)
        XCTAssertEqual(digits?.signedDigits, "-123")
    }

    func testInitWithLoneMinusDiscardsTheSign() {
        // scanUpToCharactersFromSet failing after consuming "-" discards the
        // sign too, per the original's NSScanner-based parsing.
        XCTAssertNil(Digits(string: "-", base: 10)?.signedDigits)
    }

    // MARK: push / pop / negate

    func testPushDigitsBuildsUpNumber() {
        let digits = Digits()
        digits.pushDigit("1")
        digits.pushDigit("2")
        digits.pushDigit("3")
        XCTAssertEqual(digits.description, "123")
    }

    func testPushRejectsDisallowedDigitForBase() {
        let digits = Digits(base: 2)!
        digits.pushDigit("2")
        XCTAssertNil(digits.signedDigits)
    }

    func testPushMinusNegatesInstead() {
        let digits = Digits()
        digits.pushDigit("5")
        digits.pushDigit("-")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, -5)
    }

    func testNegateEmptyProducesNegativeZero() {
        let digits = Digits()
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testNegateTwiceCancelsOut() {
        let digits = Digits()
        digits.negate()
        digits.negate()
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.signedDigits, "0")
    }

    func testNegatePop() {
        let digits = Digits()
        digits.negate()
        XCTAssertEqual(digits.popDigit(), "0")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertEqual(digits.signedDigits, "-")
    }

    func testPopDigitReturnsNilWhenNothingTyped() {
        XCTAssertNil(Digits().popDigit())
    }

    func testNegateInt64MinIsUnaffected() {
        // -(-Int64.min) would overflow, so negate() leaves it alone,
        // matching the original's explicit LLONG_MIN guard.
        let digits = Digits(longLong: Int64.min)
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, Int64.min)
    }

    // MARK: arithmetic

    func testPlusChaining() {
        let first = Digits(string: "0", base: 10)!
        let second = Digits(string: "1", base: 10)!
        let third = Digits(string: "-2", base: 10)!
        let result = try? first.plus(second)?.plus(third)
        XCTAssertEqual(result?.integerValue, -1)
    }

    func testMinusChaining() {
        let first = Digits(string: "0", base: 10)!
        let second = Digits(string: "1", base: 10)!
        let third = Digits(string: "2", base: 10)!
        let result = try? first.minus(second)?.minus(third)
        XCTAssertEqual(result?.integerValue, -3)
    }

    func testTimesChaining() {
        let first = Digits(string: "1", base: 10)!
        let second = Digits(string: "2", base: 10)!
        let third = Digits(string: "-3", base: 10)!
        let result = try? first.times(second)?.times(third)
        XCTAssertEqual(result?.integerValue, -6)
    }

    func testTimesWithNilSecondOperandReturnsNil() {
        let first = Digits(string: "1", base: 10)!
        XCTAssertNil(try? first.times(nil))
    }

    func testDivideChaining() {
        let first = Digits(string: "24", base: 10)!
        let second = Digits(string: "4", base: 10)!
        let third = Digits(string: "-3", base: 10)!
        let result = try? first.divide(second)?.divide(third)
        XCTAssertEqual(result?.integerValue, -2)
    }

    func testDivideByZeroThrows() {
        let first = Digits(string: "1", base: 10)!
        let second = Digits(string: "0", base: 10)!
        XCTAssertThrowsError(try first.divide(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.message, Digits.divideErrorMessage)
        }
    }

    func testInvertZeroThrows() {
        let first = Digits(string: "0", base: 10)!
        XCTAssertThrowsError(try first.invert()) { error in
            XCTAssertEqual((error as? DigitsError)?.message, Digits.invertErrorMessage)
        }
    }

    func testAdditionOverflowThrows() {
        let first = Digits(longLong: Int64.max)
        let second = Digits(longLong: 1)
        XCTAssertThrowsError(try first.plus(second))
    }

    // MARK: exact (Rational) division and inversion

    /// The headline fix: division used to truncate like Int64's `/` (`7 / 2`
    /// gave `3`); it's now the exact reduced fraction.
    func testDivideNonExactProducesReducedFraction() {
        let first = Digits(string: "7", base: 10)!
        let second = Digits(string: "2", base: 10)!
        let result = try? first.divide(second)
        XCTAssertEqual(result?.rationalValue, Rational(numerator: 7, denominator: 2))
        XCTAssertEqual(result?.description, "7:2")
    }

    func testDivideReducesToLowestTerms() {
        let first = Digits(string: "6", base: 10)!
        let second = Digits(string: "4", base: 10)!
        let result = try? first.divide(second)
        XCTAssertEqual(result?.description, "3:2") // not "6:4"
    }

    func testDivideNegativeProducesCorrectlySignedFraction() {
        let first = Digits(string: "-7", base: 10)!
        let second = Digits(string: "2", base: 10)!
        let result = try? first.divide(second)
        XCTAssertEqual(result?.description, "-7:2")
    }

    /// The one case `Digits.divide` used to special-case explicitly
    /// (`Int64.min / -1` overflows `Int64`'s negation) - `Rational.init`
    /// now catches this generally, but `divide` still needs to surface it
    /// as an error rather than a wrong answer.
    func testDivideInt64MinByNegativeOneThrowsOverflow() {
        let first = Digits(longLong: Int64.min)
        let second = Digits(longLong: -1)
        XCTAssertThrowsError(try first.divide(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.message, "division overflow")
        }
    }

    func testInvertNonUnitProducesExactFraction() {
        let first = Digits(string: "3", base: 10)!
        let result = try? first.invert()
        XCTAssertEqual(result?.description, "1:3") // not the old truncated "0"
    }

    func testInvertOfAFractionFlipsNumeratorAndDenominator() throws {
        let seven = Digits(string: "7", base: 10)!
        let two = Digits(string: "2", base: 10)!
        let sevenHalves = try seven.divide(two)
        let result = try sevenHalves?.invert()
        XCTAssertEqual(result?.description, "2:7")
    }

    func testAddingTwoFractionsCrossMultiplies() throws {
        let oneHalf = try Digits(string: "1", base: 10)!.divide(Digits(string: "2", base: 10)!)
        let oneThird = try Digits(string: "1", base: 10)!.divide(Digits(string: "3", base: 10)!)
        let result = try oneHalf?.plus(oneThird)
        XCTAssertEqual(result?.description, "5:6")
    }

    // MARK: shift left / shift right

    func testShiftedLeftMultipliesByBase() {
        let digits = Digits(string: "5", base: 10)!
        XCTAssertEqual(try? digits.shiftedLeft().integerValue, 50)
    }

    func testShiftedRightDropsLastDigit() {
        let digits = Digits(string: "57", base: 10)!
        XCTAssertEqual(try? digits.shiftedRight().integerValue, 5)
    }

    func testShiftedRightOnNegativeDropsLastDigitKeepingSign() {
        // Matches "drop the last digit, keep the sign" (Swift's Int64 `/`
        // already truncates toward zero, which is exactly this).
        let digits = Digits(string: "-57", base: 10)!
        XCTAssertEqual(try? digits.shiftedRight().integerValue, -5)
    }

    func testShiftedLeftOverflowThrows() {
        let digits = Digits(longLong: Int64.max)
        XCTAssertThrowsError(try digits.shiftedLeft())
    }

    func testShiftUndefinedForAFractionThrows() throws {
        let sevenHalves = try Digits(string: "7", base: 10)!.divide(Digits(string: "2", base: 10)!)
        XCTAssertThrowsError(try sevenHalves?.shiftedLeft())
        XCTAssertThrowsError(try sevenHalves?.shiftedRight())
    }

    func testPowerChaining() {
        let first = Digits(string: "2", base: 10)!
        let second = Digits(string: "3", base: 10)!
        let third = Digits(string: "4", base: 10)!
        let result = try? first.power(second)?.power(third)
        XCTAssertEqual(result?.integerValue, 4096)
    }

    func testPowerZeroToZeroThrows() {
        let first = Digits(string: "0", base: 10)!
        let second = Digits(string: "0", base: 10)!
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.message, Digits.zeroPowerOfZeroErrorMessage)
        }
    }

    func testPowerZeroToNegativeThrows() {
        let first = Digits(string: "0", base: 10)!
        let second = Digits(string: "-1", base: 10)!
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.message, Digits.negativePowerOfZeroErrorMessage)
        }
    }

    func testPowerNegativeBaseToFractionalExponentThrows() {
        let first = Digits(string: "-1", base: 10)!
        let second = Digits(string: ".5", base: 10)!
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.message, Digits.fractionalPowerOfNegativeErrorMessage)
        }
    }

    func testPowerOf2Up63Bits() {
        let first = Digits(string: "2", base: 10)!
        let second = Digits(string: "62", base: 10)!
        let result = try? first.power(second)
        XCTAssertEqual(result?.integerValue, 0x4000000000000000)
    }

    /// Regression test for a real exactness bug: `power()` used to compute
    /// its result via `pow(Double(a), Double(b))`, but `7^19` exceeds
    /// `Double`'s 53-bit exact-integer range (~9x10^15) while still fitting
    /// comfortably in `Int64` (~9.2x10^18) - `pow` rounded it to
    /// 11398895185373144, one too high, with no overflow to signal anything
    /// was wrong. `checkedPower`'s integer-only exponentiation-by-squaring
    /// must get this exact.
    func testPowerExactPastDoublePrecision() {
        let first = Digits(string: "7", base: 10)!
        let second = Digits(string: "19", base: 10)!
        let result = try? first.power(second)
        XCTAssertEqual(result?.integerValue, 11398895185373143)
    }

    func testPowerOverflowThrows() {
        let first = Digits(string: "10", base: 10)!
        let second = Digits(string: "19", base: 10)!
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.message, "power overflow")
        }
    }

    // MARK: allowsPoint ("FloatingDigits") behavior

    func testAllowsPointConvertDoubleRoundTrips() {
        XCTAssertEqual(Digits.convertDouble(0.1, toBase: 10), "0.1")
        XCTAssertEqual(Digits.convertDouble(-10.1, toBase: 10), "-10.1")
        XCTAssertEqual(Digits.convertDouble(0, toBase: 10), "0")
        XCTAssertNil(Digits.convertDouble(.nan, toBase: 10))
        XCTAssertNil(Digits.convertDouble(.infinity, toBase: 10))
    }

    func testAllowsPointDoubleValue() {
        let digits = Digits(double: 1.1, base: 10)!
        XCTAssertEqual(digits.doubleValue, 1.1, accuracy: 0.0000001)
    }

    func testAllowsPointArithmeticUsesDoubleMath() {
        let first = Digits(double: 3, base: 10)!
        let second = Digits(double: 2, base: 10)!
        let third = Digits(double: 1, base: 10)!
        let result = try? first.divide(second)?.divide(third)
        XCTAssertEqual(result?.doubleValue ?? .nan, 1.5, accuracy: 0.0000001)
    }

    func testAllowsPointNegatePushPoint() {
        let digits = Digits(string: "", base: 10, allowsPoint: true)!
        digits.negate()
        digits.pushDigit(".")
        digits.pushDigit("2")
        XCTAssertEqual(digits.signedDigits, "-0.2")
        XCTAssertEqual(digits.doubleValue, -0.2, accuracy: 0.0000001)
    }
}
