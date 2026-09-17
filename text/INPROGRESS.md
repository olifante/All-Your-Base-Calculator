# In progress: Swift/SwiftUI rewrite of All Your Base Calculator

## Goal
Rewrite the 2011-era Objective-C/UIKit "All Your Base" calculator as a modern
Swift/SwiftUI app, approximately reproducing the many hand-made `.xib` nib
layouts with a single programmatic, adaptive SwiftUI layout instead of ~70
per-base nib files.

## What the original app does (reverse-engineered from HelloGoodbyeUniv/)
- `AllYourBaseAppDelegate_iPhone`/`_iPad` build a `UITabBarController` with one
  tab per numeric base: iPhone = bases 2...16 (tab order 10,6,7,12,2,3,4,5,8,9,
  11,13,14,15,16), iPad = bases 2...36 (tab order 10,6,7,9,16,25,36,2,3,4,5,8,
  11,12,13,14,15,17...36), plus one extra "Base 10*" tab (`base:0` sentinel ->
  alternate/classic calculator layout).
- Each tab is `AllYourBaseViewController` loaded from a nib named e.g.
  `AllYourBaseViewController_iPhone07.xib` / `..._iPadAlternate10.xib`. Every
  nib defines a `portraitView` and a `landscapeView`; the controller swaps
  which one is in `self.view` on `UIDeviceOrientationDidChangeNotification`.
- Each nib lays out: two stacked `UILabel`s (previous/secondary display on
  top of current/primary display), then a grid of `UIButton`s: digits
  `0...base-1` (from `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghij...`)
  filled sequentially left-to-right/top-to-bottom, plus control buttons with
  literal Unicode glyph titles: `∓` negate, `␡` delete, `∁` clear/AC,
  `≪`/`≫` shift-left/right (wired to always-empty no-op model methods),
  `∙` decimal point, and operators `+ − × ÷ ↑ =` (U+2212/00D7/00F7/2191).
  The "Base 10*" alternate nibs use a classic phone-style keypad (7 8 9 /
  4 5 6 / 1 2 3 / 0 .) instead of the sequential grid.
- Two other nibs (`..._iPhoneScientific10`, `..._iPhone10AlternateScientific`,
  and their iPad equivalents) exist on disk but are **not referenced by any
  app-delegate/view-controller code** — dead/experimental nibs from the
  original project. Intentionally NOT ported.
- Model layer: `Digits` (arbitrary-base signed integer string builder with
  push/pop/negate and overflow-checked +,-,*,/,^ using `long long`),
  `FloatingDigits` (Digits subclass adding "." and double-based arithmetic;
  imported by the model but never actually instantiated/used by the UI —
  dead code kept for parity/tests), `AllYourBaseModel` (KVO-observed
  mainDisplay/secondaryDisplay strings, chains operations, error state).
- **Known original-app bug being preserved for fidelity, flagged for the
  author to decide on:** `squareRootPressed`/`cubeRootPressed` do
  `binaryOperationPressed:"^"` then `digitPressed:"."` then digits — but
  plain `Digits.isDigit(".")` is false (only `FloatingDigits` allows "."),
  so `digitPressed(".")` is a silent no-op on the actual UI's plain-`Digits`
  currentDigits. Net effect: the √ button actually computes `x^5` and the
  ∛ button computes `x^333333`, not `x^0.5`/`x^(1/3)`. Ported as-is in
  `CalculatorModel.swift`, called out clearly in code comments + CHANGELOG.

## Plan / file layout
New, separate Swift project living alongside the untouched Objective-C app:
```
Swift/
  AllYourBase.xcodeproj/         (hand-authored, classic explicit pbxproj)
  AllYourBase/
    AllYourBaseApp.swift         @main App + ContentView (TabView, per-idiom base list)
    Digits.swift                 ported Digits.m/.h
    FloatingDigits.swift         ported FloatingDigits.m/.h (kept for parity, unused by UI)
    CalculatorSymbols.swift      Unicode glyph constants (ported from the two .m files)
    CalculatorModel.swift        ported AllYourBaseModel (ObservableObject)
    KeypadLayout.swift           pure layout algorithm: base -> [[KeypadKey]] (sequential
                                  grid) and the classic base-10 phone-keypad arrangement
    CalculatorKeypadView.swift   adaptive LazyVGrid-based keypad button grid
    CalculatorScreenView.swift   display labels + keypad composition for one base/tab
  AllYourBaseTests/
    DigitsTests.swift            ported subset of LogicTests/DigitsTests.m
    FloatingDigitsTests.swift    ported subset of LogicTests/FloatingDigitsTests.m
    CalculatorModelTests.swift   new coverage for AllYourBaseModel-equivalent behavior
```

## Environment constraint
This sandbox has no Swift/Xcode toolchain (Linux container, `swift` not
installed, SwiftUI/UIKit require Apple platforms anyway) — code is written
and manually traced for correctness but **not compiled or run here**. Needs
a real build/test pass in Xcode on macOS before merging.

## Status
- [x] Explored ObjC app end-to-end (model, controllers, app delegates, nib
      contents via XML parsing) to understand exact behavior + layouts.
- [x] Write Core Swift files (Digits w/ folded-in FloatingDigits via
      `allowsPoint`, symbols, model).
- [x] Write SwiftUI UI files (layout algorithm, keypad view, screen view, app).
- [x] Hand-author Xcode project file (no Xcode available to verify it opens -
      see text/TASKS.md).
- [x] Write Swift unit tests ported from LogicTests + new model tests.
- [x] Update text/README.md, CHANGELOG.md, TASKS.md, EXAMPLES.md.
- [ ] Commit + push to `swift` branch.

This file's job is done once the commit lands - text/TASKS.md is the living
list of what's left (mainly: an actual Xcode build/test pass, which this
sandbox can't do).
