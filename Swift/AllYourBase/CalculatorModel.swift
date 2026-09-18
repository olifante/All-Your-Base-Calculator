//
//  CalculatorModel.swift
//  AllYourBase
//
//  Swift port of the original AllYourBaseModel.h/.m. A single instance of
//  this model is shared across every base (exactly like the original,
//  where `AllYourBaseAppDelegate_i{Phone,Pad}` built one `AllYourBaseModel`
//  and handed the *same* instance to every per-base view controller - here
//  it's shared across every selection of the base picker instead). That
//  sharing is what makes the app's core party trick work: type a number at
//  "Base 10", switch the picker to "Base 16", and see the very same value
//  re-rendered in hex - changing the selection just changes `model.base`,
//  which re-renders the current/previous operands in the new base without
//  losing their value.
//
//  KVO (`observeValueForKeyPath:`) is replaced by `@Published` + ObservableObject,
//  which is the direct SwiftUI equivalent of "the view re-reads the display
//  strings whenever they change".
//

import Foundation

@MainActor
final class CalculatorModel: ObservableObject {

    @Published private(set) var mainDisplay: String = ""
    @Published private(set) var secondaryDisplay: String = ""
    @Published private(set) var error: Error?

    private(set) var currentDigits: Digits
    private var previousDigits: Digits?
    private var resultDigits: Digits?
    private var currentOperation: String?
    private var previousOperation: String?
    private var previousExpression: String?
    private var previousFirstOperand: Rational = .zero
    private var previousSecondOperand: Rational = .zero

    private(set) var base: Int

    init(base someBase: Int = 10) {
        base = someBase
        currentDigits = Digits(base: someBase)!
        updateDisplays()
    }

    /// Equivalent of `-[AllYourBaseModel setBase:]`. Re-expresses the
    /// current/previous operands (and the pending-operation summary line) in
    /// the new base without losing their numeric value; this is what a base
    /// picker selection change does. A no-op if `newBase` is out of range or
    /// unchanged, exactly like the original (which just logs and returns).
    func changeBase(to newBase: Int) {
        guard newBase >= 2, newBase <= 100 else { return }
        guard newBase != base else { return }

        base = newBase

        // `.rationalValue`, not `.integerValue`, so a genuine fraction (from
        // a division/inversion result) keeps its denominator across a base
        // change instead of silently collapsing to just its numerator.
        if currentDigits.unsignedDigits != nil {
            currentDigits = Digits(rational: currentDigits.rationalValue, base: newBase)
        } else {
            currentDigits = Digits(base: newBase)!
        }

        if let previous = previousDigits {
            if previous.unsignedDigits != nil {
                previousDigits = Digits(rational: previous.rationalValue, base: newBase)
            } else {
                previousDigits = Digits(base: newBase)!
            }
        }

        if let previousOperation, previousOperation != "=" {
            let firstOperand = previousFirstOperand.description(inBase: newBase)
            let secondOperand = previousSecondOperand.description(inBase: newBase)
            previousExpression = "\(firstOperand) \(previousOperation) \(secondOperand)"
        } else {
            previousFirstOperand = .zero
            previousSecondOperand = .zero
            previousExpression = nil
            self.previousOperation = nil
        }

        updateDisplays()
    }

    // MARK: display strings

    private func updateMainDisplay() {
        var firstOperand = ""
        var paddedOperation = ""
        var secondOperand: String

        if let currentOperation {
            firstOperand = previousDigits?.description ?? ""
            paddedOperation = " \(currentOperation) "
            secondOperand = currentDigits.description
        } else {
            secondOperand = currentDigits.description
        }

        mainDisplay = (previousOperation != nil ? "= " : "") + firstOperand + paddedOperation + secondOperand
    }

    private func updateSecondaryDisplay() {
        if let error {
            secondaryDisplay = error.localizedDescription
            return
        }
        secondaryDisplay = previousOperation != nil ? (previousExpression ?? "") : ""
    }

    private func updateDisplays() {
        updateSecondaryDisplay()
        updateMainDisplay()
    }

    // MARK: pending operation

    // `currentOperation`/`previousOperation` always hold the plain ASCII
    // token ("+", "-", "*", "/", "^"), never the Unicode glyph the keypad
    // displays - exactly like the original, which normalized the button
    // title to ASCII before ever storing it on the model (see
    // -[AllYourBaseViewController operationPressed:]).
    private func performPendingOperation() throws -> Digits? {
        switch currentOperation {
        case "+": return try previousDigits?.plus(currentDigits)
        case "-": return try previousDigits?.minus(currentDigits)
        case "*": return try previousDigits?.times(currentDigits)
        case "/": return try previousDigits?.divide(currentDigits)
        case "^": return try previousDigits?.power(currentDigits)
        default:
            throw DigitsError(message: "unknown operation '\(currentOperation ?? "")'")
        }
    }

