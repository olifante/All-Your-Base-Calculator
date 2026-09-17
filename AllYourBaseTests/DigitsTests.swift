//
//  DigitsTests.swift
//  AllYourBaseTests
//
//  Ported from the Objective-C `DigitsTests` (SenTestingKit/`STAssert*`).
//
//  A handful of the original tests are intentionally not ported:
//  - `test*TimesNil`/`test*DivideNil`/`test*PowerNil`/`testInitWithStringNil`:
//    they exercised passing `nil` as a second operand or as the string to
//    parse. `Digits`' Swift API takes non-optional `Digits`/`String`
//    parameters, so the compiler now rules these cases out entirely - a
//    stronger guarantee than the old runtime nil check.
//  - `test*0PowerNil`: same reason.
//  - `testInitWithIntegral0x8000000000000000LL`, `testInitWithString2Power63`,
//    `testInitWithString2Power62Times2`: these relied on C's
//    implementation-defined/undefined behavior when an unsuffixed hex
//    literal wider than `long long` gets implicitly converted (the
//    "positive 0x8000000000000000" test), or when casting a `double`
//    outside `long long`'s range to `long long` (2^63 doesn't fit in a
//    signed 64-bit integer, so `pow(2, 63)` cast to `long long` is
//    undefined behavior in C). Swift has no such implicit-conversion traps:
//    integer literals are exact, and `Int64(exactly:)` fails cleanly
//    instead of invoking undefined behavior. The unambiguous, in-range
//    sibling tests (`testInitWithIntegralNegative0x8000000000000000LL`,
//    `testInitWithString2Power62`, `testInitWithString2Power61Times2`) are
//    kept, and `Digits.power` now throws `.overflow` for `2 ^ 63` instead
//    of silently wrapping.
//  - The `convertInteger` tests that passed a `Double` literal (e.g. `0.1`)
//    to a `long long` parameter to test C's implicit truncation
//    (`testConvert0Point1ToBase10` and its siblings): `Digits.convertInteger`
//    takes an `Int64`, so passing a `Double` is a compile error, not a
//    runtime truncation - again a stronger guarantee than the original.

import XCTest
@testable import AllYourBase

final class DigitsTests: XCTestCase {

    // MARK: convertInteger

    func testConvert0ToBase10() {
        XCTAssertEqual(Digits.convertInteger(0, toBase: 10), "0")
    }

    func testConvert1ToBase10() {
        XCTAssertEqual(Digits.convertInteger(1, toBase: 10), "1")
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

    func testConvert65535ToBase2() {
        XCTAssertEqual(Digits.convertInteger(65535, toBase: 2), "1111111111111111")
    }

    func testConvert65536ToBase16() {
        XCTAssertEqual(Digits.convertInteger(65536, toBase: 16), "10000")
    }

    func testConvert65536ToBase2() {
        XCTAssertEqual(Digits.convertInteger(65536, toBase: 2), "10000000000000000")
    }

    func testConvertNegative0ToBase10() {
        XCTAssertEqual(Digits.convertInteger(0, toBase: 10), "0")
    }

    func testConvertNegative1ToBase10() {
        XCTAssertEqual(Digits.convertInteger(-1, toBase: 10), "-1")
    }

    func testConvertNegative46656ToBase16() {
        XCTAssertEqual(Digits.convertInteger(-46656, toBase: 16), "-B640")
    }

    func testConvertNegative46656ToBase2() {
        XCTAssertEqual(Digits.convertInteger(-46656, toBase: 2), "-1011011001000000")
    }

    func testConvertNegative65536ToBase16() {
        XCTAssertEqual(Digits.convertInteger(-65536, toBase: 16), "-10000")
    }

    func testConvertNegative65535ToBase16() {
        XCTAssertEqual(Digits.convertInteger(-65535, toBase: 16), "-FFFF")
    }

    func testConvertNegative65536ToBase2() {
        XCTAssertEqual(Digits.convertInteger(-65536, toBase: 2), "-10000000000000000")
    }

    func testConvertNegative65535ToBase2() {
        XCTAssertEqual(Digits.convertInteger(-65535, toBase: 2), "-1111111111111111")
    }

    // MARK: init

    func testInit() {
        let digits = Digits()
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testInitWithIntegral0() {
        let digits = Digits(longLong: 0)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
    }

    func testInitWithIntegral0x7fffffff() {
        let digits = Digits(longLong: 0x7fffffff)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0x7fffffff)
        XCTAssertEqual(digits.unsignedDigits, "2147483647")
        XCTAssertEqual(digits.signedDigits, "2147483647")
    }

    func testInitWithIntegral0x80000000() {
        let digits = Digits(longLong: 0x80000000)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0x80000000)
        XCTAssertEqual(digits.unsignedDigits, "2147483648")
        XCTAssertEqual(digits.signedDigits, "2147483648")
    }

