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
            // Deliberately no `.frame(maxHeight: .infinity)` on the digit
            // grid: that combined badly with a degenerate (zero/transient)
            // proposed height from the enclosing GeometryReader, producing
            // NaN layout geometry (see CalculatorScreenView). A trailing
            // `Spacer` absorbs any leftover vertical space instead, which
            // never affects how the grid computes its own row heights.
            VStack(spacing: 14) {
                row(editing)
                grid(digits, columns: digitColumns)
                row(operations)
                Spacer(minLength: 0)
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

    // NOTE (open issue, see text/TASKS.md): on iPadOS Simulator, hovering the
    // mouse cursor over these buttons triggers UIKit's own pointer
    // hover-effect system (`_UIPointerEffectPlatterView`), which computes
    // NaN rounded-rect geometry for its highlight "platter" and floods the
    // console - confirmed via a CG_NUMERICS_SHOW_BACKTRACE capture, and
    // nothing in this file's own layout code is on that call stack.
    // `.hoverEffectDisabled()` does not stop it (verified: identical
    // backtrace with it applied), and `.hoverEffect(.none)` doesn't compile
    // (`HoverEffect` has no such case) - both were guesses at the wrong API.
    // Left un-worked-around for now rather than guess a third time; the
    // right fix likely needs checking Xcode's own autocomplete/current
    // SwiftUI docs for whatever API actually suppresses a Button's default
    // pointer interaction, which isn't something to keep guessing at from
    // memory.
    private func keyButton(_ key: KeypadKey) -> some View {
        Button {
            onKeyTap(key)
        } label: {
            Text(key.title)
                .font(.system(size: 28, weight: .medium, design: .monospaced))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                // `minWidth: 1` guards against `minimumScaleFactor` computing
                // its ratio against a momentarily-zero proposed width - see
                // CalculatorDisplayView for the same guard and why.
                .frame(minWidth: 1, maxWidth: .infinity, minHeight: 64)
        }
        .buttonStyle(CalculatorKeyStyle(kind: key.action.kind))
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
        case .negate, .delete, .clear, .shiftLeft, .shiftRight, .inverse: return .control
        case .operation, .equals: return .operation
        }
    }
}

private struct CalculatorKeyStyle: ButtonStyle {
    let kind: KeypadKey.Action.Kind

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
            .background(background.opacity(configuration.isPressed ? 0.6 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
