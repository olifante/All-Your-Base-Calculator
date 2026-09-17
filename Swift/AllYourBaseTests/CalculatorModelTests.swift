//
//  CalculatorModelTests.swift
//  AllYourBaseTests
//
//  New coverage (the original project had no AllYourBaseModel test target,
//  only LogicTests for Digits/FloatingDigits) for the orchestration layer:
//  digit entry, chained operations, error handling, and the base-switching
//  behavior a single shared model has to get right for the app's core
//  feature (typing in one base's tab and reading the same value on another).
//

import XCTest
@testable import AllYourBase

@MainActor
final class CalculatorModelTests: XCTestCase {

    func testDigitEntryUpdatesMainDisplay() {
        let model = CalculatorModel()
        model.digitPressed("1")
        model.digitPressed("2")
        model.digitPressed("3")
        XCTAssertEqual(model.mainDisplay, "123")
    }

    func testSimpleAddition() {
        let model = CalculatorModel()
        model.digitPressed("2")
        model.binaryOperationPressed("+")
        model.digitPressed("3")
        model.resultPressed()
        // Once a result has been computed, `previousOperation` is set and
        // `updateMainDisplay` prefixes the line with "= ", matching the
        // original's `self.previousOperation ? @"= " : @""`.
        XCTAssertEqual(model.mainDisplay, "= 5")
    }

    func testChainedOperationsShowRunningResult() {
        let model = CalculatorModel()
        model.digitPressed("2")
        model.binaryOperationPressed("+")
        model.digitPressed("3")
        model.binaryOperationPressed("*") // chains: (2+3) becomes the new previous operand
        model.digitPressed("4")
        model.resultPressed()
        XCTAssertEqual(model.mainDisplay, "= 20")
    }

    func testDivideByZeroSurfacesErrorOnSecondaryDisplay() {
        let model = CalculatorModel()
        model.digitPressed("1")
        model.binaryOperationPressed("/")
        model.digitPressed("0")
        model.resultPressed()
        XCTAssertFalse(model.secondaryDisplay.isEmpty)
        XCTAssertEqual(model.secondaryDisplay, Digits.divideErrorMessage)
    }

    func testDeleteClearsErrorAndAllowsRetry() {
        let model = CalculatorModel()
        model.digitPressed("1")
        model.binaryOperationPressed("/")
        model.digitPressed("0")
        model.resultPressed()
        XCTAssertEqual(model.secondaryDisplay, Digits.divideErrorMessage)

        model.deletePressed()
        XCTAssertTrue(model.secondaryDisplay.isEmpty)
        model.digitPressed("5")
        // Deleting only pops a digit and clears the error - it does not
        // cancel the still-pending "1 / " operation, so the new digit lands
        // as its second operand rather than starting a fresh expression.
        XCTAssertEqual(model.mainDisplay, "1 / 5")
    }

    func testCleanResetsEverything() {
        let model = CalculatorModel()
        model.digitPressed("9")
        model.binaryOperationPressed("+")
        model.digitPressed("9")
        model.resultPressed()
        model.cleanPressed()
        XCTAssertEqual(model.mainDisplay, "")
        XCTAssertEqual(model.secondaryDisplay, "")
    }

    /// This is the app's whole point: type a value on one base's tab, switch
    /// to another, and see it re-rendered - not reset - in the new base.
    /// `changeBase(to:)` is exactly what CalculatorScreenView calls from
    /// `.onAppear` when a tab is selected.
    func testChangingBasePreservesValueAcrossTabs() {
        let model = CalculatorModel(base: 10)
        model.digitPressed("2")
        model.digitPressed("5")
        model.digitPressed("5")
        XCTAssertEqual(model.mainDisplay, "255")

        model.changeBase(to: 16)
        XCTAssertEqual(model.mainDisplay, "FF")

        model.changeBase(to: 2)
        XCTAssertEqual(model.mainDisplay, "11111111")

        model.changeBase(to: 10)
        XCTAssertEqual(model.mainDisplay, "255")
    }

    func testChangeBaseIgnoresOutOfRangeOrUnchangedValues() {
        let model = CalculatorModel(base: 10)
        model.digitPressed("7")
        model.changeBase(to: 10) // unchanged - must be a no-op
        XCTAssertEqual(model.mainDisplay, "7")
        model.changeBase(to: 1) // out of range - must be a no-op
        XCTAssertEqual(model.mainDisplay, "7")
    }

    /// Documents the original app's real, shipped behavior for the
    /// square-root button (see CalculatorModel.squareRootPressed): because
    /// `digitPressed(".")` is a no-op on a plain (non-`allowsPoint`) Digits,
    /// the exponent that actually gets built is "5", not "0.5" - so this
    /// computes x^5, not sqrt(x). This test locks in that documented quirk
    /// rather than "fixing" it silently.
    func testSquareRootButtonActuallyRaisesToThe5thPower() {
        let model = CalculatorModel()
        model.digitPressed("2")
        model.squareRootPressed()
        XCTAssertEqual(model.mainDisplay, "= 32") // 2^5, not sqrt(2)
    }

    /// A second original-app quirk, discovered while tracing this test:
    /// `Digits.power` explicitly rejects a negative exponent on a plain
    /// (non-`allowsPoint`) `Digits` - `m ^ -n` throws "negativePowerErrorMessage"
    /// rather than computing a (truncated-to-0) result. So pressing "=" after
    /// the reciprocal button's "x ^ -1" setup doesn't yield 0; it raises that
    /// error instead. The 1/x button is, like sqrt/cbrt, not actually
    /// reachable from any shipped keypad (see CalculatorModel.reciprocalPressed).
    func testReciprocalButtonSetsUpExpressionWithoutEvaluating() {
        let model = CalculatorModel()
        model.digitPressed("2")
        model.reciprocalPressed()
        // Matches -[AllYourBaseViewController reciprocalPressed] exactly:
        // it sets up "2 ^ -1" but does not press "=" itself.
        XCTAssertEqual(model.mainDisplay, "2 ^ -1")
        model.resultPressed()
        XCTAssertEqual(model.mainDisplay, "2 ^ -1") // unchanged: the ^ threw
        XCTAssertEqual(model.secondaryDisplay, Digits.negativePowerErrorMessage)
    }
}
