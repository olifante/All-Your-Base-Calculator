//
//  FloatingDigitsTests.swift
//  AllYourBaseTests
//
//  Ported from the Objective-C `FloatingDigitsTests` (SenTestingKit).
//
//  As in `DigitsTests.swift`, the tests that only existed to exercise
//  passing `nil` as a second operand or as the string to parse
//  (`test*TimesNil`, `test*DivideNil`, `test*PowerNil`, `testInitWithStringNil`)
//  are not ported: `FloatingDigits`' Swift API takes non-optional
//  parameters, so the compiler rules those cases out entirely.

import XCTest
@testable import AllYourBase

final class FloatingDigitsTests: XCTestCase {

    // MARK: convertDouble

    func testConvert0Point1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(0.1, toBase: 10), "0.1")
    }

    func testConvert0ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(0, toBase: 10), "0")
    }

    func testConvert10Point1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(10.1, toBase: 10), "10.1")
    }

    func testConvert1Point1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(1.1, toBase: 10), "1.1")
    }

    func testConvert1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(1, toBase: 10), "1")
    }

    func testConvert46656ToBase16() {
        XCTAssertEqual(FloatingDigits.convertDouble(46656, toBase: 16), "B640")
    }

    func testConvert46656ToBase2() {
        XCTAssertEqual(FloatingDigits.convertDouble(46656, toBase: 2), "1011011001000000")
    }

    func testConvert65535ToBase16() {
        XCTAssertEqual(FloatingDigits.convertDouble(65535, toBase: 16), "FFFF")
    }

    func testConvert65535ToBase2() {
        XCTAssertEqual(FloatingDigits.convertDouble(65535, toBase: 2), "1111111111111111")
    }

    func testConvert65536ToBase16() {
        XCTAssertEqual(FloatingDigits.convertDouble(65536, toBase: 16), "10000")
    }

    func testConvert65536ToBase2() {
        XCTAssertEqual(FloatingDigits.convertDouble(65536, toBase: 2), "10000000000000000")
    }

    func testConvertNegative0Point1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(-0.1, toBase: 10), "-0.1")
    }

    func testConvertNegative0ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(-0, toBase: 10), "0")
    }

    func testConvertNegative1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(-1, toBase: 10), "-1")
    }

    func testConvertNegative10PointToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(-10.1, toBase: 10), "-10.1")
    }

    func testConvertNegative1Point1ToBase10() {
        XCTAssertEqual(FloatingDigits.convertDouble(-1.1, toBase: 10), "-1.1")
    }

    func testConvertNegative46656ToBase16() {
        XCTAssertEqual(FloatingDigits.convertDouble(-46656, toBase: 16), "-B640")
    }

    func testConvertNegative46656ToBase2() {
        XCTAssertEqual(FloatingDigits.convertDouble(-46656, toBase: 2), "-1011011001000000")
    }

    func testConvertNegative65536ToBase16() {
        XCTAssertEqual(FloatingDigits.convertDouble(-65536, toBase: 16), "-10000")
    }

    func testConvertNegative65535ToBase16() {
        XCTAssertEqual(FloatingDigits.convertDouble(-65535, toBase: 16), "-FFFF")
    }

    func testConvertNegative65536ToBase2() {
        XCTAssertEqual(FloatingDigits.convertDouble(-65536, toBase: 2), "-10000000000000000")
    }

    func testConvertNegative65535ToBase2() {
        XCTAssertEqual(FloatingDigits.convertDouble(-65535, toBase: 2), "-1111111111111111")
    }

    // MARK: init

    func testInit() {
        let digits = FloatingDigits()
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testInitWithDouble0() {
        let digits = FloatingDigits(double: 0)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
    }

    func testInitWithDouble0x7fffffff() {
        let digits = FloatingDigits(double: Double(0x7fffffff))
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, Double(0x7fffffff))
        XCTAssertEqual(digits.unsignedDigits, "2147483647")
        XCTAssertEqual(digits.signedDigits, "2147483647")
    }

    func testInitWithDouble0x80000000() {
        let digits = FloatingDigits(double: Double(0x80000000))
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, Double(0x80000000))
        XCTAssertEqual(digits.unsignedDigits, "2147483648")
        XCTAssertEqual(digits.signedDigits, "2147483648")
    }

    func testInitWithDouble1234567890() {
        let digits = FloatingDigits(double: 1234567890)
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "1234567890")
    }

    func testInitWithDouble1234567890Base16() {
        let digits = FloatingDigits(double: 1234567890, base: 16)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "499602D2")
    }

    func testInitWithDouble1234567890Base2() {
        let digits = FloatingDigits(double: 1234567890, base: 2)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 2)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1001001100101100000001011010010")
        XCTAssertEqual(digits.signedDigits, "1001001100101100000001011010010")
    }

    func testInitWithDouble1234567890Base8() {
        let digits = FloatingDigits(double: 1234567890, base: 8)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 8)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "11145401322")
        XCTAssertEqual(digits.signedDigits, "11145401322")
    }

    func testInitWithDoubleNegative0x80000000() {
        let digits = FloatingDigits(double: -Double(0x80000000))
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -Double(0x80000000))
        XCTAssertEqual(digits.unsignedDigits, "2147483648")
        XCTAssertEqual(digits.signedDigits, "-2147483648")
    }

    func testInitWithDoubleNegative0x80000001() {
        let digits = FloatingDigits(double: -Double(0x80000001))
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -Double(0x80000001))
        XCTAssertEqual(digits.unsignedDigits, "2147483649")
        XCTAssertEqual(digits.signedDigits, "-2147483649")
    }

    func testInitWithDoubleNegative1234567890() {
        let digits = FloatingDigits(double: -1234567890)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "-1234567890")
    }

    func testInitWithDoubleNegative1234567890Base16() {
        let digits = FloatingDigits(double: -1234567890, base: 16)!
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.doubleValue, -1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "-499602D2")
    }

    func testInitWithDoubleNegative46656() {
        let digits = FloatingDigits(double: -46656)
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -46656)
        XCTAssertEqual(digits.unsignedDigits, "46656")
        XCTAssertEqual(digits.signedDigits, "-46656")
    }

    // MARK: arithmetic via initWithString

    func testInitWithString0Divide1Divide2() throws {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "1")
        let third = FloatingDigits(string: "2")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.doubleValue, 0)
    }

    func testInitWithString0Invert() {
        let first = FloatingDigits(string: "0")
        XCTAssertThrowsError(try first.invert()) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.invertByZero.errorDescription)
        }
    }

    func testInitWithString0Plus1PlusMinus2() throws {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "1")
        let third = FloatingDigits(string: "-2")
        let result = try first.plus(second).plus(third)
        XCTAssertEqual(result.doubleValue, -1)
    }

    func testInitWithString0Minus1Minus2() throws {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "1")
        let third = FloatingDigits(string: "2")
        let result = try first.minus(second).minus(third)
        XCTAssertEqual(result.doubleValue, -3)
    }

    func testInitWithString0Times1Times2() throws {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "1")
        let third = FloatingDigits(string: "2")
        let result = try first.times(second).times(third)
        XCTAssertEqual(result.doubleValue, 0)
    }

    func testInitWithString0Point1() {
        let digits = FloatingDigits(string: "0.1")
        XCTAssertEqual(digits.doubleValue, 0.1)
    }

    func testInitWithString0Point1Times1() throws {
        let first = FloatingDigits(string: "0.1")
        let second = FloatingDigits(string: "1")
        let result = try first.times(second)
        XCTAssertEqual(result.doubleValue, 0.1)
    }

    func testInitWithString0Power0() {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "0")
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.zeroPowerOfZero.errorDescription)
        }
    }

    func testInitWithString0PowerNegative1() {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "-1")
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.negativePowerOfZero.errorDescription)
        }
    }

    func testInitWithString0Power1Power2() throws {
        let first = FloatingDigits(string: "0")
        let second = FloatingDigits(string: "1")
        let third = FloatingDigits(string: "2")
        let result = try first.power(second).power(third)
        XCTAssertEqual(result.doubleValue, 0)
    }

    func testInitWithString1Power2Power3() throws {
        let first = FloatingDigits(string: "1")
        let second = FloatingDigits(string: "2")
        let third = FloatingDigits(string: "3")
        let result = try first.power(second).power(third)
        XCTAssertEqual(result.doubleValue, 1)
    }

    func testInitWithString1073741824Times2() throws {
        let first = FloatingDigits(string: "1073741824")
        let second = FloatingDigits(string: "2")
        let result = try first.times(second)
        XCTAssertEqual(result.doubleValue, Double(0x80000000))
    }

    func testInitWithString1Point1() {
        let digits = FloatingDigits(string: "1.1")
        XCTAssertEqual(digits.doubleValue, 1.1)
    }

    func testInitWithString1Point1Times2() throws {
        let first = FloatingDigits(string: "1.1")
        let second = FloatingDigits(string: "2")
        let result = try first.times(second)
        XCTAssertEqual(result.doubleValue, 2.2, accuracy: 0.0000000000000001)
    }

    func testInitWithString1Times2TimesMinus3() throws {
        let first = FloatingDigits(string: "1")
        let second = FloatingDigits(string: "2")
        let third = FloatingDigits(string: "-3")
        let result = try first.times(second).times(third)
        XCTAssertEqual(result.doubleValue, -6)
    }

    func testInitWithString1Divide0() {
        let first = FloatingDigits(string: "1")
        let second = FloatingDigits(string: "0")
        XCTAssertThrowsError(try first.divide(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.divideByZero.errorDescription)
        }
    }

    func testInitWithString1234567890() {
        let digits = FloatingDigits(string: "1234567890")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "1234567890")
    }

    func testInitWithString1234567890abc() {
        let digits = FloatingDigits(string: "1234567890abc")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1234567890")
        XCTAssertEqual(digits.signedDigits, "1234567890")
    }

    func testInitWithString1001001100101100000001011010010Base2() {
        let digits = FloatingDigits(string: "1001001100101100000001011010010", base: 2)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 2)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "1001001100101100000001011010010")
        XCTAssertEqual(digits.signedDigits, "1001001100101100000001011010010")
    }

    func testInitWithString1234567890Base8() {
        let digits = FloatingDigits(string: "11145401322", base: 8)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 8)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "11145401322")
        XCTAssertEqual(digits.signedDigits, "11145401322")
    }

    func testInitWithString1Divide2Divide3() throws {
        let first = FloatingDigits(string: "1")
        let second = FloatingDigits(string: "2")
        let third = FloatingDigits(string: "3")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.doubleValue, 0.166667, accuracy: 0.000001)
    }

    func testInitWithString24Divide4DivideNegative3() throws {
        let first = FloatingDigits(string: "24")
        let second = FloatingDigits(string: "4")
        let third = FloatingDigits(string: "-3")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.doubleValue, -2)
    }

    func testInitWithString2Power3Power4() throws {
        let first = FloatingDigits(string: "2")
        let second = FloatingDigits(string: "3")
        let third = FloatingDigits(string: "4")
        let result = try first.power(second).power(third)
        XCTAssertEqual(result.doubleValue, 4096)
    }

    func testInitWithString3Divide2Divide1() throws {
        let first = FloatingDigits(string: "3")
        let second = FloatingDigits(string: "2")
        let third = FloatingDigits(string: "1")
        let result = try first.divide(second).divide(third)
        XCTAssertEqual(result.doubleValue, 1.5)
    }

    func testInitWithString499602D2Base16() {
        let digits = FloatingDigits(string: "499602D2", base: 16)!
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.doubleValue, 1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "499602D2")
    }

    func testInitWithStringNegative12() {
        let digits = FloatingDigits(string: "-12")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -12)
        XCTAssertEqual(digits.unsignedDigits, "12")
        XCTAssertEqual(digits.signedDigits, "-12")
    }

    func testInitWithStringNegative499602D2Base16() {
        let digits = FloatingDigits(string: "-499602D2", base: 16)!
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 16)
        XCTAssertEqual(digits.doubleValue, -1234567890)
        XCTAssertEqual(digits.unsignedDigits, "499602D2")
        XCTAssertEqual(digits.signedDigits, "-499602D2")
    }

    func testInitWithStringNegative1PowerPoint5() {
        let first = FloatingDigits(string: "-1")
        let second = FloatingDigits(string: ".5")
        XCTAssertThrowsError(try first.power(second)) { error in
            XCTAssertEqual((error as? DigitsError)?.errorDescription, DigitsError.fractionalPowerOfNegative.errorDescription)
        }
    }

    func testInitWithStringNegative46656Times2() throws {
        let first = FloatingDigits(string: "-46656")
        let second = FloatingDigits(string: "2")
        let result = try first.times(second)
        XCTAssertEqual(result.doubleValue, -93312)
    }

    func testInitWithStringNegative46656Power2() throws {
        let first = FloatingDigits(string: "-46656")
        let second = FloatingDigits(string: "2")
        let result = try first.power(second)
        XCTAssertEqual(result.doubleValue, 2176782336)
    }

    func testInitWithEmptyStringBase1() {
        XCTAssertNil(FloatingDigits(string: "", base: 1))
    }

    func testInitWithStringSpace123SpaceSpace() {
        let digits = FloatingDigits(string: "  123 ")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 123)
        XCTAssertEqual(digits.unsignedDigits, "123")
        XCTAssertEqual(digits.signedDigits, "123")
    }

    func testInitWithStringSpaceNegative123abc456SpaceSpace() {
        let digits = FloatingDigits(string: "  -123abc456 ")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -123)
        XCTAssertEqual(digits.unsignedDigits, "123")
        XCTAssertEqual(digits.signedDigits, "-123")
    }

    // MARK: negate

    func testNegate() {
        var digits = FloatingDigits()
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testNegatePop() {
        var digits = FloatingDigits()
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
        var digits = FloatingDigits()
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
        var digits = FloatingDigits()
        digits.negate()
        digits.pushDigit("0")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testNegatePush1() {
        var digits = FloatingDigits()
        digits.negate()
        digits.pushDigit("1")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "-1")
        XCTAssertEqual(digits.description, "-1")
    }

    func testNegatePushPoint() {
        var digits = FloatingDigits()
        digits.negate()
        digits.pushDigit(".")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "-0.")
        XCTAssertEqual(digits.description, "-0.")
    }

    func testNegatePushPoint2() {
        var digits = FloatingDigits()
        digits.negate()
        digits.pushDigit(".")
        digits.pushDigit("2")
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, -0.2, accuracy: 0.0000000000000001)
        XCTAssertEqual(digits.unsignedDigits, "0.2")
        XCTAssertEqual(digits.signedDigits, "-0.2")
        XCTAssertEqual(digits.description, "-0.2")
    }

    // MARK: push / pop

    func testPush0() {
        var digits = FloatingDigits()
        digits.pushDigit("0")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.base, 10)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
        XCTAssertEqual(digits.description, "0")
    }

    func testPush00() {
        var digits = FloatingDigits()
        digits.pushDigit("0")
        digits.pushDigit("0")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "0")
        XCTAssertEqual(digits.description, "0")
    }

    func testPush0Point() {
        var digits = FloatingDigits()
        digits.pushDigit("0")
        digits.pushDigit(".")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "0.")
        XCTAssertEqual(digits.description, "0.")
    }

    func testPush0Pop() {
        var digits = FloatingDigits()
        digits.pushDigit("0")
        XCTAssertEqual(digits.popDigit(), "0")
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testPush0Point1() {
        var digits = FloatingDigits()
        digits.pushDigit("0")
        digits.pushDigit(".")
        digits.pushDigit("1")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0.1)
        XCTAssertEqual(digits.unsignedDigits, "0.1")
        XCTAssertEqual(digits.signedDigits, "0.1")
        XCTAssertEqual(digits.description, "0.1")
    }

    func testPush0Negate() {
        var digits = FloatingDigits()
        digits.pushDigit("0")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0")
        XCTAssertEqual(digits.signedDigits, "-0")
        XCTAssertEqual(digits.description, "-0")
    }

    func testPush1() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "1")
    }

    func testPush1Point() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        digits.pushDigit(".")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1.")
        XCTAssertEqual(digits.signedDigits, "1.")
        XCTAssertEqual(digits.description, "1.")
    }

    func testPush1Point2() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        digits.pushDigit(".")
        digits.pushDigit("2")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 1.2)
        XCTAssertEqual(digits.unsignedDigits, "1.2")
        XCTAssertEqual(digits.signedDigits, "1.2")
        XCTAssertEqual(digits.description, "1.2")
    }

    func testPush1And2And3() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        digits.pushDigit("2")
        digits.pushDigit("3")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 123)
        XCTAssertEqual(digits.unsignedDigits, "123")
        XCTAssertEqual(digits.signedDigits, "123")
    }

    func testPush123() {
        var digits = FloatingDigits()
        digits.pushDigit("123") // not a single digit, rejected
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testPush1AndA() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        digits.pushDigit("A") // not a base-10 digit, rejected
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "1")
    }

    func testPush1Pop() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        XCTAssertEqual(digits.popDigit(), "1")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }

    func testPush1And2And3Pop() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        digits.pushDigit("2")
        digits.pushDigit("3")
        XCTAssertEqual(digits.popDigit(), "3")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 12)
        XCTAssertEqual(digits.unsignedDigits, "12")
        XCTAssertEqual(digits.signedDigits, "12")
    }

    func testPush1Negate() {
        var digits = FloatingDigits()
        digits.pushDigit("1")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, -1)
        XCTAssertEqual(digits.unsignedDigits, "1")
        XCTAssertEqual(digits.signedDigits, "-1")
        XCTAssertEqual(digits.description, "-1")
    }

    func testPushPoint() {
        var digits = FloatingDigits()
        digits.pushDigit(".")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "0.")
        XCTAssertEqual(digits.description, "0.")
    }

    func testPushPointPoint() {
        var digits = FloatingDigits()
        digits.pushDigit(".")
        digits.pushDigit(".") // rejected, point already present
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "0.")
        XCTAssertEqual(digits.description, "0.")
    }

    func testPushPoint3() {
        var digits = FloatingDigits()
        digits.pushDigit(".")
        digits.pushDigit("3")
        XCTAssertFalse(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0.3, accuracy: 0.0000000000000001)
        XCTAssertEqual(digits.unsignedDigits, "0.3")
        XCTAssertEqual(digits.signedDigits, "0.3")
        XCTAssertEqual(digits.description, "0.3")
    }

    func testPushPoint5Negate() {
        var digits = FloatingDigits()
        digits.pushDigit(".")
        digits.pushDigit("5")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, -0.5, accuracy: 0.0000000000000001)
        XCTAssertEqual(digits.unsignedDigits, "0.5")
        XCTAssertEqual(digits.signedDigits, "-0.5")
        XCTAssertEqual(digits.description, "-0.5")
    }

    func testPushPointNegate() {
        var digits = FloatingDigits()
        digits.pushDigit(".")
        digits.negate()
        XCTAssertTrue(digits.startsWithMinus)
        XCTAssertEqual(digits.doubleValue, 0)
        XCTAssertEqual(digits.unsignedDigits, "0.")
        XCTAssertEqual(digits.signedDigits, "-0.")
        XCTAssertEqual(digits.description, "-0.")
    }

    func testPushPop() {
        var digits = FloatingDigits()
        XCTAssertNil(digits.popDigit())
        XCTAssertNil(digits.unsignedDigits)
        XCTAssertNil(digits.signedDigits)
        XCTAssertEqual(digits.description, "")
    }
}
