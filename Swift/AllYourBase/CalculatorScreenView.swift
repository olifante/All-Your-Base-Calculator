//
//  CalculatorScreenView.swift
//  AllYourBase
//
//  One tab's worth of UI: the two stacked display labels (the original's
//  `previousDisplayLabel`/`currentDisplayLabel`) plus the keypad grid. A
//  single adaptive VStack replaces the original's separate portraitView /
//  landscapeView nib subviews and the orientation-change notification that
//  swapped between them - here the keypad's column count just recomputes
//  from the available width via GeometryReader, so rotating the device
//  reflows the same view instead of switching to a different one.
//

import SwiftUI

struct CalculatorDisplayView: View {
    let secondary: String
    let primary: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(secondary.isEmpty ? " " : CalculatorSymbols.prettify(secondary))
                .font(.system(size: 18, weight: .regular, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(primary.isEmpty ? "0" : CalculatorSymbols.prettify(primary))
                .font(.system(size: 36, weight: .medium, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
}

struct CalculatorScreenView: View {
    @ObservedObject var model: CalculatorModel
    let base: Int
    /// True only for the "Base 10*" tab (the original's `base:0` sentinel).
    let isClassic: Bool

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 12) {
                CalculatorDisplayView(secondary: model.secondaryDisplay, primary: model.mainDisplay)
                CalculatorKeypadView(layout: keypadLayout(forWidth: Double(proxy.size.width)), onKeyTap: handle)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
            // GeometryReader's child defaults to hugging its own content and
            // sitting top-leading, which is what made the keypad look tiny
            // and stranded in the corner of the screen with the rest left
            // blank - force it to actually use the full proposed size.
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
        }
        .onAppear { model.changeBase(to: base) }
    }

    private func keypadLayout(forWidth width: Double) -> CalculatorKeypadView.Layout {
        if isClassic {
            return .flat(keys: KeypadLayout.classicKeys(), columns: KeypadLayout.classicColumnCount)
        }
        return .grouped(
            editing: KeypadLayout.editingKeys(),
            digits: KeypadLayout.digitKeys(forBase: base),
            operations: KeypadLayout.operationKeys(),
            digitColumns: KeypadLayout.sequentialColumnCount(forWidth: width)
        )
    }

    private func handle(_ key: KeypadKey) {
        switch key.action {
        case .digit(let digit): model.digitPressed(digit)
        case .point: model.digitPressed(".")
        case .negate: model.negatePressed()
        case .delete: model.deletePressed()
        case .clear: model.cleanPressed()
        case .shiftLeft: model.shiftLeftPressed()
        case .shiftRight: model.shiftRightPressed()
        case .operation(let token): model.binaryOperationPressed(token)
        case .equals: model.resultPressed()
        }
    }
}
