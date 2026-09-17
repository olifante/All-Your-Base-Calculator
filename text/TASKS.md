# Tasks

## Swift + SwiftUI conversion

- [x] Read and understand every existing Objective-C source file, the two
      test bundles, and the Xcode project file. (2026-09-17 02:17 UTC)
- [x] Identify and drop dead code not reachable from the app or its tests
      (`RationalDigits`, `gcd`, `itoa`, `NKString`, `CalcBrain.xcdatamodeld`,
      unwired `IBAction`s, unused `Digits`/model API). (2026-09-17 02:17 UTC)
- [x] Port `Digits` to a Swift `struct` (`AllYourBase/Digits.swift`),
      including the base-range/`strtoll` fixes described in
      `text/CHANGELOG.md`. (2026-09-17 02:17 UTC)
- [x] Port `FloatingDigits` to `AllYourBase/FloatingDigits.swift` via
      composition over `Digits`. (2026-09-17 02:17 UTC)
- [x] Port `AllYourBaseModel` to an `ObservableObject`
      (`AllYourBase/AllYourBaseModel.swift`). (2026-09-17 02:17 UTC)
- [x] Build the SwiftUI replacement for the UIKit view controllers/app
      delegates: `AllYourBaseApp.swift`, `ContentView.swift`,
      `CalculatorView.swift`. (2026-09-17 02:17 UTC)
- [x] Build `Assets.xcassets` (app icon from the existing artwork, accent
      color). (2026-09-17 02:17 UTC)
- [x] Port `DigitsTests`/`FloatingDigitsTests` to XCTest under
      `AllYourBaseTests/`. (2026-09-17 02:17 UTC)
- [x] Regenerate `AllYourBase.xcodeproj` (via the `xcodeproj` Ruby gem) with
      an `AllYourBase` app target and an `AllYourBaseTests` XCTest target,
      iOS 16 deployment target, generated `Info.plist`. (2026-09-17 02:17 UTC)
- [x] Remove the obsolete Objective-C sources, old Info.plist/pch, per-device
      app delegates/view controllers, `.xcdatamodeld`, old `LogicTests/`,
      and stale `xcuserdata`/workspace state. (2026-09-17 02:17 UTC)
- [x] Write `text/README.md`, `text/CHANGELOG.md`, `text/TASKS.md`,
      `text/EXAMPLES.md`. (2026-09-17 02:17 UTC)
- [x] Commit and push to
      `claude/modernize-objective-c-01Mp62y3usLJpTWdWJZHbSCM`. (2026-09-17 02:17 UTC)

## Known follow-ups (not done in this pass)

- [ ] Replace the placeholder app icon (upscaled from the old
      512×512 `iTunesArtwork.png`) with a real 1024×1024 icon.
- [ ] This conversion could not be built or run (no macOS/Xcode available
      in the environment it was done in) — worth a build + a pass through
      the simulator to confirm the SwiftUI layout looks right on both
      iPhone and iPad before the next release.
- [ ] `FloatingDigits`' non-decimal-base fractional conversion
      (`FloatingDigits.convertDouble` for `base != 10`) is new, untested-by-
      the-original-suite behavior; consider adding coverage if `FloatingDigits`
      ever becomes reachable from the UI (today it still isn't, matching the
      original app).
