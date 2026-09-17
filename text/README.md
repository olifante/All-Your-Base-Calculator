# All Your Base Calculator

An iOS calculator that works in any base from 2 to 62, not just base 10.
Originally written in Objective-C / UIKit (starting 2011); as of this
conversion the app is 100% Swift and SwiftUI.

## Project layout

```
AllYourBase.xcodeproj/        Xcode project (app + unit test targets)
AllYourBase/                  App target sources
  AllYourBaseApp.swift        @main App entry point (SwiftUI app lifecycle)
  ContentView.swift           Picker-based base selector + calculator view
  CalculatorView.swift        The calculator screen with digit pad & operations
  AllYourBaseModel.swift      ObservableObject state machine (the "brain")
  Digits.swift                Arbitrary-base signed integer digit string + arithmetic
  FloatingDigits.swift        Same, but evaluates itself as a Double
  Assets.xcassets/            App icon + accent color
AllYourBaseTests/             XCTest unit tests for Digits/FloatingDigits
text/                         Project notes (this file, CHANGELOG, TASKS, EXAMPLES)
```

## Requirements

- Xcode 15 or later
- iOS 16.0+ deployment target

## Building & running

Open `AllYourBase.xcodeproj` in Xcode, select the `AllYourBase` scheme, and
run. There's no storyboard/nib and no `Info.plist` file to edit - both the
launch screen and Info.plist are generated from build settings
(`GENERATE_INFOPLIST_FILE` / `INFOPLIST_KEY_*`) the way a modern Xcode
project template sets them up.

## Testing

Run the `AllYourBaseTests` target (`Cmd+U` in Xcode, or `xcodebuild test`).
It ports the original `DigitsTests`/`FloatingDigitsTests` suites to XCTest;
see `text/CHANGELOG.md` for the handful of tests that could not be ported
as-is (they exercised C-only undefined/implementation-defined behavior that
has no Swift equivalent) and what replaced them.

## How the app is put together

- `Digits` is a Swift `struct` holding a `base` and a `signedDigits` string
  (e.g. `"-1A.4"` in base 16), with `mutating` methods for the calculator
  keys (`pushDigit`, `popDigit`, `negate`) and throwing methods for the
  binary/unary operations (`plus`, `minus`, `times`, `divide`, `invert`,
  `power`). Arithmetic errors are a `DigitsError` enum instead of an
  `NSError **` out-parameter.
- `FloatingDigits` wraps a `Digits` and adds a `doubleValue` plus
  floating-point arithmetic. Nothing in the live calculator UI creates one
  today (same as in the original app - it only reachable from unit tests),
  but it's kept because it represents real, tested behavior.
- `AllYourBaseModel` is the calculator's state machine: current/previous
  operand, pending operation, and the two display strings. It's an
  `ObservableObject` with `@Published` properties instead of the original's
  KVO-observed `mainDisplay`/`secondaryDisplay`.
- `ContentView` hosts a base picker (BIN/OCT/DEC/HEX + "More..." for bases
  2-36) and one `AllYourBaseModel`: selecting a base re-renders the same
  in-progress calculation in the newly selected base. This replaces the
  original 35-tab TabView with a more compact single-view interface.