    // MARK: actions (IBActions in the original)

    func resultPressed() {
        guard error == nil else { return }

        if currentDigits.unsignedDigits == nil {
            // No 2nd operand yet - nothing to do, whether or not an
            // operation is pending (matches both early-return branches).
        } else if currentOperation != nil {
            do {
                let result = try performPendingOperation()
                guard let result else {
                    throw DigitsError(message: "binary operation error after pressing result")
                }
                previousFirstOperand = previousDigits?.rationalValue ?? .zero
                previousOperation = currentOperation
                previousSecondOperand = currentDigits.rationalValue
                previousExpression = "\(previousDigits?.description ?? "") \(currentOperation ?? "") \(currentDigits.description)"
                previousDigits = nil
                currentDigits = result
                currentOperation = nil
            } catch {
                self.error = error
            }
        } else {
            previousOperation = "="
            previousExpression = currentDigits.description
            // `.rationalValue`, not `.integerValue` - pressing "=" again
            // right after a fraction result (no pending operation left to
            // re-run) must not silently drop its denominator.
            let result = Digits(rational: currentDigits.rationalValue, base: base)
            resultDigits = result
            currentDigits = result
            previousDigits = nil
            currentOperation = nil
        }

        updateDisplays()
    }

    func binaryOperationPressed(_ operation: String) {
        guard error == nil else { return }

        if currentDigits.unsignedDigits == nil, currentOperation == nil {
            // No 2nd operand and nothing pending - nothing to do.
        } else if currentDigits.unsignedDigits == nil, currentOperation != nil {
            if !currentDigits.startsWithMinus {
                currentOperation = operation
                // Pressing another operation with no 2nd operand digit typed
                // yet cancels/replaces the pending operation.
            }
            // Pressing another operation right after a lone "-" does nothing.
        } else if currentOperation != nil {
            do {
                let result = try performPendingOperation()
                guard let result else {
                    throw DigitsError(message: "binary operation error after chaining operation")
                }
                previousFirstOperand = previousDigits?.rationalValue ?? .zero
                previousOperation = currentOperation
                previousSecondOperand = currentDigits.rationalValue
                previousExpression = "\(previousDigits?.description ?? "") \(currentOperation ?? "") \(currentDigits.description)"
                previousDigits = result
                currentDigits = Digits(base: base)!
                currentOperation = operation
            } catch {
                self.error = error
            }
        } else {
            previousDigits = currentDigits
            currentOperation = operation
            currentDigits = Digits(base: base)!
        }

        updateDisplays()
    }

    func digitPressed(_ digit: String) {
        guard error == nil else { return }

        // `currentDigits.denominator != 1` alongside the existing
        // previousOperation check: `pushDigit` only ever edits the
        // numerator's digit string, so typing straight after `inversePressed`
        // left a genuine fraction showing would otherwise silently extend
        // just the numerator while a stale denominator lingered underneath
        // it - always start fresh instead, the same as after a shown "=".
        if previousOperation != nil || currentDigits.denominator != 1 {
            currentDigits = Digits(base: base)!
        }

        currentDigits.pushDigit(digit)
        previousOperation = nil
        updateDisplays()
    }

    func deletePressed() {
        // Same reasoning as `digitPressed` above: `popDigit` only edits the
        // numerator, so it can't sensibly "un-type" a fraction - block it
        // exactly like a shown "=" result already blocks delete.
        guard previousOperation == nil, currentDigits.denominator == 1 else { return }

        currentDigits.popDigit()
        error = nil
        updateDisplays()
    }

    func negatePressed() {
        guard error == nil else { return }

        if previousOperation != nil {
            previousOperation = nil
            previousExpression = nil
            previousFirstOperand = .zero
            previousSecondOperand = .zero
            resultDigits = nil
            currentDigits = Digits(base: base)!
        }

        currentDigits.negate()
        updateDisplays()
    }

    func cleanPressed() {
        previousDigits = nil
        resultDigits = nil
        currentOperation = nil
        previousOperation = nil
        previousExpression = nil
        previousFirstOperand = .zero
        previousSecondOperand = .zero
        error = nil
        currentDigits = Digits(base: base)!
        updateDisplays()
    }

