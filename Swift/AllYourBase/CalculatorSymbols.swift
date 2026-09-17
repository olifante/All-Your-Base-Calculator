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

    /// Equivalent of the ASCII->Unicode replacement `updateLabels` did in the
    /// original `AllYourBaseViewController.m` before setting label text:
    /// `CalculatorModel`'s display strings always use plain ASCII operator
    /// tokens internally ("+", "-", "*", "/", "^" - see CalculatorModel's
    /// `performPendingOperation`), and this is the view-layer step that
    /// turns those into the pretty glyphs for display. This is a blind
    /// substitution over the whole string, exactly like the original - which
    /// also means a negative number's "-" sign gets prettified into the same
    /// Unicode minus as the subtraction operator, matching the original's
    /// actual (intentional) behavior.
    static func prettify(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "^", with: power)
        result = result.replacingOccurrences(of: "/", with: divide)
        result = result.replacingOccurrences(of: "*", with: times)
        result = result.replacingOccurrences(of: "-", with: minus)
        return result
    }
}
