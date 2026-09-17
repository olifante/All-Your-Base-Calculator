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

A base-conversion calculator: one tab per numeric base (2...16 on iPhone,
2...36 on iPad), plus a "Base 10*" tab with a classic phone-calculator-style
keypad. All tabs share one calculator state, so you can type a value on the
"Base 10" tab, switch to "Base 16", and see the same value re-rendered in
hex - that's the app's whole point, and it's preserved exactly.

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
- **The 1/x (reciprocal) button doesn't evaluate anything by itself**, and
  when you do press "=" afterwards, it errors out rather than computing a
  reciprocal, because `Digits.power` explicitly rejects negative exponents
  for integer digits. See `CalculatorModel.reciprocalPressed` and
  `CalculatorModelTests.testReciprocalButtonSetsUpExpressionWithoutEvaluating`.
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