    // `percentPressed`/`eePressed` were present in every original nib as
    // keypad buttons wired to methods that did nothing, and stay that way -
    // kept as no-ops here for the same reason the buttons are kept in the
    // UI: fidelity to the shipped layout. `shiftLeftPressed`/
    // `shiftRightPressed` used to be in this same no-op group (the shift
    // keys were on every shipped keypad, just permanently inert) but are
    // now implemented for real below - unlike the sqrt/cbrt/reciprocal
    // methods further down, this is a deliberate new feature, not a
    // fidelity fix to a preserved original bug.
    func percentPressed() {}
    func eePressed() {}

    /// Multiplies the currently shown value by `base` (appends a zero
    /// digit) - a new feature; the original always left this key wired to a
    /// no-op. Transforms `currentDigits` in place rather than treating this
    /// as a fresh "=" result the way `resultPressed`/`inversePressed` do,
    /// so it also works mid-entry of a pending operation's second operand
    /// (e.g. shifting `3` while `5 +` is still pending gives `5 + 30`,
    /// without disturbing the pending `+`).
    func shiftLeftPressed() {
        guard error == nil else { return }
        do {
            currentDigits = try currentDigits.shiftedLeft()
        } catch {
            self.error = error
        }
        updateDisplays()
    }

    /// Truncating-toward-zero divide of the currently shown value by `base`
    /// (drops the last digit) - see `shiftLeftPressed` above for why this
    /// edits `currentDigits` in place. Deliberately lossy, like a real
    /// digit/bit shift - see `Digits.shiftedRight`.
    func shiftRightPressed() {
        guard error == nil else { return }
        do {
            currentDigits = try currentDigits.shiftedRight()
        } catch {
            self.error = error
        }
        updateDisplays()
    }

    // MARK: derived actions from AllYourBaseViewController's IBActions
    //
    // IMPORTANT - preserved original bug: `squareRootPressed`/
    // `cubeRootPressed` build up an exponent by calling `digitPressed(".")`
    // then more digits. But `Digits.isDigit(".")` is only true when
    // `allowsPoint` is set (the "FloatingDigits" flavor), and the live
    // calculator's `currentDigits` is always a plain, integer-only `Digits`.
    // So `digitPressed(".")` is silently rejected here exactly as it was in
    // the original, and the exponent that actually gets built is just the
    // digits typed *after* the point: `5` for square root and `333333` for
    // cube root. The net, real, shipped behavior of those two buttons is
    // "raise to the 5th power" and "raise to the 333333rd power", not an
    // actual square/cube root. This is being carried over unchanged for
    // fidelity to the original app; flagged here (and in CHANGELOG.md) in
    // case the original author wants to finally fix it now that it is
    // easy to spot.
    //
    // Also note: none of these three methods are reachable from any keypad
    // that actually ships (the sequential per-base grids and the classic
    // Base 10* grid have no square-root/cube-root/reciprocal button). In the
    // original they were only wired up in the `...Scientific10`/
    // `...10AlternateScientific` nibs, which are themselves dead/unreferenced
    // by any app delegate - see INPROGRESS.md. Kept here for completeness
    // and parity, not currently exposed by CalculatorKeypadView.
    func squareRootPressed() {
        binaryOperationPressed("^")
        digitPressed(".")
        digitPressed("5")
        resultPressed()
    }

    func cubeRootPressed() {
        binaryOperationPressed("^")
        digitPressed(".")
        for _ in 0..<6 {
            digitPressed("3")
        }
        resultPressed()
    }

    /// Matches `-[AllYourBaseViewController reciprocalPressed]` exactly,
    /// including that it does *not* call `resultPressed` itself - it only
    /// sets up "x ^ -1" as the pending expression; the user has to press
    /// "=" separately to see 1/x. Left as-is, unreachable from any shipped
    /// keypad, same as `squareRootPressed`/`cubeRootPressed` above -
    /// `inversePressed` below is the new, working "1/x" key, kept
    /// deliberately separate rather than "fixing" this preserved-bug method.
    func reciprocalPressed() {
        binaryOperationPressed("^")
        negatePressed()
        digitPressed("1")
    }

    /// A working multiplicative-inverse ("1/x") action, wired to the new
    /// `.inverse` keypad key - unlike `reciprocalPressed` above, this calls
    /// `Digits.invert()` directly and shows the result immediately, using
    /// the exact `Rational`-based math added alongside `÷`: `1/x` for `x`
    /// = `3` is now the exact `1:3`, not the old truncating-Int64 `0`.
    /// Transforms `currentDigits` in place, the same way `shiftLeftPressed`/
    /// `shiftRightPressed` do, so it doesn't disturb a pending operation's
    /// in-progress second operand.
    func inversePressed() {
        guard error == nil else { return }
        do {
            guard let inverted = try currentDigits.invert() else {
                throw DigitsError(message: "invert error")
            }
            currentDigits = inverted
        } catch {
            self.error = error
        }
        updateDisplays()
    }
}
