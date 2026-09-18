//
//  Rational.swift
//  AllYourBase
//
//  An exact fraction: a numerator and denominator with no common divisor,
//  denominator always positive. Introduced so integer division (previously
//  `Digits.divide`, truncating like C's `/`) can produce an exact result
//  instead of losing the remainder - `7 ÷ 2` is now the exact value
//  `7:2`, not the truncated `3`. Every operation here is overflow-checked
//  the same way `Digits`'s own Int64 math already is, returning `nil`
//  instead of trapping - `Digits`'s arithmetic methods turn a `nil` here
//  into a thrown `DigitsError`, exactly like an Int64 overflow already did.
//
//  This does not attempt to support non-terminating fractional entry (e.g.
//  typing "0.1"): `Digits`'s digit-by-digit entry only ever builds a plain
//  integer (see `allowsPoint`, which the live app never actually uses), and
//  a `Rational` only ever comes from a computed result - a division or an
//  inversion - never from typing. Numerator and denominator are each just
//  another integer to be typeset in the current base (via
//  `Digits.convertInteger`), the same way the original app already handled
//  every displayed number.
//

import Foundation

struct Rational: Equatable {
    let numerator: Int64
    let denominator: Int64 // always > 0

    static let zero = Rational(numerator: 0, denominator: 1)!

    /// Fails only when normalizing the sign would require negating
    /// `Int64.min`, which has no valid `Int64` representation - this is the
    /// same edge case the original `Digits.divide` explicitly guarded
    /// against (dividing `Int64.min` by `-1`), generalized to apply
    /// whenever it comes up while constructing a fraction.
    init?(numerator: Int64, denominator: Int64) {
        precondition(denominator != 0, "Rational denominator must not be zero")

        var n = numerator
        var d = denominator
        if d < 0 {
            guard n != Int64.min, d != Int64.min else { return nil }
            n = -n
            d = -d
        }

        let divisor = Int64(Rational.greatestCommonDivisor(n.magnitude, d.magnitude))
        if divisor > 1 {
            n /= divisor
            d /= divisor
        }

        // `self.` is required here: the init parameters are also named
        // `numerator`/`denominator`, and being (implicitly `let`)
        // parameters, they shadow the properties - without `self.`, this
        // would try to assign to the parameters themselves and fail to
        // compile ("cannot assign to value: 'numerator' is a 'let' constant").
        self.numerator = n
        self.denominator = d
    }

    private static func greatestCommonDivisor(_ a: UInt64, _ b: UInt64) -> UInt64 {
        var a = a
        var b = b
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return a
    }

    private static func checkedMultiply(_ a: Int64, _ b: Int64) -> Int64? {
        let (result, overflow) = a.multipliedReportingOverflow(by: b)
        return overflow ? nil : result
    }

    private static func checkedAdd(_ a: Int64, _ b: Int64) -> Int64? {
        let (result, overflow) = a.addingReportingOverflow(b)
        return overflow ? nil : result
    }

    private static func checkedNegate(_ a: Int64) -> Int64? {
        a == Int64.min ? nil : -a
    }

    // MARK: arithmetic
    // Cross-multiplication (`a/b op c/d`) the way any exact-fraction math
    // works by hand - every intermediate multiply/add/negate is overflow-
    // checked, and the failable `Rational.init` folds in the one sign-
    // normalization edge case above, so a single `nil` from any of these
    // covers every way the true result could fail to fit in two `Int64`s.

    static func + (lhs: Rational, rhs: Rational) -> Rational? {
        guard let ad = checkedMultiply(lhs.numerator, rhs.denominator),
              let bc = checkedMultiply(rhs.numerator, lhs.denominator),
              let bd = checkedMultiply(lhs.denominator, rhs.denominator),
              let sum = checkedAdd(ad, bc) else { return nil }
        return Rational(numerator: sum, denominator: bd)
    }

    static func - (lhs: Rational, rhs: Rational) -> Rational? {
        guard let ad = checkedMultiply(lhs.numerator, rhs.denominator),
              let bc = checkedMultiply(rhs.numerator, lhs.denominator),
              let negatedBC = checkedNegate(bc),
              let bd = checkedMultiply(lhs.denominator, rhs.denominator),
              let difference = checkedAdd(ad, negatedBC) else { return nil }
        return Rational(numerator: difference, denominator: bd)
    }

    static func * (lhs: Rational, rhs: Rational) -> Rational? {
        guard let numerator = checkedMultiply(lhs.numerator, rhs.numerator),
              let denominator = checkedMultiply(lhs.denominator, rhs.denominator) else { return nil }
        return Rational(numerator: numerator, denominator: denominator)
    }

    /// `nil` for division by zero as well as for overflow - callers that
    /// need to distinguish "undefined" from "overflow" (to pick the right
    /// error message) check `rhs.numerator != 0` themselves first, the same
    /// way `Digits.divide` already checked its divisor before this existed.
    static func / (lhs: Rational, rhs: Rational) -> Rational? {
        guard rhs.numerator != 0 else { return nil }
        guard let numerator = checkedMultiply(lhs.numerator, rhs.denominator),
              let denominator = checkedMultiply(lhs.denominator, rhs.numerator) else { return nil }
        return Rational(numerator: numerator, denominator: denominator)
    }

    /// `1/x`. `nil` for `x == 0` (undefined) as well as for the
    /// `Int64.min`-negation edge case - see `Digits.invert`, which
    /// distinguishes the two by checking `numerator != 0` itself first.
    func inverse() -> Rational? {
        guard numerator != 0 else { return nil }
        return Rational(numerator: denominator, denominator: numerator)
    }

    /// Exact exponentiation to a non-negative integer power - `numerator`
    /// and `denominator` are each raised separately via the same
    /// overflow-checked exponentiation-by-squaring `Digits.power` used for
    /// a plain integer base (denominator `1`); this is what lets `power()`
    /// share one implementation for both.
    func power(_ exponent: Int64) -> Rational? {
        precondition(exponent >= 0, "Rational.power expects a non-negative exponent")
        guard let poweredNumerator = Rational.checkedPower(numerator, exponent),
              let poweredDenominator = Rational.checkedPower(denominator, exponent) else { return nil }
        return Rational(numerator: poweredNumerator, denominator: poweredDenominator)
    }

    private static func checkedPower(_ base: Int64, _ exponent: Int64) -> Int64? {
        var result: Int64 = 1
        var currentBase = base
        var remainingExponent = exponent
        while remainingExponent > 0 {
            if remainingExponent & 1 == 1 {
                guard let multiplied = checkedMultiply(result, currentBase) else { return nil }
                result = multiplied
            }
            remainingExponent >>= 1
            if remainingExponent > 0 {
                guard let squared = checkedMultiply(currentBase, currentBase) else { return nil }
                currentBase = squared
            }
        }
        return result
    }

    /// Renders as a bare integer when this is a whole number, or as
    /// "numerator:denominator" (both typeset in `base`) otherwise - see
    /// `Digits.rationalSeparator` for why `:` and not `/` or `÷`.
    func description(inBase base: Int) -> String {
        let numeratorDigits = Digits.convertInteger(numerator, toBase: base)
        guard denominator != 1 else { return numeratorDigits }
        return numeratorDigits + Digits.rationalSeparator + Digits.convertInteger(denominator, toBase: base)
    }
}
