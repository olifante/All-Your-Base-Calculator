# Changelog

## 2026-09-17 02:17 UTC — Convert project to Swift + SwiftUI

Full rewrite of the app from Objective-C/UIKit to Swift/SwiftUI. The
calculator's behavior is preserved; the UI is rebuilt declaratively.

### Added

- `AllYourBase/Digits.swift` — Swift port of `Digits`, as a `struct` with
  `mutating` methods (`pushDigit`, `popDigit`, `negate`) and `throws`
  arithmetic (`plus`, `minus`, `times`, `divide`, `invert`, `power`)
  instead of an `NSError **` out-parameter.
- `AllYourBase/FloatingDigits.swift` — Swift port of `FloatingDigits`, now
  implemented by wrapping a `Digits` (composition) instead of subclassing
  it, since Swift structs can't inherit.
- `AllYourBase/AllYourBaseModel.swift` — Swift port of `AllYourBaseModel`
  as an `ObservableObject` with `@Published` properties, replacing the
  original's KVO on `mainDisplay`/`secondaryDisplay`.
- `AllYourBase/AllYourBaseApp.swift`, `ContentView.swift`,
  `CalculatorView.swift` — SwiftUI app entry point, tab container, and
  calculator screen, replacing `main.m`, `AllYourBaseAppDelegate` (+ its
  iPhone/iPad subclasses), `AllYourBaseSceneDelegate`, and
  `AllYourBaseViewController` (+ its iPhone/iPad subclasses).
- `AllYourBase/Assets.xcassets` — app icon (from the old `iTunesArtwork.png`,
  512×512; should be replaced with a real 1024×1024 icon at some point) and
  an accent color placeholder.
- `AllYourBaseTests/DigitsTests.swift`, `FloatingDigitsTests.swift` — XCTest
  ports of the SenTestingKit `DigitsTests`/`FloatingDigitsTests` suites.
- `AllYourBase.xcodeproj` regenerated from scratch (via the `xcodeproj` Ruby
  gem, to get well-formed UUIDs/build phases) with two targets:
  `AllYourBase` (app) and `AllYourBaseTests` (XCTest, hosted in the app so
  `@testable import AllYourBase` works, same convention the original
  `LogicTests` target used with `TEST_HOST`/`BUNDLE_LOADER`). iOS 16.0
  deployment target; `Info.plist` is generated from build settings
  (`GENERATE_INFOPLIST_FILE`, `INFOPLIST_KEY_*`) instead of a checked-in
  file, matching current Xcode project templates.

### Removed

- All Objective-C sources (`HelloGoodbyeUniv/`, `LogicTests/`), the old
  `AllYourBase-Info.plist`/`AllYourBase-Prefix.pch`/`LogicTests-*`, the
  per-idiom launch images, and the xcuserdata/workspace state tied to the
  old target names.
- `RationalDigits.h/.m` — a stub (`initWithNumerator:denominator:` always
  returned `nil`) that was never instantiated anywhere and had no tests.
- `gcd.c/.h`, `itoa.c/.h` — plain C utility functions never called from any
  Objective-C file.
- `NKString.h/.m` (`isEmptyNK`/`isNotEmptyNK` on `NSString`) — never called.
- `CalcBrain.xcdatamodeld` — an empty Core Data model never referenced by
  any code.
- `AllYourBaseModel.shiftLeftPressed`/`shiftRightPressed`/`percentPressed`/
  `EEPressed` — empty method bodies, not wired to any control.
