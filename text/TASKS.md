# Tasks

## Swift/SwiftUI rewrite

### Done
- [x] Reverse-engineer the original app's behavior and layouts (model logic,
      view controller action wiring, per-base nib button grids parsed
      directly from the `.xib` XML, app delegate tab-list construction) -
      completed 2026-09-17 16:50 UTC.
- [x] Port `Digits`/`FloatingDigits` (folded into one `Digits` type with an
      `allowsPoint` flag) to `Swift/AllYourBase/Digits.swift` - completed
      2026-09-17 16:58 UTC.
- [x] Port `AllYourBaseModel` to `Swift/AllYourBase/CalculatorModel.swift` as
      an `ObservableObject`, including the shared-model-across-tabs behavior
      and the preserved sqrt/cbrt/reciprocal quirks - completed 2026-09-17
      17:00 UTC.
- [x] Design and implement the programmatic keypad layout
      (`KeypadLayout.swift`) and adaptive SwiftUI rendering
      (`CalculatorKeypadView.swift`, `CalculatorScreenView.swift`) standing
      in for the ~70 original per-base nibs - completed 2026-09-17 17:02 UTC.
- [x] Wire up the app entry point and tab list matching the original's
      per-idiom base ordering (`AllYourBaseApp.swift`) - completed 2026-09-17
      17:03 UTC.
- [x] Hand-author `Swift/AllYourBase.xcodeproj/project.pbxproj` (app + test
      target, GENERATE_INFOPLIST_FILE, no storyboard/xib) - completed
      2026-09-17 17:05 UTC.
- [x] Port a representative subset of `LogicTests/DigitsTests.m` +
      `FloatingDigitsTests.m` to `Swift/AllYourBaseTests/DigitsTests.swift` -
      completed 2026-09-17 17:04 UTC.
- [x] Write new `CalculatorModelTests.swift` covering orchestration behavior
      the original had no test target for - completed 2026-09-17 17:05 UTC.
- [x] Write `text/README.md`, `text/CHANGELOG.md`, `text/TASKS.md`,
      `text/EXAMPLES.md` - completed 2026-09-17 17:07 UTC.

### To do (before treating this as production-ready)
- [ ] **Open `Swift/AllYourBase.xcodeproj` in real Xcode on macOS and fix
      whatever the first build turns up.** This is the single most important
      remaining task: none of this Swift code has been compiled - it was
      written and manually traced line-by-line in a Linux sandbox with no
      Swift toolchain available. Expect small issues (an unused-variable
      warning, maybe a type-inference hiccup) rather than deep design
      problems, but budget real time for this pass.
- [ ] Run the `AllYourBaseTests` target and confirm every test passes;
      re-check the by-hand-traced expected values in
      `CalculatorModelTests.swift` (especially the "= " display-prefix
      behavior and the two documented quirky-button tests) against the
      actual running app.
- [ ] Manually exercise the app in the simulator: type a number on one base
      tab, switch tabs, confirm the value re-renders correctly in the new
      base (the app's core feature); rotate the device and confirm the
      keypad reflows sensibly; try the "Base 10*" classic-layout tab.
- [ ] Decide whether to add an `Assets.xcassets` with an app icon (the
      original's `Icon.png`/`Icon@2x.png`/etc. could be migrated in) - the
      new project currently has none.
- [ ] Decide whether the preserved sqrt/cbrt/reciprocal bugs (see
      `text/README.md`) should actually be fixed now that they're easy to
      spot, and if so whether/how to expose those three operations on a
      keypad (they aren't wired to any button in either the original's
      shipped nibs or this rewrite).
- [ ] Consider adding a real app icon / launch screen customization beyond
      the auto-generated defaults (`INFOPLIST_KEY_UILaunchScreen_Generation`).
- [ ] Consider whether `RationalDigits` (a stub in the original, not ported)
      should ever be implemented for real, or removed from scope permanently.
