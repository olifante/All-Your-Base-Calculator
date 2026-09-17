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
                .frame(minWidth: 1, maxWidth: .infinity, alignment: .trailing)
            Text(primary.isEmpty ? "0" : CalculatorSymbols.prettify(primary))
                .font(.system(size: 36, weight: .medium, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .frame(minWidth: 1, maxWidth: .infinity, alignment: .trailing)
        }
        // `minWidth: 1` on each Text above guards against `minimumScaleFactor`
        // computing its scale ratio against a momentarily-zero proposed
        // width (e.g. during a TabView tab-switch fade/scale transition),
        // which is a known trigger for spurious CoreGraphics NaN warnings.
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
            // `proxy.size` is read only to pick a column count below - it is
            // never fed into a `.frame(width:height:)` here. Doing that
            // previously caused a real, reproducible crash-adjacent bug: if
            // GeometryReader ever reports a transient zero (or otherwise
            // degenerate) height - which does happen for a frame or two
            // during a tab switch/rotation animation - that zero got baked
            // into a hard frame, and the digit grid's flexible-height layout
            // underneath then divided by it, producing NaN geometry that
            // CoreGraphics logged (and re-triggered) indefinitely. `maxWidth
            // /maxHeight: .infinity` achieves the same "fill the tab" goal
            // without ever plugging a literal, possibly-zero number into a
            // frame.
            VStack(spacing: 12) {
                CalculatorDisplayView(secondary: model.secondaryDisplay, primary: model.mainDisplay)
                CalculatorKeypadView(layout: keypadLayout(forWidth: Double(proxy.size.width)), onKeyTap: handle)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