- `AllYourBaseViewController.squareRootPressed`/`cubeRootPressed`/
  `reciprocalPressed` — `IBAction`s left over from a pre-programmatic-layout
  UI; the current button grid (built in the "Use programmatic layout
  instead of nibs" commit) never wires them up, so they were already
  unreachable dead code before this conversion.
- The duplicate "Base 10\*" tab (`AllYourBaseViewController` initialized
  with `base == 0`): it behaved identically to the regular "Base 10" tab in
  every way except its tab title, so it added a tab without adding any
  function.
- `Digits`' `pointString`/`negativeString` class accessors and the
  `parseDigits(fromBase:)` static method on `Digits`/`FloatingDigits`/
  `RationalDigits` — dead API, never called from the app or the tests
  (`AllYourBaseViewController` had its own separate, actually-used point/
  negative symbol constants).
- `Digits.isZero(_:)` — dead API, never called.
- `AllYourBaseAppDelegate_iPhone`/`_iPad` and
  `AllYourBaseViewController_iPhone`/`_iPad` — superseded by a single
  SwiftUI target; see "Behavior notes" below for how their base lists were
  unified.

### Fixed

- **Base upper bound**: `Digits` clamped bases to 2...100, but the digit
  alphabet string (`"0...9A...Za...z"`) is only 62 characters long, so any
  base above 62 would have read past the end of that string. Capped at 62
  (`Digits.maxBase`).
- **Bases above 36 in `integerValue`**: the original used `strtoll`, which
  only understands bases 2...36 and can't tell the uppercase and lowercase
  halves of the 37...62 alphabet apart. The Swift port parses against the
  base's own alphabet directly, so round-tripping through bases up to 62
  now works both ways.
- **`Digits.power` overflow check**: the original approximated safety with
  `db * log(da) < log(LLONG_MAX)`, which is razor-thin (and wrong, in
  `double` precision) exactly at powers of two on the `Int64` boundary —
  e.g. `2 ^ 63` could pass the check and then overflow `(long long)pow(...)`
  as undefined behavior. The Swift port checks the actual computed result
  with `Int64(exactly:)`, which cannot silently produce a wrapped value.
- **`FloatingDigits.convertDouble` and non-decimal bases**: the original
  always formatted the fractional part with `%f` (base 10 only)
  regardless of the requested base, so e.g. converting a non-integer
  double to base 16 would produce base-10 digits after the point. Never
  exercised by any test, since all of them used integer values for
  non-decimal bases. The Swift port converts the fractional part into the
  requested base; base-10 output is untouched (still produced with the
  same `%f`-based formatting as before, byte for byte).
- **`Digits`'s own "."-handling regression**: `Digits.m`'s initializer had
  a commented-out line that would have included `"."` in the base class's
  own allowed-characters set (`//...stringByAppendingString:@"."`); as
  actually shipped, only `FloatingDigits` added it. But `DigitsTests.m`
  (for the plain, non-floating `Digits` class) has many passing-looking
  tests that push `"."` and expect it to be accepted (`testPushPoint`,
  `testPush0Point1`, `testNegatePushPoint`, etc.) — which the shipped code
  would actually have failed, since `pushDigit(".")` is rejected before it
  reaches the `"."`-specific branches whenever `"."` isn't an allowed
  character. This conversion restores the commented-out behavior (`Digits`
  accepts `"."` the same way `FloatingDigits` always did) so the ported
  code matches its own ported tests.

### Behavior notes (things that changed on purpose)

- **Nil-parameter defensive checks are gone.** Several ObjC methods took a
  possibly-`nil` `Digits *`/`NSString *` and returned `nil` at runtime if
  so (`plus:withError:` when the operand was `nil`, `initWithString:` when
  the string was `nil`, etc.). Swift's `Digits`/`FloatingDigits` take
  non-optional `Digits`/`String` parameters, so those cases are now
  compile errors instead of runtime nil-checks — a stronger guarantee.
  The corresponding `test*Nil` unit tests have no Swift equivalent and were
  dropped (see `AllYourBaseTests/DigitsTests.swift`'s header comment).
- **`Digits.power` no longer wraps on overflow; it throws.** Two legacy
  tests (`testInitWithString2Power63`, `testInitWithString2Power62Times2`)
  expected `2 ^ 63` (and `2^62 * 2`) to silently succeed with a wrapped
  `Int64.min`-shaped result, relying on undefined behavior in the C cast
  from an out-of-range `double` to `long long`. These now correctly throw
  an overflow error and were dropped; `2 ^ 62` and `2^61 * 2` (both in
  range) are still tested and still succeed.
- **One pair of `long long` boundary tests was dropped as internally
  contradictory.** `testInitWithIntegral0x8000000000000000LL` expected a
  *positive* `9223372036854775808`, while
  `testInitWithIntegralNegative0x8000000000000000LL` expected the
  mathematically negated (and distinct) *negative* `Int64.min` — but by
  the C standard's own integer-literal-promotion and conversion rules,
  `0x8000000000000000LL` and `-0x8000000000000000LL` both evaluate to the
  exact same bit pattern (`LLONG_MIN`) once passed through
  `initWithLongLong:`, since `0x8000000000000000` doesn't fit in a signed
  `long long` and gets promoted to `unsigned long long` first. Swift has no
  such implicit promotion (integer literals are exact and typed
  explicitly), so there's no equivalent "positive" case to port; only the
  unambiguous `Int64.min` test was kept.
- **`convertInteger` tests that passed a `Double` to truncate it were
  dropped.** A handful of tests (`testConvert0Point1ToBase10` and
  siblings) passed a `double` literal like `0.1` to a C function expecting
  `long long int`, relying on implicit truncation to test that
  `convertInteger` only ever sees integers. `Digits.convertInteger` takes
  an `Int64`, so passing a `Double` is a compile error — again a stronger
  guarantee than the runtime behavior it replaces.
- **iPhone and iPad now share one base list.** The original had two
  separate app delegates picking between an iPhone list (bases 2...16,
  favorites 10/6/7/12 first) and a fuller iPad list (bases 2...36,
  favorites 10/6/7/9/16/25/36 first), purely because they were different
  targets/classes. There's now a single SwiftUI target, so `ContentView`
  uses the fuller iPad list on every device; SwiftUI's `TabView` already
  collapses overflow tabs into a "More" tab on compact size classes, so
  this doesn't cost anything on iPhone.
