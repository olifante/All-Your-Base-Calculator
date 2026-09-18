//
//  CalculatorModelTests.swift
//  AllYourBaseTests
//
//  New coverage (the original project had no AllYourBaseModel test target,
//  only LogicTests for Digits/FloatingDigits) for the orchestration layer:
//  digit entry, chained operations, error handling, and the base-switching
//  behavior a single shared model has to get right for the app's core
//  feature (typing a value at one base and reading the same value back at
//  another).
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

    /// This is the app's whole point: type a value at one base, switch to
    /// another via the base picker, and see it re-rendered - not reset - in
    /// the new base. `changeBase(to:)` is exactly what CalculatorScreenView
    /// calls (via `.onChange(of: base)`) whenever the picker selection
    /// changes.
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

    // MARK: exact (Rational) division

    /// The headline fix: division used to truncate like Int64's `/` - `7 / 2`
    /// showed `3`. It's now the exact fraction, rendered `p:q` (see
    /// Digits.rationalSeparator for why `:` and not `/` or `÷`).
    func testDivisionProducesExactFractionInsteadOfTruncating() {
        let model = CalculatorModel()
        model.digitPressed("7")
        model.binaryOperationPressed("/")
        model.digitPressed("2")
        model.resultPressed()
        XCTAssertEqual(model.mainDisplay, "= 7:2")
    }

    func testDivisionResultReducesToLowestTerms() {
        let model = CalculatorModel()
        model.digitPressed("6")
        model.binaryOperationPressed("/")
        model.digitPressed("4")
        model.resultPressed()
        XCTAssertEqual(model.mainDisplay, "= 3:2") // not "6:4"
    }

    func testDivisionResultStillCollapsesToAPlainIntegerWhenExact() {
        let model = CalculatorModel()
        model.digitPressed("2")
        model.digitPressed("4")
        model.binaryOperationPressed("/")
        model.digitPressed("4")
        model.resultPressed()
        XCTAssertEqual(model.mainDisplay, "= 6") // no ":1" suffix
    }

    /// A fraction result stays exact across a base change, same as any
    /// other value - `7:2` in base 10 is `111:10` in base 2 (7 and 2 each
    /// converted independently), not silently collapsed to just `111`.
    func testFractionResultSurvivesBaseChange() {
        let model = CalculatorModel(base: 10)
        model.digitPressed("7")
        model.binaryOperationPressed("/")
        model.digitPressed("2")
        model.resultPressed()
        XCTAssertEqual(model.mainDisplay, "= 7:2")

        model.changeBase(to: 2)
        XCTAssertEqual(model.mainDisplay, "= 111:10")
    }

    // MARK: shift left / shift right

    /// New feature: the shift keys were always wired to a no-op in the
    /// original. Shift left multiplies by the base (appends a zero digit).
    func testShiftLeftMultipliesByBase() {
        let model = CalculatorModel()
        model.digitPressed("5")
        model.shiftLeftPressed()
        XCTAssertEqual(model.mainDisplay, "50")
    }

    /// Shift right is a truncating divide by the base (drops the last
    /// digit) - deliberately lossy, unlike the exact `÷` operator.
    func testShiftRightDropsLastDigit() {
        let model = CalculatorModel()
        model.digitPressed("5")
        model.digitPressed("7")
        model.shiftRightPressed()
        XCTAssertEqual(model.mainDisplay, "5")
    }

    /// Shift edits the in-progress second operand in place rather than
    /// treating itself as a fresh "=" result, so a pending operation
    /// survives it.
    func testShiftLeftDuringPendingOperationKeepsTheOperationPending() {
        let model = CalculatorModel()
        model.digitPressed("5")
        model.binaryOperationPressed("+")
        model.digitPressed("3")
        model.shiftLeftPressed()
        XCTAssertEqual(model.mainDisplay, "5 + 30")
    }

    // MARK: inverse ("1/x")

    /// New feature: `1/x` is now exact, unlike the old `reciprocalPressed`
    /// path (kept unreachable/broken for fidelity - see
    /// `testReciprocalButtonSetsUpExpressionWithoutEvaluating` above).
    func testInverseProducesExactFraction() {
        let model = CalculatorModel()
        model.digitPressed("3")
        model.inversePressed()
        XCTAssertEqual(model.mainDisplay, "1:3")
    }

    func testInverseOfZeroSurfacesError() {
        let model = CalculatorModel()
        model.digitPressed("0")
        model.inversePressed()
        XCTAssertEqual(model.secondaryDisplay, Digits.invertErrorMessage)
    }

    // MARK: fraction results can't be digit-edited

    /// `popDigit`/`pushDigit` only ever touch a `Digits`'s numerator, so
    /// editing a shown fraction digit-by-digit would silently corrupt it
    /// (extending/trimming the numerator while a stale denominator lingers)
    /// - both actions instead treat a shown fraction like a shown "="
    /// result: delete is blocked, and a new digit starts fresh.
    func testDeleteIsBlockedRightAfterAFractionResult() {
        let model = CalculatorModel()
        model.digitPressed("3")
        model.inversePressed()
        XCTAssertEqual(model.mainDisplay, "1:3")
        model.deletePressed()
        XCTAssertEqual(model.mainDisplay, "1:3") // unchanged
    }

    func testDigitEntryStartsFreshRightAfterAFractionResult() {
        let model = CalculatorModel()
        model.digitPressed("3")
        model.inversePressed()
        XCTAssertEqual(model.mainDisplay, "1:3")
        model.digitPressed("5")
        XCTAssertEqual(model.mainDisplay, "5") // fresh, not "15:3"
    }
}
