//
//  CalculatorKeypadView.swift
//  AllYourBase
//
//  The one SwiftUI view that stands in for every original per-base .xib's
//  button grid. Renders whatever `KeypadKey` list `KeypadLayout` produced in
//  a fixed-column grid, styled to loosely echo the original buttons (a
//  Courier title font, light/dark button backgrounds, digits vs. operators
//  colored differently).
//

import SwiftUI

struct CalculatorKeypadView: View {
    let keys: [KeypadKey]
    let columns: Int
    let onKeyTap: (KeypadKey) -> Void

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: max(columns, 1))
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 4) {
            ForEach(keys) { key in
                Button {
                    onKeyTap(key)
                } label: {
                    Text(key.title)
                        .font(.custom("Courier", size: 22))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit)
                }
                .buttonStyle(CalculatorKeyStyle(kind: key.action.kind, isInert: key.isInert))
            }
        }
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
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}
