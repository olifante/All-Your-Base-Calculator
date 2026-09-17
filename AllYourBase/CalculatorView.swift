//
//  CalculatorView.swift
//  AllYourBase
//
//  The calculator screen for a single base. Ported from the programmatic
//  UIKit layout in `AllYourBaseViewController`.
//

import SwiftUI

struct CalculatorView: View {
    @ObservedObject var model: AllYourBaseModel

    private static let plusSymbol = "+"
    private static let minusSymbol = "\u{2212}"     // − MINUS SIGN
    private static let timesSymbol = "\u{00D7}"     // × MULTIPLICATION SIGN
    private static let divideSymbol = "\u{00F7}"    // ÷ DIVISION SIGN
    private static let powerSymbol = "\u{2191}"     // ↑ UPWARDS ARROW
    private static let pointSymbol = "\u{2219}"     // ∙ BULLET OPERATOR
    private static let negateSymbol = "\u{2213}"    // ∓ MINUS-OR-PLUS SIGN

    private static let digitPadColumns = 5

    private var digitRows: [[String]] {
        let digits = Digits.allowedDigits(forBase: model.base).map { String($0) } + [Self.pointSymbol]
        return stride(from: 0, to: digits.count, by: Self.digitPadColumns).map { start in
            Array(digits[start..<min(start + Self.digitPadColumns, digits.count)])
        }
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            displayStack
            VStack(spacing: 8) {
                utilityRow
                digitPad
                operatorRow
            }
        }
        .padding()
    }

    private var displayStack: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(model.secondaryDisplay)
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(model.mainDisplay)
                .font(.system(size: 40, weight: .regular, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var utilityRow: some View {
        HStack(spacing: 8) {
            calculatorButton(Self.negateSymbol) { model.negatePressed() }
            calculatorButton("⌫") { model.deletePressed() }
            calculatorButton("C") { model.cleanPressed() }
        }
    }

    private var digitPad: some View {
        VStack(spacing: 8) {
            ForEach(Array(digitRows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { title in
                        calculatorButton(title) {
                            model.digitPressed(title == Self.pointSymbol ? "." : title)
                        }
                    }
                    ForEach(row.count..<Self.digitPadColumns, id: \.self) { _ in
                        Color.clear
                    }
                }
            }
        }
    }

    private var operatorRow: some View {
        HStack(spacing: 8) {
            calculatorButton(Self.plusSymbol) { model.binaryOperationPressed("+") }
            calculatorButton(Self.minusSymbol) { model.binaryOperationPressed("-") }
            calculatorButton(Self.timesSymbol) { model.binaryOperationPressed("*") }
            calculatorButton(Self.divideSymbol) { model.binaryOperationPressed("/") }
            calculatorButton(Self.powerSymbol) { model.binaryOperationPressed("^") }
            calculatorButton("=") { model.resultPressed() }
        }
    }

    private func calculatorButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 22))
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    CalculatorView(model: AllYourBaseModel(base: 16))
}
