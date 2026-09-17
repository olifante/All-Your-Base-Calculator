//
//  CalculatorKeypadView.swift
//  AllYourBase
//
//  The one SwiftUI view that stands in for every original per-base .xib's
//  button grid. Renders `KeypadLayout`'s key groups as clearly separated
//  rows - editing controls, then the digit grid, then the math operators -
//  styled to loosely echo the original buttons (a monospaced title font,
//  light/dark button backgrounds, digits vs. operators colored differently).
//

import SwiftUI

struct CalculatorKeypadView: View {
    enum Layout {
        /// The sequential per-base layout: editing controls on their own
        /// row, the digit grid (wrapping into as many rows as `digitColumns`
        /// requires), then the operators on their own row.
        case grouped(editing: [KeypadKey], digits: [KeypadKey], operations: [KeypadKey], digitColumns: Int)
        /// The classic phone-calculator-style grid used by "Base 10*",
        /// where digits and operators are deliberately interleaved.
        case flat(keys: [KeypadKey], columns: Int)
    }

    let layout: Layout
    let onKeyTap: (KeypadKey) -> Void

    var body: some View {
        switch layout {
        case let .grouped(editing, digits, operations, digitColumns):
            VStack(spacing: 14) {
                row(editing)
                grid(digits, columns: digitColumns)
                    .frame(maxHeight: .infinity)
                row(operations)
            }
        case let .flat(keys, columns):
            grid(keys, columns: columns)
        }
    }

    private func row(_ keys: [KeypadKey]) -> some View {
        HStack(spacing: 8) {
            ForEach(keys) { key in keyButton(key) }
        }
    }

    private func grid(_ keys: [KeypadKey], columns: Int) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: max(columns, 1)),
            spacing: 8
        ) {
            ForEach(keys) { key in keyButton(key) }
        }
    }

    private func keyButton(_ key: KeypadKey) -> some View {
        Button {
            onKeyTap(key)
        } label: {
            Text(key.title)
                .font(.system(size: 28, weight: .medium, design: .monospaced))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .frame(maxWidth: .infinity, minHeight: 64)
                .frame(maxHeight: .infinity)
        }
        .buttonStyle(CalculatorKeyStyle(kind: key.action.kind, isInert: key.isInert))
    }
}

private extension KeypadKey.Action {
    enum Kind {
        case digit
        case control
        case operation
    }

    var kind: Kind {
        switch self {
        case .digit, .point: return .digit
        case .negate, .delete, .clear, .shiftLeft, .shiftRight: return .control
        case .operation, .equals: return .operation
        }
    }
}

private struct CalculatorKeyStyle: ButtonStyle {
    let kind: KeypadKey.Action.Kind
    let isInert: Bool

    private var background: Color {
        switch kind {
        case .digit: return Color(white: 0.85)
        case .control: return Color(white: 0.65)
        case .operation: return Color.orange
        }
    }

    private var foreground: Color {
        kind == .digit ? .black : .white
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foreground)
            .opacity(isInert ? 0.4 : 1)
            .background(background.opacity(configuration.isPressed ? 0.6 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
