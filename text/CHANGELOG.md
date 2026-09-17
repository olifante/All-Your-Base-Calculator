# Changelog

## 2026-09-17 17:06 UTC - Swift/SwiftUI rewrite

Added a new, from-scratch Swift/SwiftUI implementation of the calculator
under `Swift/`, alongside the original Objective-C project (left untouched).

### Added
- `Swift/AllYourBase.xcodeproj`: new iOS app + unit test target, hand-authored
  (no Xcode available in the environment this was written in - see
  `text/TASKS.md` for the required follow-up build/verification pass).
- `Digits.swift`: full port of the original `Digits.h`/`.m` arbitrary-base
  signed-digit-string engine (push/pop/negate, overflow-checked `+ - * / ^`,
  base conversion). Uses Swift's overflow-reporting integer operators instead
  of the original's manual C bit-twiddling for the same overflow detection.
- Folded the original `FloatingDigits : Digits` subclass into `Digits` itself
  as an `allowsPoint` flag rather than porting it as a real subclass: the
  shipped app never actually instantiated `FloatingDigits` (only imported the
  header, with the double-based code path commented out in
  `AllYourBaseModel.m`'s `setBase:`), so porting it as a parallel, easy-to-
  diverge subclass would have added risk for zero behavioral benefit. All of
  its original test coverage was kept (see below).
- `CalculatorModel.swift`: port of `AllYourBaseModel`, as an `ObservableObject`
  (`@Published mainDisplay`/`secondaryDisplay`/`error`) instead of the
  original's manual KVO (`observeValueForKeyPath:`).
- `KeypadLayout.swift` + `CalculatorKeypadView.swift`: the programmatic,
  data-driven replacement for the ~70 hand-made per-base `.xib` nibs. One
  algorithm produces the button list for any base (2...100), one adaptive
  SwiftUI grid renders it, reflowing column count with screen width/rotation
  instead of switching between separate hand-tuned portrait/landscape nib
  subviews. See `text/README.md` for why this approach was chosen over a
  literal per-nib port.
- `CalculatorScreenView.swift`, `CalculatorDisplayView`: the two stacked
  display labels + keypad composition for one tab.
- `AllYourBaseApp.swift`: `TabView`-based replacement for
  `AllYourBaseAppDelegate_iPhone`/`_iPad` + `MainWindow_i{Phone,Pad}.xib`.
  Reproduces the exact original tab ordering (`BaseCatalog.iPhoneBases`/
  `iPadBases`) and, importantly, shares a single `CalculatorModel` across
  every tab - preserving the original's core feature where switching tabs
  re-renders the same value in the new tab's base rather than resetting it.
- `CalculatorSymbols.swift`: the Unicode glyph constants from
  `AllYourBaseViewController.m` plus the literal button-title glyphs that
  were baked directly into the original `.xib` files (delete/clear/shift
  symbols had no named ObjC constant to port from).
- `Swift/AllYourBaseTests/DigitsTests.swift`: ported subset of
  `LogicTests/DigitsTests.m` (convert/init/push/pop/negate/arithmetic) plus
  the `FloatingDigits`-flavored (`allowsPoint`) tests folded in from
  `LogicTests/FloatingDigitsTests.m`. A handful of the original's tests
  relied on C-specific undefined/implementation-defined behavior around
  hex literals wider than `long long` (e.g. `0x8000000000000000LL`); those
  were not ported as-is, since Swift traps instead of silently
  reinterpreting bits - the one meaningful edge case they were checking
  (`Int64.min` round-tripping through base conversion) is covered instead
  via `testConvertInt64MinToBase10` and `testNegateInt64MinIsUnaffected`,
  which exercise the same guard without relying on UB.
- `Swift/AllYourBaseTests/CalculatorModelTests.swift`: new coverage for the
  orchestration layer (the original had no model-level test target) -
  digit entry, chained operations, error handling/recovery, and the
  cross-tab base-switching behavior. Writing these tests by hand-tracing the
  ported logic surfaced two real, preserved-on-purpose quirks in the
  original app - see `text/README.md`'s "Notable original-app behavior
  preserved as-is" section and the inline comments on
  `testReciprocalButtonSetsUpExpressionWithoutEvaluating` and
  `testSquareRootButtonActuallyRaisesToThe5thPower`.

### Not ported (dead code in the original)
- `AllYourBaseViewController_i{Phone,Pad}Scientific10.xib` and
  `..._i{Phone,Pad}10AlternateScientific.xib`: present on disk but never
  referenced by any app delegate or view controller in the original project
  (confirmed via `AllYourBase.xcodeproj/project.pbxproj` build-file wiring
  and both app delegates' source). These are where the original's
  `squareRootPressed`/`cubeRootPressed`/`reciprocalPressed` IBActions were
  actually wired to buttons - since those nibs never shipped, those three
  actions were effectively unreachable dead code in the real app too.
- `RationalDigits.h`/`.m`: every method is a stub returning `nil`/`""` in the
  original; not ported.

### Known limitations of this pass
- Written and hand-traced without a Swift/Xcode toolchain available (see
  `text/TASKS.md`) - not yet compiled or run.
- No app icon / asset catalog yet (the new project builds without one; the
  original's `Icon*.png` files were not migrated into an `.xcassets` catalog).
