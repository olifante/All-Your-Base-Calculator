//
//  KeypadLayout.swift
//  AllYourBase
//
//  Pure layout data: turns "base N" (or "the classic Base 10* layout") into
//  an ordered list of keys. This is the single programmatic stand-in for the
//  ~70 hand-built .xib button grids in the original project - instead of one
//  nib per base with hand-placed button frames, every base shares this one
//  algorithm and CalculatorKeypadView lays the result out in an adaptive
//  grid, reflowing its column count to the available width the way the
//  original's portrait vs. landscape nibs did with hand-tuned frames.
//
//  Every original nib's grid had the same anatomy: a control row (negate,
//  delete, shift left/right, clear), the digits 0...base-1 (plus the
//  decimal point) filling left-to-right/top-to-bottom in `Digits.allDigits`
//  order, and the operators + "=" at the trailing edge. That anatomy is
//  reproduced key-for-key here, now split into three explicit groups
//  (editing / digits / operations) that CalculatorKeypadView renders as
//  three visually separate rows/sections rather than one long interleaved
//  grid; the exact pixel positions from the originals are not reproduced
//  (see INPROGRESS.md/README for why an exact per-base pixel port isn't the
//  goal). The shift keys were an always-no-op original bug until they were
//  implemented for real (see CalculatorModel); a new "1/x" inverse key was
//  added to the same editing row since it didn't exist in the original at
//  all - see CHANGELOG.md.
//

import Foundation

struct KeypadKey: Identifiable {
    enum Action: Equatable {
        case digit(String)
        case point
        case negate
        case delete
        case clear
        case shiftLeft
        case shiftRight
        case inverse
        case operation(String) // one of "+", "-", "*", "/", "^"
        case equals
    }

    let id = UUID()
    let title: String
    let action: Action
}

enum KeypadLayout {

    /// The "editing" row shown above the digit grid for every "Base N"
    /// picker entry: clear, delete, negate, the two shift keys, and the
    /// inverse ("1/x") key.
    static func editingKeys() -> [KeypadKey] {
        [
            KeypadKey(title: CalculatorSymbols.clear, action: .clear),
            KeypadKey(title: CalculatorSymbols.delete, action: .delete),
            KeypadKey(title: CalculatorSymbols.negate, action: .negate),
            KeypadKey(title: CalculatorSymbols.shiftLeft, action: .shiftLeft),
            KeypadKey(title: CalculatorSymbols.shiftRight, action: .shiftRight),
            KeypadKey(title: CalculatorSymbols.inverse, action: .inverse),
        ]
    }

    /// The digit grid for a given base: the decimal point followed by
    /// 0...base-1 in `Digits.allDigits` order.
    static func digitKeys(forBase base: Int) -> [KeypadKey] {
        var keys: [KeypadKey] = [KeypadKey(title: CalculatorSymbols.point, action: .point)]
        for symbol in Digits.allowedDigits(forBase: base) {
            let digit = String(symbol)
            keys.append(KeypadKey(title: digit, action: .digit(digit)))
        }
        return keys
    }

    /// The binary operators + "=", shown as their own row below the digits.
    static func operationKeys() -> [KeypadKey] {
        [
            KeypadKey(title: CalculatorSymbols.plus, action: .operation("+")),
            KeypadKey(title: CalculatorSymbols.minus, action: .operation("-")),
            KeypadKey(title: CalculatorSymbols.times, action: .operation("*")),
            KeypadKey(title: CalculatorSymbols.divide, action: .operation("/")),
            KeypadKey(title: CalculatorSymbols.power, action: .operation("^")),
            KeypadKey(title: CalculatorSymbols.equals, action: .equals),
        ]
    }

    /// The classic phone-calculator-style grid used by the "Base 10*" picker entry
    /// (ported from AllYourBaseViewController_i{Phone,Pad}Alternate10.xib),
    /// always laid out in a fixed 5-column grid:
    ///   7  8  9  C  DEL
    ///   4  5  6  +  -
    ///   1  2  3  x  /
    ///   0  .  +/- ^  =
    static let classicColumnCount = 5

    static func classicKeys() -> [KeypadKey] {
        [
            KeypadKey(title: "7", action: .digit("7")),
            KeypadKey(title: "8", action: .digit("8")),
            KeypadKey(title: "9", action: .digit("9")),
            KeypadKey(title: CalculatorSymbols.clear, action: .clear),
            KeypadKey(title: CalculatorSymbols.delete, action: .delete),

            KeypadKey(title: "4", action: .digit("4")),
            KeypadKey(title: "5", action: .digit("5")),
            KeypadKey(title: "6", action: .digit("6")),
            KeypadKey(title: CalculatorSymbols.plus, action: .operation("+")),
            KeypadKey(title: CalculatorSymbols.minus, action: .operation("-")),

            KeypadKey(title: "1", action: .digit("1")),
            KeypadKey(title: "2", action: .digit("2")),
            KeypadKey(title: "3", action: .digit("3")),
            KeypadKey(title: CalculatorSymbols.times, action: .operation("*")),
            KeypadKey(title: CalculatorSymbols.divide, action: .operation("/")),

            KeypadKey(title: "0", action: .digit("0")),
            KeypadKey(title: CalculatorSymbols.point, action: .point),
            KeypadKey(title: CalculatorSymbols.negate, action: .negate),
            KeypadKey(title: CalculatorSymbols.power, action: .operation("^")),
            KeypadKey(title: CalculatorSymbols.equals, action: .equals),
        ]
    }

    /// Picks a column count for the sequential grid from the available
    /// width, standing in for the original's separate hand-tuned portrait
    /// (5-6 columns) vs. landscape (6-8+ columns) nib frames.
    static func sequentialColumnCount(forWidth width: Double) -> Int {
        switch width {
        case ..<500: return 5
        case ..<800: return 6
        default: return 8
        }
    }
}
