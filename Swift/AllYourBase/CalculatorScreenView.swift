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
            Text(secondary.isEmpty ? " " : secondary)
                .font(.custom("Courier", size: 18))
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(primary.isEmpty ? "0" : primary)
                .font(.custom("Courier", size: 32))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }
}

struct CalculatorScreenView: View {
    @ObservedObject var model: CalculatorModel
    let base: Int
    /// True only for the "Base 10*" tab (the original's `base:0` sentinel).
    let isClassic: Bool

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 8) {
                CalculatorDisplayView(secondary: model.secondaryDisplay, primary: model.mainDisplay)
                CalculatorKeypadView(
                    keys: isClassic ? KeypadLayout.classicKeys() : KeypadLayout.sequentialKeys(forBase: base),
                    columns: isClassic
                        ? KeypadLayout.classicColumnCount
                        : KeypadLayout.sequentialColumnCount(forWidth: proxy.size.width),
                    onKeyTap: handle
                )
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            }
        }
        .onAppear { model.changeBase(to: base) }
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
