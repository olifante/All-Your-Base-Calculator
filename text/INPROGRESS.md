# In Progress: Convert All Your Base Calculator to Swift + SwiftUI

Started: 2026-09-17
Status: **Done** as of 2026-09-17 02:17 UTC — see `text/CHANGELOG.md` and
`text/TASKS.md` for the full record. Left for a follow-up (see TASKS.md
"Known follow-ups"): this could not be built/run/tested since there is no
macOS/Xcode in the environment this was done in, so it needs a real build +
simulator pass, and the placeholder app icon should be replaced.

## Goal

Convert the existing Objective-C / UIKit project (already modernized to
programmatic UIKit in earlier commits) into a Swift + SwiftUI project,
preserving behavior and test coverage.

## Plan

1. [x] Read and understand every existing source file (Digits, FloatingDigits,
   RationalDigits, AllYourBaseModel, view controllers, app/scene delegates,
   NKString, gcd, itoa, both LogicTests files, project.pbxproj, Info.plist).
2. [x] Identify dead code not reachable from the app or its tests:
   - `RationalDigits` (stub, never instantiated, no tests)
   - `gcd.c`/`gcd.h`, `itoa.c`/`itoa.h` (never called anywhere)
   - `NKString` category (`isEmptyNK`/`isNotEmptyNK`, never called anywhere)
   - `CalcBrain.xcdatamodeld` (empty Core Data model, never referenced)
   These are dropped rather than translated. `FloatingDigits` is kept and
   ported (it has full test coverage even though the live app never
   instantiates it directly).
3. [x] Write Swift sources under `AllYourBase/`:
   - `Digits.swift` (value type, throwing arithmetic instead of NSError**)
   - `FloatingDigits.swift`
   - `AllYourBaseModel.swift` (`ObservableObject`)
   - `AllYourBaseApp.swift` (`@main App`)
   - `ContentView.swift` (TabView across bases, replaces the per-base
     view controllers + tab bar controller wiring in the app delegates)
   - `CalculatorView.swift` (SwiftUI calculator screen, replaces
     `AllYourBaseViewController`)
   - `Assets.xcassets` (AppIcon, AccentColor) built from the existing PNGs
4. [x] Port `text/` project docs (this repo didn't have any yet):
   README.md, CHANGELOG.md, TASKS.md, EXAMPLES.md.
5. [x] Port tests to `AllYourBaseTests/` as XCTest (Swift):
   - `DigitsTests.swift`, `FloatingDigitsTests.swift`
   - Note: two pairs of legacy edge-case tests around the `Int64`/`long long`
     min-value boundary (`testInitWithIntegral0x8000000000000000LL` and the
     32-bit `0x80000000` variants) encode C integer-literal-promotion
     artifacts that are self-contradictory under the C standard's own
     promotion rules (verified by hand) and have no equivalent in Swift,
     which has no implicit signed/unsigned literal promotion. These are
     replaced with unambiguous `Int64.min`/`Int64.max`-based equivalents;
     documented in CHANGELOG.
6. [x] Regenerate `AllYourBase.xcodeproj/project.pbxproj` using the `xcodeproj`
   Ruby gem (installed locally) so UUIDs/build phases are well-formed,
   targeting a plain SwiftUI app target + XCTest target, iOS 16+ deployment.
7. [x] Remove now-obsolete Objective-C sources, old Info.plist/pch, per-device
   app delegates/view controllers, xcdatamodeld, LogicTests (old .m/.h).
8. [x] Update `text/README.md`, `text/CHANGELOG.md` (with datetimes),
   `text/TASKS.md` (with completion datetimes), `text/EXAMPLES.md`.
9. [x] Commit and push to `claude/modernize-objective-c-01Mp62y3usLJpTWdWJZHbSCM`.

## Notes / decisions

- No macOS/Xcode available in this sandbox, so the project cannot be built
  or run locally. All conversions are done by careful manual translation and
  cross-checking against the original tests; the pbxproj is generated with
  the `xcodeproj` gem to avoid hand-editing UUIDs.
- Base range: original `Digits` clamped bases to 2...100, but the digit
  alphabet string is only 62 characters long, so bases 63-100 would have
  crashed (`substringToIndex:` out of bounds). Fixed the upper bound to 62
  during the port.
- `integerValue` no longer goes through `strtoll`, which only supports base
  2-36 (it can't tell apart the extra 26 lowercase digits used by bases
  37-62). The Swift port parses digits itself against the base's own
  alphabet, so bases up to 62 convert correctly both ways.
