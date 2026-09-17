//
//  CalculatorSymbols.swift
//  AllYourBase
//
//  The Unicode glyphs used as button titles and operator tokens throughout
//  the app, gathered from the literal `unichar` constants in the original
//  AllYourBaseViewController.m plus the literal button titles baked into the
//  .xib files (Interface Builder had no named-constant concept, so those were
//  just typed directly into each button's title field).
//

import Foundation

enum CalculatorSymbols {
    // Binary operators, exactly as declared in AllYourBaseViewController.m.
    static let plus = "+"
    static let minus = "\u{2212}"      // − MINUS SIGN
    static let times = "\u{00d7}"      // × MULTIPLICATION SIGN
    static let divide = "\u{00f7}"     // ÷ DIVISION SIGN
    static let power = "\u{2191}"      // ↑ UPWARDS ARROW
    static let equals = "="

    // The keypad's decimal-point button glyph (distinct from Digits'
    // internal `pointString`, U+2027, which this app never actually shows).
    static let point = "\u{2219}"      // ∙ BULLET OPERATOR

    // Control buttons wired directly to their own IBActions in the original
    // (never compared by title, just literal glyphs on the button).
    static let negate = "\u{2213}"     // ∓ MINUS-OR-PLUS SIGN (the +/- key)
    static let delete = "\u{2421}"     // ␡ SYMBOL FOR DELETE
    static let clear = "\u{2201}"      // ∁ COMPLEMENT (the "AC"/clear key)
    static let shiftLeft = "\u{226a}"  // ≪ MUCH LESS-THAN (present in every
    static let shiftRight = "\u{226b}" // ≫ MUCH GREATER-THAN nib, always a no-op)

    static let negative = "-"          // U+002D HYPHEN-MINUS, the sign prefix

    static let binaryOperators = [plus, minus, times, divide, power]
}
