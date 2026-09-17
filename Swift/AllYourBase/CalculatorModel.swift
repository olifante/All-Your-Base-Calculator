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
    private var previousFirstOperand: Int64 = 0
    private var previousSecondOperand: Int64 = 0

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

        if currentDigits.unsignedDigits != nil {
            currentDigits = Digits(longLong: currentDigits.integerValue, base: newBase)
        } else {
            currentDigits = Digits(base: newBase)!
        }

        if let previous = previousDigits {
            if previous.unsignedDigits != nil {
                previousDigits = Digits(longLong: previous.integerValue, base: newBase)
            } else {
                previousDigits = Digits(base: newBase)!
            }
        }

        if let previousOperation, previousOperation != "=" {
            let firstOperand = Digits.convertInteger(previousFirstOperand, toBase: newBase)
            let secondOperand = Digits.convertInteger(previousSecondOperand, toBase: newBase)
            previousExpression = "\(firstOperand) \(previousOperation) \(secondOperand)"
        } else {
            previousFirstOperand = 0
            previousSecondOperand = 0
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
                previousFirstOperand = previousDigits?.integerValue ?? 0
                previousOperation = currentOperation
                previousSecondOperand = currentDigits.integerValue
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
            let result = Digits(longLong: currentDigits.integerValue, base: base)
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
                previousFirstOperand = previousDigits?.integerValue ?? 0
                previousOperation = currentOperation
                previousSecondOperand = currentDigits.integerValue
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

        if previousOperation != nil {
            currentDigits = Digits(base: base)!
        }

        currentDigits.pushDigit(digit)
        previousOperation = nil
        updateDisplays()
    }

    func deletePressed() {
        guard previousOperation == nil else { return }

        currentDigits.popDigit()
        error = nil
        updateDisplays()
    }

    func negatePressed() {
        guard error == nil else { return }

        if previousOperation != nil {
            previousOperation = nil
            previousExpression = nil
            previousFirstOperand = 0
            previousSecondOperand = 0
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
        previousFirstOperand = 0
        previousSecondOperand = 0
        error = nil
        currentDigits = Digits(base: base)!
        updateDisplays()
    }

    // Present in every original nib as keypad buttons, always wired to
    // methods that did nothing - kept as no-ops here for the same reason
    // the buttons are kept in the UI: fidelity to the shipped layout.
    func shiftLeftPressed() {}
    func shiftRightPressed() {}
    func percentPressed() {}
    func eePressed() {}

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
    /// "=" separately to see 1/x.
    func reciprocalPressed() {
        binaryOperationPressed("^")
        negatePressed()
        digitPressed("1")
    }
}
