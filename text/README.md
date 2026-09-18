# All Your Base Calculator - Swift/SwiftUI rewrite

This branch adds a from-scratch Swift/SwiftUI rewrite of the original 2011
Objective-C/UIKit "All Your Base" calculator, living alongside the untouched
original app.

## Layout

```
HelloGoodbyeUniv/, LogicTests/, AllYourBase.xcodeproj/   <- original Objective-C app (untouched)
Swift/
  AllYourBase.xcodeproj/     <- new Xcode project (SwiftUI, iOS)
  AllYourBase/               <- app sources
  AllYourBaseTests/          <- unit tests (XCTest)
text/
  README.md, CHANGELOG.md, TASKS.md, EXAMPLES.md, INPROGRESS.md
```

Open `Swift/AllYourBase.xcodeproj` in Xcode to build/run/test the new app.
The original `AllYourBase.xcodeproj` at the repo root still builds the
original Objective-C app unchanged.

## What the app does

A base-conversion calculator: a picker at the top selects the numeric base
(2...16 on iPhone, 2...36 on iPad), plus a "Base 10*" entry with a classic
phone-calculator-style keypad. Every base selection shares one calculator
state, so you can type a value at "Base 10", switch the picker to
"Base 16", and see the same value re-rendered in hex - that's the app's
whole point, and it's preserved exactly. (The original used one
`UITabBarController` tab per base instead of a picker - see CHANGELOG.md
for why this rewrite switched.)

## Features added beyond the original

A few things the original never had, added on top of the port:

- **Division is exact, not truncating.** `7 ÷ 2` shows the exact fraction
  `7:2` (a reduced numerator:denominator pair - see `Rational.swift`), not
  the old `3`. `:` is used rather than `/` or `÷` specifically so a
  fraction *result* never looks like a still-pending division expression
  (`CalculatorSymbols.prettify` turns `/` into `÷` across the whole display
  string, so a `/`-separated fraction would be visually indistinguishable
  from `7 ÷ 2` mid-entry).
- **The shift keys (`≪`/`≫`) actually do something now** - shift left
  multiplies by the current base, shift right is a truncating divide by it
  (deliberately lossy, unlike `÷`, the way a real digit/bit shift is).
  They were wired to a no-op in every original nib.
- **A working inverse ("1/x") key**, exact via the same `Rational` math as
  `÷` - `1/x` for `x = 3` is `1:3`. This is a new key, separate from the
  original reciprocal button described below, which is left exactly as
  broken as it always was.
- **The delete key shows the standard backspace icon** (⌫) instead of the
  original's rare, poorly-supported "SYMBOL FOR DELETE" (␡) glyph.

See `text/CHANGELOG.md`'s 2026-09-18 entry for the full design writeup.

## Why a rewrite instead of a 1:1 port

The original project has one hand-made `.xib` nib per base (~70 nibs total
across iPhone/iPad x portrait/landscape variants baked into each nib), each
with hand-placed button frames sized for that base's digit count. Rather
than hand-porting 70 nibs into 70 SwiftUI views, this rewrite factors the
*shape* those nibs all shared - a control row, a sequential digit grid, an
operator column/row - into one data-driven layout algorithm
(`KeypadLayout.swift`) and one adaptive SwiftUI view (`CalculatorKeypadView`)
that renders it for any base and reflows for any screen size/orientation.
See `text/INPROGRESS.md` for the full reverse-engineering notes this was
based on (nib button positions/titles extracted directly from the original
XML `.xib` files).

Two pairs of nibs (`..._Scientific10` / `..._10AlternateScientific`, iPhone
and iPad) are **not** ported: they're dead files in the original project,
never referenced by any app delegate or view controller.

## Notable original-app behavior preserved as-is

- **The √ and ∛ buttons don't compute a square/cube root.** They build an
  exponent via `digitPressed(".")` then more digits, but `digitPressed(".")`
  is a no-op on the calculator's actual (integer-only) `Digits` state, so
  the exponent that lands is just the digits *after* the dot: the shipped
  behavior is "raise to the 5th power" and "raise to the 333333rd power".
  See `CalculatorModel.squareRootPressed`/`cubeRootPressed`.
- **The original 1/x (reciprocal) button doesn't evaluate anything by
  itself**, and when you do press "=" afterwards, it errors out rather than
  computing a reciprocal, because `Digits.power` explicitly rejects
  negative exponents for integer digits. See `CalculatorModel.
  reciprocalPressed` and `CalculatorModelTests.
  testReciprocalButtonSetsUpExpressionWithoutEvaluating`. (This is
  unrelated to - and left unfixed on purpose alongside - the new, working
  "1/x" inverse key described above; the two are deliberately separate
  methods.)
- None of the above three buttons are actually reachable from any keypad
  that ships in the app (they were only wired up in the dead Scientific10
  nibs) - kept in `CalculatorModel` for completeness/fidelity, not currently
  exposed by `CalculatorKeypadView`.

See `text/CHANGELOG.md` for the full list of what changed and why.

## Building / testing

This was written in a Linux sandbox with no Swift/Xcode toolchain available,
so **none of the Swift code has actually been compiled or run yet**. It was
written carefully and traced by hand against the original Objective-C
behavior (including writing a matching XCTest suite), but a real build in
Xcode on macOS - and fixing whatever that build turns up - is the necessary
next step before treating this as done. See `text/TASKS.md`.