    func testInitWithIntegral0x1000000000000000LL() {
        let digits = Digits(longLong: 0x1000000000000000)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0x1000000000000000)
        XCTAssertEqual(digits.unsignedDigits, "1152921504606846976")
        XCTAssertEqual(digits.signedDigits, "1152921504606846976")
    }

    func testInitWithIntegral0x2000000000000000LL() {
        let digits = Digits(longLong: 0x2000000000000000)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0x2000000000000000)
        XCTAssertEqual(digits.unsignedDigits, "2305843009213693952")
        XCTAssertEqual(digits.signedDigits, "2305843009213693952")
    }

    func testInitWithIntegral0x2000000000000000LLbase16() {
        let digits = Digits(longLong: 0x2000000000000000, base: 16)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.integerValue, 0x2000000000000000)
        XCTAssertEqual(digits.unsignedDigits, "2000000000000000")
        XCTAssertEqual(digits.signedDigits, "2000000000000000")
    }

    func testInitWithIntegral0x4000000000000000LL() {
        let digits = Digits(longLong: 0x4000000000000000)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0x4000000000000000)
        XCTAssertEqual(digits.unsignedDigits, "4611686018427387904")
        XCTAssertEqual(digits.signedDigits, "4611686018427387904")
    }

    func testInitWithIntegralNegative0x8000000000000000LL() {
        let digits = Digits(longLong: Int64.min)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, Int64.min)
        XCTAssertEqual(digits.unsignedDigits, "9223372036854775808")
        XCTAssertEqual(digits.signedDigits, "-9223372036854775808")
    }

    func testInitWithIntegral1234567890() {
        let digits = Digits(longLong: 1234567890)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "1234567890")
    }

    func testInitWithIntegral1234567890Base16() {
        let digits = Digits(longLong: 1234567890, base: 16)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "499602D2")
    }

    func testInitWithIntegral1234567890Base2() {
        let digits = Digits(longLong: 1234567890, base: 2)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 2)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1001001100101100000001011010010")
        XCTAssertEqual(digits.signedDigits, "1001001100101100000001011010010")
    }

    func testInitWithIntegral1234567890Base8() {
        let digits = Digits(longLong: 1234567890, base: 8)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 8)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "11145401322")
        XCTAssertEqual(digits.signedDigits, "11145401322")
    }

    func testInitWithIntegralNegative0x80000000() {
        let digits = Digits(longLong: -0x80000000)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -0x80000000)
        XCTAssertEqual(digits.unsignedDigits, "2147483648")
        XCTAssertEqual(digits.signedDigits, "-2147483648")
    }

    func testInitWithIntegralNegative0x80000001() {
        let digits = Digits(longLong: -0x80000001)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -0x80000001)
        XCTAssertEqual(digits.unsignedDigits, "2147483649")
        XCTAssertEqual(digits.signedDigits, "-2147483649")
    }

    func testInitWithIntegralNegative1234567890() {
        let digits = Digits(longLong: -1234567890)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "-1234567890")
    }

    func testInitWithIntegralNegative1234567890Base16() {
        let digits = Digits(longLong: -1234567890, base: 16)!
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.integerValue, -1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "-499602D2")
    }

    func testInitWithIntegralNegative46656() {
        let digits = Digits(longLong: -46656)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -46656)
        XCTAssertEqual(digits.unsignedDigits, "46656")
        XCTAssertEqual(digits.signedDigits, "-46656")
    }

    // MARK: arithmetic via initWithString

    func testInitWithString0Divide1Divide2() throws {
        let first = Digits(string: "0")
        let second = Digits(string: "1")
        let third = Digits(string: "2")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.integerValue, 0)
    }

    func testInitWithString0Invert() {
        let first = Digits(string: "0")
        XCTAssertThrowsError(try first.invert()) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.invertByZero.errorDescription)
        }
    }

    func testInitWithString0Plus1PlusMinus2() throws {
        let first = Digits(string: "0")
        let second = Digits(string: "1")
        let third = Digits(string: "-2")
        let result = try first.plus(second).plus(third)
        XCTAssertEqual(result.integerValue, -1)
    }

    func testInitWithString0Minus1Minus2() throws {
        let first = Digits(string: "0")
        let second = Digits(string: "1")
        let third = Digits(string: "2")
        let result = try first.minus(second).minus(third)
        XCTAssertEqual(result.integerValue, -3)
    }

    func testInitWithString0Times1Times2() throws {
        let first = Digits(string: "0")
        let second = Digits(string: "1")
        let third = Digits(string: "2")
        let result = try first.times(second).times(third)
        XCTAssertEqual(result.integerValue, 0)
    }

    func testInitWithString0Point1() {
        let digits = Digits(string: "0.1")
        XCTAssertEqual(digits.integerValue, 0) // and not 0.1
    }

    func testInitWithString0Point1Times1() throws {
        let first = Digits(string: "0.1")
        let second = Digits(string: "1")
        let result = try first.times(second)
        XCTAssertEqual(result.integerValue, 0) // and not 0.1
    }

    func testInitWithString0Power0() {
        let first = Digits(string: "0")
        let second = Digits(string: "0")
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.zeroPowerOfZero.errorDescription)
        }
    }

    func testInitWithString0PowerNegative1() {
        let first = Digits(string: "0")
        let second = Digits(string: "-1")
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.negativePowerOfZero.errorDescription)
        }
    }

    func testInitWithString0Power1Power2() throws {
        let first = Digits(string: "0")
        let second = Digits(string: "1")
        let third = Digits(string: "2")
        let result = try first.power(second).power(third)
        XCTAssertEqual(result.integerValue, 0)
    }

    func testInitWithString1Power2Power3() throws {
        let first = Digits(string: "1")
        let second = Digits(string: "2")
        let third = Digits(string: "3")
        let result = try first.power(second).power(third)
        XCTAssertEqual(result.integerValue, 1)
    }

    func testInitWithString1073741824Times2() throws {
        let first = Digits(string: "1073741824")
        let second = Digits(string: "2")
        let result = try first.times(second)
        XCTAssertEqual(result.integerValue, 0x80000000)
    }

    func testInitWithString1Point1() {
        let digits = Digits(string: "1.1")
        XCTAssertEqual(digits.integerValue, 1) // and not 1.1
    }

    func testInitWithString1Point1Times2() throws {
        let first = Digits(string: "1.1")
        let second = Digits(string: "2")
        let result = try first.times(second)
        XCTAssertEqual(result.integerValue, 2) // and not 2.2
    }

    func testInitWithString1Times2TimesMinus3() throws {
        let first = Digits(string: "1")
        let second = Digits(string: "2")
        let third = Digits(string: "-3")
        let result = try first.times(second).times(third)
        XCTAssertEqual(result.integerValue, -6)
    }

    func testInitWithString1Divide0() {
        let first = Digits(string: "1")
        let second = Digits(string: "0")
        XCTAssertThrowsError(try first.divide(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.divideByZero.errorDescription)
        }
    }

    func testInitWithString1234567890() {
        let digits = Digits(string: "1234567890")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "1234567890")
    }

    func testInitWithString1234567890abc() {
        let digits = Digits(string: "1234567890abc")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "1234567890")
    }

    func testInitWithString1001001100101100000001011010010Base2() {
        let digits = Digits(string: "1001001100101100000001011010010", base: 2)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 2)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1001001100101100000001011010010")
        XCTAssertEqual(digits.signedDigits, "1001001100101100000001011010010")
    }

    func testInitWithString1234567890Base8() {
        let digits = Digits(string: "11145401322", base: 8)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 8)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "11145401322")
        XCTAssertEqual(digits.signedDigits, "11145401322")
    }

    func testInitWithString1Divide2Divide3() throws {
        let first = Digits(string: "1")
        let second = Digits(string: "2")
        let third = Digits(string: "3")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.integerValue, 0)
    }

    func testInitWithString24Divide4DivideNegative3() throws {
        let first = Digits(string: "24")
        let second = Digits(string: "4")
        let third = Digits(string: "-3")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.integerValue, -2)
    }

    func testInitWithString2Power3Power4() throws {
        let first = Digits(string: "2")
        let second = Digits(string: "3")
        let third = Digits(string: "4")
        let result = try first.power(second).power(third)
        XCTAssertEqual(result.integerValue, 4096)
    }

    func testInitWithString2Power61() throws {
        let first = Digits(string: "2")
        let second = Digits(string: "61")
        let result = try first.power(second)
        XCTAssertEqual(result.integerValue, 0x2000000000000000)
    }

    func testInitWithString2Power62() throws {
        let first = Digits(string: "2")
        let second = Digits(string: "62")
        let result = try first.power(second)
        XCTAssertEqual(result.integerValue, 0x4000000000000000)
    }

    func testInitWithString2Power61Times2() throws {
        let first = Digits(string: "2")
        let second = Digits(string: "61")
        let third = Digits(string: "2")
        let result = try first.power(second).times(third)
        XCTAssertEqual(result.integerValue, 0x4000000000000000)
    }

    func testInitWithString3Divide2Divide1() throws {
        let first = Digits(string: "3")
        let second = Digits(string: "2")
        let third = Digits(string: "1")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.integerValue, 1) // and not 1.5
    }

    func testInitWithString499602D2Base16() {
        let digits = Digits(string: "499602D2", base: 16)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.integerValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "499602D2")
    }

    func testInitWithStringNegative12() {
        let digits = Digits(string: "-12")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -12)
        XCTAssertEqual(digits.unsignedDigits, "12")
        XCTAssertEqual(digits.signedDigits, "-12")
    }

    func testInitWithStringNegative499602D2Base16() {
        let digits = Digits(string: "-499602D2", base: 16)!
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.integerValue, -1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "-499602D2")
    }

    func testInitWithStringNegative1PowerPoint5() {
        let first = Digits(string: "-1")
        let second = Digits(string: ".5")
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.fractionalPowerOfNegative.errorDescription)
        }
    }

    func testInitWithStringNegative46656Times2() throws {
        let first = Digits(string: "-46656")
        let second = Digits(string: "2")
        let result = try first.times(second)
        XCTAssertEqual(result.integerValue, -93312)
    }

    func testInitWithStringNegative46656Power2() throws {
        let first = Digits(string: "-46656")
        let second = Digits(string: "2")
        let result = try first.power(second)
        XCTAssertEqual(result.integerValue, 2176782336)
    }

    func testInitWithEmptyStringBase1() {
        XCTAssertNil(Digits(string: "", base: 1))
    }

    func testInitWithStringSpace123SpaceSpace() {
        let digits = Digits(string: "  123 ")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 123)
        XCTAssertEqual(digits.unsignedDigits, "123")
        XCTAssertEqual(digits.signedDigits, "123")
    }

    func testInitWithStringSpaceNegative123abc456SpaceSpace() {
        let digits = Digits(string: "  -123abc456 ")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -123)
        XCTAssertEqual(digits.unsignedDigits, "123")
        XCTAssertEqual(digits.signedDigits, "-123")
    }

    // MARK: negate

    func testNegate() {
        var digits = Digits()
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testNegateNegative0x8000000000000000LL() {
        var digits = Digits(longLong: Int64.min)
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, Int64.min)
        XCTAssertEqual(digits.unsignedDigits, "9223372036854775808")
        XCTAssertEqual(digits.signedDigits, "-9223372036854775808")
    }

    func testNegate0x7FFFFFFFFFFFFFFFLL() {
        var digits = Digits(longLong: Int64.max)
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -Int64.max)
        XCTAssertEqual(digits.unsignedDigits, "9223372036854775807")
        XCTAssertEqual(digits.signedDigits, "-9223372036854775807")
    }

    func testNegatePop() {
        var digits = Digits()
        XCTAssertFalse(digits.startsWithMinus)
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.popDigit(), "0")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertEqual(digits.signedDigits, "-")
        XCTAssertEqual(digits.description, "-")
    }

    func testNegatePopPop() {
        var digits = Digits()
        XCTAssertFalse(digits.startsWithMinus)
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        digits.popDigit()
        XCTAssertEqual(digits.popDigit(), "-")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testNegatePush0() {
        var digits = Digits()
        digits.negate()
        digits.pushDigit("0")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testNegatePush1() {
        var digits = Digits()
        digits.negate()
        digits.pushDigit("1")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, -1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "-1")
        XCTAssertEqual(digits.description, "-1")
    }

    func testNegatePushPoint() {
        var digits = Digits()
        digits.negate()
        digits.pushDigit(".")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "-0.")
        XCTAssertEqual(digits.description, "-0.")
    }

    func testNegatePushPoint2() {
        var digits = Digits()
        digits.negate()
        digits.pushDigit(".")
        digits.pushDigit("2")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.2")
        XCTAssertEqual(digits.signedDigits, "-0.2")
        XCTAssertEqual(digits.description, "-0.2")
    }

    // MARK: push / pop

    func testPush0() {
        var digits = Digits()
        digits.pushDigit("0")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
        XCTAssertEqual(digits.description, "0")
    }

    func testPush00() {
        var digits = Digits()
        digits.pushDigit("0")
        digits.pushDigit("0")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
        XCTAssertEqual(digits.description, "0")
    }

    func testPush0Point() {
        var digits = Digits()
        digits.pushDigit("0")
        digits.pushDigit(".")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "0.")
        XCTAssertEqual(digits.description, "0.")
    }

    func testPush0Pop() {
        var digits = Digits()
        digits.pushDigit("0")
        XCTAssertEqual(digits.popDigit(), "0")
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testPush0Point1() {
        var digits = Digits()
        digits.pushDigit("0")
        digits.pushDigit(".")
        digits.pushDigit("1")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.1")
        XCTAssertEqual(digits.signedDigits, "0.1")
        XCTAssertEqual(digits.description, "0.1")
    }

    func testPush0Negate() {
        var digits = Digits()
        digits.pushDigit("0")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testPush1() {
        var digits = Digits()
        digits.pushDigit("1")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "1")
    }

    func testPush1Point() {
        var digits = Digits()
        digits.pushDigit("1")
        digits.pushDigit(".")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1.")
        XCTAssertEqual(digits.signedDigits, "1.")
        XCTAssertEqual(digits.description, "1.")
    }

    func testPush1Point2() {
        var digits = Digits()
        digits.pushDigit("1")
        digits.pushDigit(".")
        digits.pushDigit("2")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1.2")
        XCTAssertEqual(digits.signedDigits, "1.2")
        XCTAssertEqual(digits.description, "1.2")
    }

    func testPush1And2And3() {
        var digits = Digits()
        digits.pushDigit("1")
        digits.pushDigit("2")
        digits.pushDigit("3")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 123)
        XCTAssertEqual(digits.unsignedDigits, "123")
        XCTAssertEqual(digits.signedDigits, "123")
    }

    func testPush9And18Zeros() {
        var digits = Digits()
        digits.pushDigit("9")
        for _ in 0..<18 {
            digits.pushDigit("0")
        }
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 9_000_000_000_000_000_000)
        XCTAssertEqual(digits.unsignedDigits, "9000000000000000000")
        XCTAssertEqual(digits.signedDigits, "9000000000000000000")
    }

    func testPush9And19ZerosStopsAtOverflow() {
        // The 19th trailing zero would overflow Int64, so the overflow
        // guard silently rejects it, leaving the same value as 18 zeros.
        var digits = Digits()
        digits.pushDigit("9")
        for _ in 0..<19 {
            digits.pushDigit("0")
        }
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 9_000_000_000_000_000_000)
        XCTAssertEqual(digits.unsignedDigits, "9000000000000000000")
        XCTAssertEqual(digits.signedDigits, "9000000000000000000")
    }

    func testPush123() {
        var digits = Digits()
        digits.pushDigit("123") // not a single digit, rejected
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testPush1AndA() {
        var digits = Digits()
        digits.pushDigit("1")
        digits.pushDigit("A") // not a base-10 digit, rejected
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "1")
    }

    func testPush1Pop() {
        var digits = Digits()
        digits.pushDigit("1")
        XCTAssertEqual(digits.popDigit(), "1")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testPush1And2And3Pop() {
        var digits = Digits()
        digits.pushDigit("1")
        digits.pushDigit("2")
        digits.pushDigit("3")
        XCTAssertEqual(digits.popDigit(), "3")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 12)
        XCTAssertEqual(digits.unsignedDigits, "12")
        XCTAssertEqual(digits.signedDigits, "12")
    }

    func testPush1Negate() {
        var digits = Digits()
        digits.pushDigit("1")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, -1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "-1")
        XCTAssertEqual(digits.description, "-1")
    }

    func testPushPoint() {
        var digits = Digits()
        digits.pushDigit(".")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "0.")
        XCTAssertEqual(digits.description, "0.")
    }

    func testPushPointPoint() {
        var digits = Digits()
        digits.pushDigit(".")
        digits.pushDigit(".") // rejected, point already present
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "0.")
        XCTAssertEqual(digits.description, "0.")
    }

    func testPushPoint3() {
        var digits = Digits()
        digits.pushDigit(".")
        digits.pushDigit("3")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.3")
        XCTAssertEqual(digits.signedDigits, "0.3")
        XCTAssertEqual(digits.description, "0.3")
    }

    func testPushPoint5Negate() {
        var digits = Digits()
        digits.pushDigit(".")
        digits.pushDigit("5")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.5")
        XCTAssertEqual(digits.signedDigits, "-0.5")
        XCTAssertEqual(digits.description, "-0.5")
    }

    func testPushPointNegate() {
        var digits = Digits()
        digits.pushDigit(".")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.integerValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "-0.")
        XCTAssertEqual(digits.description, "-0.")
    }

    func testPushPop() {
        var digits = Digits()
        XCTAssertNil(digits.popDigit())
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }
}
