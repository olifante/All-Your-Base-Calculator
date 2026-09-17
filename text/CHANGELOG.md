# Changelog

## 2026-09-17 18:47 UTC - Revert the broken hover-effect fix; build restored, issue left open

`.hoverEffect(.none)` from the 18:36 UTC commit does not compile -
`HoverEffect` has no `.none` case. That was a second wrong guess at the API
(the first, `.hoverEffectDisabled()`, compiled but was verified not to
actually stop the effect). Rather than guess a third time, removed the
non-functional modifier entirely and left a clear NOTE comment in
`CalculatorKeypadView.keyButton` documenting what's confirmed (the NaN is
UIKit's own pointer hover-effect system, `_UIPointerEffectPlatterView`,
nothing in this app's code) and what's been ruled out, so this doesn't get
re-investigated from scratch. The build compiles again; the underlying NaN
console spam from hovering the Simulator's pointer over a keypad button is
**unresolved** - see `text/TASKS.md`.

## 2026-09-17 18:36 UTC - Correct the hover-effect fix: wrong API the first time

The 18:28 UTC fix (`.hoverEffectDisabled()`) did not work - a second
backtrace capture came back byte-for-byte identical, proving that modifier
never touched the actual codepath. Root cause of *that*: `.hoverEffectDisabled()`
only cancels a hover effect requested via an explicit `.hoverEffect()` call;
it does not stop the automatic system pointer interaction that `Button`
gets on iPadOS regardless of `ButtonStyle`, which is what's actually
installing the buggy `_UIPointerEffectPlatterView`.

### Fixed
- `CalculatorKeypadView.keyButton`: replaced `.hoverEffectDisabled()` with
  `.hoverEffect(.none)` - the actual, long-standing (iOS 13.4+) API for
  opting a view out of the automatic pointer hover interaction entirely.

## 2026-09-17 18:28 UTC - Actually root-caused the NaN spam via a real backtrace

The 18:08 UTC fix reduced but didn't eliminate the console spam. Rather than
guess a third time, asked for a `CG_NUMERICS_SHOW_BACKTRACE=1` capture, which
gave a real, conclusive answer: the NaN is computed entirely inside **UIKit's
own pointer hover-effect system**
(`_UIPointerEffectPlatterView`/`_UIPointerContentEffect`/`UIPointerInteraction`,
via `_UIPointerInteractionHoverDriver`) - the iPadOS-Simulator-only feature
that draws a "platter" highlight under the mouse cursor when hovering over an
interactive element. None of this app's own view code appears anywhere in
that backtrace; UIKit's rounded-rect bezier math for that platter shape goes
NaN on its own for these buttons.

### Fixed
- `CalculatorKeypadView.keyButton`: added `.hoverEffectDisabled()` to every
  keypad button, opting them out of the system hover-effect computation
  entirely (the pressed-state highlight is already drawn ourselves in
  `CalculatorKeyStyle`, so nothing is lost). This sidesteps the buggy UIKit
  codepath directly instead of guessing at which button size/corner-radius
  combination trips it up.

## 2026-09-17 18:08 UTC - Fix NaN/CoreGraphics console flood from the layout fix

The 17:57 UTC layout fix introduced a real bug of its own: running the app
produced a sustained flood of `Error: ... has passed an invalid numeric value
(NaN...)` and `cannot add handler to N from N - dropping` console spam,
alongside one diagnostic line that gave it away: `Conversion error! {{0, 820},
{1180, 0}} was converted to {{-89.08...}, {1480.64...}}` - a rect with **zero
height** being fed through a transform.

Root cause: `CalculatorScreenView` fed `GeometryReader`'s `proxy.size`
directly into a hard `.frame(width:height:)`, and `GeometryReader` can
genuinely report a transient zero (or otherwise degenerate) height for a
frame or two during a tab-switch/rotation animation. That zero got baked
into the frame, and the digit grid underneath - which had its own
`.frame(maxHeight: .infinity)` - then divided remaining space by it while
computing flexible row heights, producing NaN geometry that kept
re-triggering the same error on every subsequent frame.

