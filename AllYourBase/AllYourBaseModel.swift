//
//  AllYourBaseModel.swift
//  AllYourBase
//
//  The calculator's state machine. Ported from the Objective-C
//  `AllYourBaseModel`, which used KVO on `mainDisplay`/`secondaryDisplay`;
//  this uses `@Published` / `ObservableObject` instead so SwiftUI views can
//  observe it directly.
//
//  A single model instance is shared across every base's tab (see
//  `ContentView`), so switching tabs re-renders the same in-progress
//  calculation in a different base, exactly like the original app.
//

import Foundation

final class AllYourBaseModel: ObservableObject {
    @Published private(set) var base: Int

    @Published var currentDigits: Digits
    @Published var previousDigits: Digits?
    @Published var resultDigits: Digits?
    @Published var currentOperation: String?
    @Published var previousOperation: String?
    @Published var previousExpression: String?
    @Published private(set) var mainDisplay: String = ""
    @Published private(set) var secondaryDisplay: String = ""
    @Published var error: DigitsError?

    private var previousFirstOperand: Int64 = 0
    private var previousSecondOperand: Int64 = 0

    init(base: Int = 10) {
        self.base = base
        self.currentDigits = Digits(base: base)!
        updateDisplays()
    }

    // MARK: Base switching

    func setBase(_ someBase: Int) {
        guard someBase >= Digits.minBase, someBase <= Digits.maxBase else {
            print("only bases from \(Digits.minBase) to \(Digits.maxBase) are supported")
            return
        }
        guard someBase != base else {
            return
        }

        base = someBase

        if currentDigits.unsignedDigits != nil {
            currentDigits = Digits(longLong: currentDigits.integerValue, base: someBase)!
        } else {
            currentDigits = Digits(base: someBase)!
        }

        if let previous = previousDigits {
            if previous.unsignedDigits != nil {
                previousDigits = Digits(longLong: previous.integerValue, base: someBase)!
            } else {
                previousDigits = Digits(base: someBase)!
            }
        }

        if let operation = previousOperation, operation != "=" {
            let firstOperand = Digits.convertInteger(previousFirstOperand, toBase: someBase)
            let secondOperand = Digits.convertInteger(previousSecondOperand, toBase: someBase)
            previousExpression = "\(firstOperand) \(operation) \(secondOperand)"
        } else {
            previousFirstOperand = 0
            previousSecondOperand = 0
            previousExpression = nil
            previousOperation = nil
        }

        updateDisplays()
    }

    // MARK: Display

    private func updateMainDisplay() {
        var firstOperand = ""
        var paddedOperation = ""
        let secondOperand = currentDigits.description

        if let operation = currentOperation {
            firstOperand = previousDigits?.description ?? ""
            paddedOperation = " \(operation) "
        }

        let prefix = previousOperation != nil ? "= " : ""
        mainDisplay = "\(prefix)\(firstOperand)\(paddedOperation)\(secondOperand)"
    }

    private func updateSecondaryDisplay() {
        if let error {
            secondaryDisplay = error.errorDescription ?? ""
            return
        }
        secondaryDisplay = previousOperation != nil ? (previousExpression ?? "") : ""
    }

    private func updateDisplays() {
        updateSecondaryDisplay()
        updateMainDisplay()
    }

    // MARK: Operations

    private func performPendingOperation() throws -> Digits {
        guard let previous = previousDigits, let operation = currentOperation else {
            throw DigitsError.overflow("unknown operation")
        }
        switch operation {
        case "+": return try previous.plus(currentDigits)
        case "-": return try previous.minus(currentDigits)
        case "*": return try previous.times(currentDigits)
        case "/": return try previous.divide(currentDigits)
        case "^": return try previous.power(currentDigits)
        default:
            print("unknown operation '\(operation)'")
            throw DigitsError.overflow("unknown operation")
        }
    }

    func resultPressed() {
        guard error == nil else {
            print("No action - result does nothing after error")
            return
        }

        let hasSecondOperand = currentDigits.unsignedDigits != nil

        if !hasSecondOperand && currentOperation != nil {
            print("No action - pending operation cannot be performed without a 2nd operand")
        } else if !hasSecondOperand && currentOperation == nil {
            print("No action - result cannot be performed on empty operand")
        } else if hasSecondOperand && currentOperation != nil {
            do {
                let result = try performPendingOperation()
                resultDigits = result
                previousFirstOperand = previousDigits?.integerValue ?? 0
                previousOperation = currentOperation
                previousSecondOperand = currentDigits.integerValue
                previousExpression = "\(previousDigits?.description ?? "") \(currentOperation ?? "") \(currentDigits.description)"
                previousDigits = nil
                currentDigits = result
                currentOperation = nil
            } catch let digitsError as DigitsError {
                print("binary operation error after pressing result")
                error = digitsError
            } catch {
                self.error = .overflow("unknown")
            }
        } else {
            previousOperation = "="
            previousExpression = currentDigits.description
            let result = Digits(longLong: currentDigits.integerValue, base: base)!
            resultDigits = result
            currentDigits = result
            previousDigits = nil
            currentOperation = nil
        }

        updateDisplays()
    }

    func binaryOperationPressed(_ operation: String) {
        guard error == nil else {
            print("No action - operations do nothing after error")
            return
        }

        let hasSecondOperand = currentDigits.unsignedDigits != nil

        if !hasSecondOperand && currentOperation == nil {
            print("No action - operations do nothing without a 2nd operand")
        } else if !hasSecondOperand && currentOperation != nil {
            // Pressing another operation cancels the pending one, unless a
            // lone minus sign has already been entered for the 2nd operand.
            if !currentDigits.startsWithMinus {
                currentOperation = operation
            }
        } else if hasSecondOperand && currentOperation != nil {
            do {
                let result = try performPendingOperation()
                resultDigits = result
                previousFirstOperand = previousDigits?.integerValue ?? 0
                previousOperation = currentOperation
                previousSecondOperand = currentDigits.integerValue
                previousExpression = "\(previousDigits?.description ?? "") \(currentOperation ?? "") \(currentDigits.description)"
                previousDigits = result
                currentDigits = Digits(base: base)!
                currentOperation = operation
            } catch let digitsError as DigitsError {
                print("binary operation error after chaining operation")
                error = digitsError
            } catch {
                self.error = .overflow("unknown")
            }
        } else {
            previousDigits = currentDigits
            currentOperation = operation
            currentDigits = Digits(base: base)!
        }

        updateDisplays()
    }

    func digitPressed(_ digit: String) {
        guard error == nil else {
            print("No action - digits do nothing after error")
            return
        }

        if previousOperation != nil {
            currentDigits = Digits(base: base)!
        }

        currentDigits.pushDigit(digit)
        previousOperation = nil
        updateDisplays()
    }

    func deletePressed() {
        guard previousOperation == nil else {
            print("No action - delete does not alter calculation results")
            return
        }

        currentDigits.popDigit()

        if error != nil {
            error = nil
            print("cleaned error after pressing delete")
        }

        updateDisplays()
    }

    func negatePressed() {
        guard error == nil else {
            print("No action - negate does nothing after error")
            return
        }

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
}
