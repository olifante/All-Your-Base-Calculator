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
- [x] Open `Swift/AllYourBase.xcodeproj` in real Xcode on macOS - done by the
      user (with a few local fixes) - confirmed 2026-09-17 17:50 UTC.
- [x] Fix the keypad layout bugs the first real run surfaced: buttons
      collapsing to tiny squares stranded at the top-left of the screen
      (bad `GeometryReader`/`aspectRatio` interaction), a missing/tofu glyph
      for the negate key (`"Courier"` font gap), and restructure the keypad
      into three separate rows (editing / digits / operations) with larger
      buttons as requested. Also restored the original's ASCII->Unicode
      operator prettifying for the display labels, which had been missed in
      the first pass - completed 2026-09-17 17:57 UTC. See CHANGELOG.md for
      the full breakdown.
- [x] Fix a NaN/CoreGraphics console flood the 17:57 UTC fix introduced
      (`GeometryReader`'s proxy size fed into a hard `.frame(width:height:)`,
      a transient zero height dividing into the digit grid's flexible
      row-height math) - completed 2026-09-17 18:08 UTC. See CHANGELOG.md.
- [x] Root-caused the remaining NaN spam via an actual
      `CG_NUMERICS_SHOW_BACKTRACE=1` capture (not another guess): it's
      entirely inside UIKit's own pointer hover-effect system
      (`_UIPointerEffectPlatterView`), not our code - confirmed 2026-09-17
      18:28 UTC. Two follow-up guesses at the API to suppress it both
      failed - `.hoverEffectDisabled()` compiled but was verified not to
      change anything (identical backtrace), and `.hoverEffect(.none)`
      doesn't compile at all (`HoverEffect` has no `.none` case). Reverted
      to a clean, documented, build-passing state (a NOTE comment in
      `CalculatorKeypadView.keyButton`) rather than guess a third time -
      2026-09-17 18:47 UTC. See CHANGELOG.md.

### Known open issue
- [ ] **The pointer-hover NaN console spam is unresolved, and is now confirmed
      to NOT be a SwiftUI-API-level problem.** Confirmed cause: UIKit's
      `_UIPointerEffectPlatterView` (the iPadOS Simulator's mouse-hover
      highlight effect on any `Button`) computes NaN rounded-rect geometry for
      these buttons. Two confirmed non-fixes: `.hoverEffect(.none)` (doesn't
      compile - `HoverEffect` has no such case), and, importantly,
      `.hoverEffectDisabled()` applied at exactly the right place (directly on
      the `Button`, after `.buttonStyle(...)`, i.e. the outermost interactive
      view - see commit `bdf4398`) - re-verified 2026-09-17 19:05 UTC that this
      placement still produces an identical backtrace. That rules out "wrong
      call site" as the explanation and points at something below SwiftUI's
      own `hoverEffect`/`hoverEffectDisabled` API surface entirely: on
      iPadOS, UIKit adds a `UIPointerInteraction` to button-like controls
      automatically whenever a pointer (Simulator mouse/trackpad, or a real
      trackpad/mouse on a real iPad) is present, and that's a lower-level
      mechanism than the SwiftUI modifier we've been trying.
      **Recommended next step (no more API guessing from memory):** in the
      Simulator, try Xcode's Simulator menu -> I/O -> Input -> "Send Pointer
      Events" (wording varies by Xcode version) and turn it OFF, or unplug/stop
      simulating a trackpad, then reproduce. If the console goes quiet with
      pointer input disabled, this is confirmed Simulator-mouse-testing-only
      noise (real iPad touch has no persistent hover state) and is reasonable
      to leave alone rather than keep chasing with more code changes. If it
      still happens with pointer input off, that's new information worth
      reporting back, and only then does going further (e.g. a
      `UIViewRepresentable` that strips the auto-added `UIPointerInteraction`)
      become worth the risk of another from-memory guess.

### To do (before treating this as production-ready)
- [ ] Re-run the app after the 18:08 UTC fix and confirm both (a) the
      console is quiet (no more NaN/CoreGraphics spam) and (b) the keypad
      still looks right on both iPhone and iPad, in portrait and landscape,
      across a small base (e.g. 2), a mid-size base (10), and a large one
      (36) - the digit-grid row count varies a lot across that range and
      hasn't been visually re-checked since the layout fix.
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