### Fixed
- `CalculatorScreenView`: replaced `.frame(width: proxy.size.width, height:
  proxy.size.height, ...)` with `.frame(maxWidth: .infinity, maxHeight:
  .infinity, alignment: .top)`. `proxy.size` is now read *only* to choose a
  column count for the digit grid, never plugged into a literal frame size.
- `CalculatorKeypadView`: removed `.frame(maxHeight: .infinity)` from the
  digit grid and the extra `.frame(maxHeight: .infinity)` on each button;
  added a trailing `Spacer(minLength: 0)` after the operators row instead,
  which absorbs leftover vertical space without ever factoring into the
  grid's own row-height math.

## 2026-09-17 17:57 UTC - Keypad layout/sizing fixes after first real build

The user got the rewrite building and running in real Xcode (with a few
local fixes on their end) and reported the keypad looked bad on-device: tiny
buttons clustered in the top-left of the screen with a large unused blank
area below/right, and a broken/tofu glyph for the negate (±) key.

### Fixed
- **Root layout bug**: `CalculatorScreenView`'s `GeometryReader` content was
  a plain `VStack` with no explicit frame, so it hugged its own content size
  and sat top-leading instead of filling the tab's actual screen area -
  that's what produced the large empty area. Now given an explicit
  `.frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)`.
- **Root button-sizing bug**: each keypad button used
  `.frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit)`, which (with
  no height constraint from its `LazyVGrid` cell) collapsed to a small square
  hugging the leading edge of its grid column instead of filling it. Replaced
  with an explicit `.frame(maxWidth: .infinity, minHeight: 64)`, which is
  also what makes the buttons meaningfully bigger as asked.
- **Missing glyph**: the negate key's `∓` (U+2213) rendered as a tofu/box
  glyph on-device because the `"Courier"` font the buttons/display used
  doesn't include it. Switched every button and display label from
  `.custom("Courier", size:)` to `.system(size:, design: .monospaced)`,
  which has full coverage of the symbols this app uses.
- A `CGFloat`/`Double` type mismatch passing `proxy.size.width` into
  `KeypadLayout.sequentialColumnCount(forWidth:)` (this was likely one of
  the "few local fixes" already made on the user's machine; fixed again here
  since the surrounding code was rewritten anyway).

### Changed (requested: separate rows for editing / digits / operations)
- `KeypadLayout.sequentialKeys(forBase:)` (one flat interleaved list) split
  into three functions - `editingKeys()`, `digitKeys(forBase:)` (now
  including the decimal point), `operationKeys()` - each rendered as its own
  visually distinct row/section by `CalculatorKeypadView`, instead of one
  long grid where control/digit/operator keys landed in whatever row the
  column count happened to wrap them into.
- `CalculatorKeypadView` reworked around a `Layout` enum: `.grouped(editing:
  digits:operations:digitColumns:)` for the per-base tabs (editing controls
  as one row, the digit grid wrapping into as many rows as needed, operators
  as a final row), and `.flat(keys:columns:)` preserving the classic "Base
  10*" tab's deliberately-interleaved phone-calculator grid unchanged.

### Also fixed while in the area (not requested, but a real gap)
- The original app's view controller (`updateLabels` in
  `AllYourBaseViewController.m`) translated the model's plain-ASCII operator
  tokens (`+ - * / ^`) into the pretty Unicode symbols (`+ − × ÷ ↑`) before
  ever showing them on screen. That view-layer step was never ported in the
  first pass, so the display was silently showing raw ASCII operators.
  Added `CalculatorSymbols.prettify(_:)` (applied in `CalculatorDisplayView`)
  to restore this - including the original's quirk that a negative number's
  "-" sign gets the same prettifying treatment as the subtraction operator,
  since both are blindly string-replaced the same way in the original too.

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
