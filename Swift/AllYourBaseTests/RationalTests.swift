//
//  RationalTests.swift
//  AllYourBaseTests
//
//  Direct coverage of Rational.swift's own contract (reduction, sign
//  normalization, overflow, inverse, power, base-aware description),
//  independent of how Digits/CalculatorModel happen to use it.
//

import XCTest
@testable import AllYourBase

final class RationalTests: XCTestCase {

    // MARK: construction / normalization

    func testReducesToLowestTerms() {
        let value = Rational(numerator: 6, denominator: 4)
        XCTAssertEqual(value?.numerator, 3)
        XCTAssertEqual(value?.denominator, 2)
    }

    func testNegativeDenominatorMovesSignToNumerator() {
        let value = Rational(numerator: 3, denominator: -4)
        XCTAssertEqual(value?.numerator, -3)
        XCTAssertEqual(value?.denominator, 4)
    }

    func testNegativeNumeratorAndDenominatorCancelToPositive() {
        let value = Rational(numerator: -3, denominator: -4)
        XCTAssertEqual(value?.numerator, 3)
        XCTAssertEqual(value?.denominator, 4)
    }

    func testZeroNumeratorNormalizesDenominatorToOne() {
        let value = Rational(numerator: 0, denominator: 5)
        XCTAssertEqual(value?.numerator, 0)
        XCTAssertEqual(value?.denominator, 1)
    }

    /// The one case that can't be represented: negating `Int64.min` (needed
    /// to move a negative denominator's sign onto the numerator) overflows.
    func testInt64MinNumeratorWithNegativeDenominatorFailsToConstruct() {
        XCTAssertNil(Rational(numerator: Int64.min, denominator: -1))
    }

    func testInt64MinDenominatorFailsToConstruct() {
        XCTAssertNil(Rational(numerator: 1, denominator: Int64.min))
    }

    // MARK: arithmetic

    func testAdditionCrossMultiplies() {
        let oneHalf = Rational(numerator: 1, denominator: 2)!
        let oneThird = Rational(numerator: 1, denominator: 3)!
        let sum = oneHalf + oneThird
        XCTAssertEqual(sum, Rational(numerator: 5, denominator: 6))
    }

    func testSubtraction() {
        let oneHalf = Rational(numerator: 1, denominator: 2)!
        let oneThird = Rational(numerator: 1, denominator: 3)!
        XCTAssertEqual(oneHalf - oneThird, Rational(numerator: 1, denominator: 6))
    }

    func testMultiplication() {
        let twoThirds = Rational(numerator: 2, denominator: 3)!
        let threeFourths = Rational(numerator: 3, denominator: 4)!
        XCTAssertEqual(twoThirds * threeFourths, Rational(numerator: 1, denominator: 2))
    }

    func testDivision() {
        let oneHalf = Rational(numerator: 1, denominator: 2)!
        let oneThird = Rational(numerator: 1, denominator: 3)!
        XCTAssertEqual(oneHalf / oneThird, Rational(numerator: 3, denominator: 2))
    }

    func testDivisionByZeroIsNil() {
        let oneHalf = Rational(numerator: 1, denominator: 2)!
        XCTAssertNil(oneHalf / .zero)
    }

    func testAdditionOverflowIsNil() {
        let huge = Rational(numerator: Int64.max, denominator: 1)!
        XCTAssertNil(huge + Rational(numerator: 1, denominator: 1)!)
    }

    func testMultiplicationOverflowIsNil() {
        let huge = Rational(numerator: Int64.max, denominator: 1)!
        XCTAssertNil(huge * huge)
    }

    // MARK: inverse

    func testInverseFlipsNumeratorAndDenominator() {
        let twoThirds = Rational(numerator: 2, denominator: 3)!
        XCTAssertEqual(twoThirds.inverse(), Rational(numerator: 3, denominator: 2))
    }

    func testInverseOfNegativeStaysCorrectlySigned() {
        let negativeTwoThirds = Rational(numerator: -2, denominator: 3)!
        XCTAssertEqual(negativeTwoThirds.inverse(), Rational(numerator: -3, denominator: 2))
    }

    func testInverseOfZeroIsNil() {
        XCTAssertNil(Rational.zero.inverse())
    }

    // MARK: power

    func testPowerRaisesNumeratorAndDenominatorSeparately() {
        let twoThirds = Rational(numerator: 2, denominator: 3)!
        XCTAssertEqual(twoThirds.power(3), Rational(numerator: 8, denominator: 27))
    }

    func testPowerOfZeroExponentIsOne() {
        let twoThirds = Rational(numerator: 2, denominator: 3)!
        XCTAssertEqual(twoThirds.power(0), Rational(numerator: 1, denominator: 1))
    }

    func testPowerOverflowIsNil() {
        let huge = Rational(numerator: Int64.max, denominator: 1)!
        XCTAssertNil(huge.power(2))
    }

    // MARK: description(inBase:)

    func testDescriptionOfWholeNumberOmitsSeparator() {
        let six = Rational(numerator: 6, denominator: 1)!
        XCTAssertEqual(six.description(inBase: 10), "6")
    }

    func testDescriptionOfFractionUsesColonSeparator() {
        let sevenHalves = Rational(numerator: 7, denominator: 2)!
        XCTAssertEqual(sevenHalves.description(inBase: 10), "7:2")
    }

    func testDescriptionRendersEachPartInTheGivenBase() {
        let sevenHalves = Rational(numerator: 7, denominator: 2)!
        XCTAssertEqual(sevenHalves.description(inBase: 2), "111:10")
    }

    func testDescriptionOfNegativeFraction() {
        let value = Rational(numerator: -7, denominator: 2)!
        XCTAssertEqual(value.description(inBase: 10), "-7:2")
    }
}
