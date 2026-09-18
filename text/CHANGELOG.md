# Changelog

## 2026-09-18 - Exact fraction division, working shift keys, backspace glyph, working inverse key

Five related changes, all from the same request:

### `Rational.swift`: exact division instead of truncating

`Digits.divide` did plain `Int64` division (`integerValue / divisor`),
truncating like C's `/` - `7 ÷ 2` showed `3`, silently dropping the
remainder. Added `Rational` (a reduced `numerator`/`denominator` pair,
denominator always positive, every operation overflow-checked the same way
`Digits`'s own `Int64` math already was) and rewired `plus`/`minus`/
`times`/`divide`/`invert`/`power` to compute through it instead of raw
`Int64`s. A plain typed integer's denominator is always `1`, so nothing
changes for an exact division (`24 ÷ 4` is still `6`); only the previously-
lossy remainder case is different - `7 ÷ 2` is now the exact `7:2`, and
`1/3` (via the new inverse key, below) is `1:3` instead of the old
truncated `0`.

**Notation decision:** a fraction result renders as `p:q` (colon), and the
codebase names this `Digits.rationalSeparator`, kept deliberately distinct
from **both** the ASCII `/` used internally as the division *operator*'s
token **and** the `÷` (`CalculatorSymbols.divide`) that operator is
prettified to for display. The reason: `CalculatorSymbols.prettify` does a
blind find-and-replace of `/` for `÷` across the *entire* display string
(operator token and any embedded value alike) - if a fraction's separator
were also `/`, an exact division *result* like `7/2` would prettify into
`7 ÷ 2`, rendering indistinguishably from a still-*pending* expression.
`:` isn't one of `prettify`'s substitution targets, so a fraction always
reads as a fraction, never as a half-finished division. `p/q` and `p ÷ q`
were both considered and rejected for exactly this collision; `:` is also
standard ratio notation, which a reduced numerator/denominator pair
literally is.

**Where a fraction can and can't appear:** only `divide`/`invert` results
ever have `denominator != 1` - typed digits are always plain integers, and
`changeBase` now converts via the new `rationalValue` (previously
`integerValue`, which would have silently dropped a shown fraction's
denominator when switching bases - fixed as part of this change, along
with the same bug in `resultPressed`'s "just re-display the current value"
branch). Because `popDigit`/`pushDigit` only ever edit a `Digits`'s
numerator digit string, letting them run on a shown fraction would silently
corrupt it (extend/trim the numerator while a stale denominator lingers
underneath) - `digitPressed` now also resets to a fresh value when
`currentDigits.denominator != 1` (not just when a "=" result is showing),
and `deletePressed` is blocked in the same case, exactly like it's already
blocked right after a shown "=".

### Shift keys (`≪`/`≫`) implemented for real

Always wired to a no-op in the original and in this rewrite until now.
Shift left multiplies the shown value by the current base (append a zero
digit); shift right is a **truncating** divide by the base (drop the last
digit) - deliberately lossy, unlike the exact `÷` operator, the same way a
real digit/bit shift is expected to discard whatever falls off the end
rather than preserve it as a remainder. Because of that, shift throws
rather than silently mangling a genuine fraction (`Digits.shiftedLeft`/
`shiftedRight` both require `denominator == 1`). Both edit `currentDigits`
in place rather than treating themselves as a fresh "=" result, so shifting
mid-entry of a pending operation's second operand doesn't disturb the
pending operation (e.g. `5 +`, then typing `3`, then shift left, gives
`5 + 30`).

### DEL glyph swapped for the standard backspace icon

`CalculatorSymbols.delete` was U+2421 SYMBOL FOR DELETE (`␡`) - a rare
glyph with poor font support that most people don't recognize. Swapped for
U+232B ERASE TO THE LEFT (`⌫`), the standard backspace/erase icon used on
Mac and iOS keyboards.

### Inverse ("1/x") key implemented

A new `.inverse` keypad key (plain text "1/x" - there's no single common
Unicode glyph for multiplicative inverse the way there is for the
arithmetic operators, so this matches how real calculators label the same
button) added to the editing row, wired to a new `CalculatorModel.
inversePressed()`. Deliberately kept separate from the existing
`reciprocalPressed()`, which stays exactly as it was: unreachable from any
shipped keypad and intentionally broken (builds "x ^ -1" via
`binaryOperationPressed`/`negatePressed`/`digitPressed`, which throws
`Digits.negativePowerErrorMessage` since `power()` still rejects negative
exponents) - preserved for fidelity to the original app, not "fixed" as
part of this change. `inversePressed()` instead calls `Digits.invert()`
directly, exact via `Rational`, and edits `currentDigits` in place the same
way the shift keys do.

### Tests

Added `RationalTests.swift` (construction/reduction/sign-normalization,
each arithmetic operator's overflow case, `inverse()`, `power()`,
`description(inBase:)`), and extended `DigitsTests.swift` and
`CalculatorModelTests.swift` with exact-fraction division/inversion,
reduction, negative-fraction signing, the `Int64.min ÷ -1` overflow edge
case, shift (including the fraction-throws case), inverse, and the new
delete-blocked/digit-resets-fresh guards around a shown fraction.

## 2026-09-17 20:05 UTC - Wrote Unicode glyphs literally instead of as `\u{}` escapes

`CalculatorSymbols.swift` and `Digits.swift` spelled every non-ASCII
character as a `"\u{XXXX}"` escape (e.g. `"\u{00f7}"` for ÷), each with a
trailing comment naming the actual glyph since the escape itself gave no
visual clue. Replaced every one with the literal character (`"÷"`), with a
`// U+00F7 DIVISION SIGN`-style comment kept alongside for the ones that
look similar to their ASCII counterparts or to each other (e.g. `−` U+2212
vs `-` U+002D, `∙` U+2219 vs `.`). Purely cosmetic - same string values,
same behavior, just readable directly in the editor instead of requiring a
codepoint lookup.

## 2026-09-17 19:50 UTC - Switched base selection from a TabView to a Picker

The original app (and this rewrite, until now) put one base per
`UITabBarController` tab. On iPad that's 37 tabs (bases 2...36 plus
"Base 10*"); iOS only shows the first 5 in the tab bar itself and shoves
everything else into a "More" list, which is a poor way to pick a base out
of three dozen options. Replaced it with a single calculator screen and a
`Picker` above it (`.pickerStyle(.menu)`, a tappable dropdown) that selects
the base instead - the same one shared `CalculatorModel` still backs every
selection, so switching bases still preserves the current value exactly
like the tab bar did.

### Changed
- `AllYourBaseApp.ContentView`: `TabView` -> `VStack` with a `Picker` bound
  to `@State private var selectedBase`, followed by a single
  `CalculatorScreenView`. `0` remains the sentinel for the classic
  "Base 10*" layout, same as the removed tab's `.tag(0)`.
- `CalculatorScreenView`: since the screen is now one reused view instance
  across every base (rather than one `TabView` child per base, each with
  its own `.onAppear`), `model.changeBase(to:)` is now called from
  `.onChange(of: base, initial: true)` instead of `.onAppear` - `initial:
  true` covers the first display the same way `.onAppear` used to, and the
  ongoing part is what makes switching the picker actually re-express the
  displayed value in the new base.
- Updated stale "tab"/"TabView" wording in comments and `text/README.md`/
  `text/EXAMPLES.md` that described the now-removed tab bar; historical
  CHANGELOG entries above describing the tab-based UI as it existed at the
  time are left as-is.

## 2026-09-17 19:30 UTC - Fixed a real exactness bug found while auditing for reinvented-wheel code

Asked to check whether `Digits.swift`'s integer math (kept deliberately
free of floating point, for exactness) had reinvented anything the standard
library already provides, and whether a built-in rational-number type
exists. It doesn't (no `Rational`/`Fraction` in the stdlib or Foundation;
`NSDecimalNumber` is base-10 decimal only). The audit did turn up:

- `power()`'s **integer** branch (not the dormant `allowsPoint`/
  `FloatingDigits` one) computed its result via
  `pow(Double(a), Double(b))`. `Double` only has 53 bits of mantissa
  (exact up to ~9x10^15); `Int64` goes up to ~9.2x10^18. Verified
  concretely: `7^19` is exactly `11398895185373143`, but
  `pow(7.0, 19.0)` rounds to `11398895185373144` - one too high, with no
  overflow to signal anything went wrong. This is a real, silent
  correctness bug for any power result in that gap.
- `convertInteger(_:toBase:)` reimplemented what
  `String(_:radix:uppercase:)` already does for bases 2...36 (every base
  this app's UI actually offers), and its reimplementation used
  `log`/`pow`/`ceil`/`floor` internally to size the digit extraction loop -
  floating point hiding inside code whose entire point was to avoid it.

### Fixed
- `Digits.power`: replaced the `pow`-based computation and the
  `log`-based `exponentiationIsSafe` overflow heuristic with a single
  `checkedPower(_:_:)` helper doing exact integer exponentiation by
  squaring, using the same `multipliedReportingOverflow` idiom already
  used by `plus`/`minus`/`times`. Exact by construction, and overflow is
  now detected as a side effect of the real multiplication instead of a
  separate `log`-based estimate.
- `Digits.convertInteger`: now delegates to `String(_:radix:uppercase:)`
  for bases 2...36 (all of them, in practice). Bases 37...62 - reachable
  only via `allDigits`'s lowercase extension, not by anything the shipped
  UI requests - fall back to a plain repeated-division loop instead of the
  old `log`/`pow`-based place-value extraction. No floating point remains
  anywhere in the integer conversion path.
- Removed `Digits.log(_:base:)`, which only existed to support the deleted
  `log`/`pow`-based logic above and had no other callers.
- Added `DigitsTests` coverage: `testPowerExactPastDoublePrecision` (the
  `7^19` case above), `testPowerOverflowThrows` (confirms overflow
  detection still works without the old heuristic), and
  `testConvertAboveStdlibRadixLimitUsesLowercaseDigits` (exercises the new
  base 37...62 fallback, e.g. `37` in base `40` prints as `"b"`).

Separately, the author pointed out a better long-term design for the
dormant decimal-point (`allowsPoint`) path than either floating point or an
infinite digit expansion: keep values as a reduced numerator/denominator
pair and print each integer in the current base, rather than trying to
expand a fraction into a single base-B digit string (impossible to do
exactly for e.g. `1/3` in any base without repeating-digit notation). Not
implemented - that code path isn't reachable from any keypad the app
actually ships - but recorded as a scoped follow-up in `text/TASKS.md`
rather than lost.

## 2026-09-17 19:05 UTC - Re-checked the hover-NaN issue against a fresh backtrace; no code change

The user reported another console paste showing the same class of NaN
pointer-hover backtraces (with a slightly different intermediate frame,
`_applyPointerStyle:forRegion:animator:`) in the current, already-reverted
state. That's expected, not a regression: reverting the 18:36 UTC commit
only removed a non-compiling attempted fix, it didn't change behavior back
to something better or worse than before this whole investigation started.

Went back over the 18:28 UTC `.hoverEffectDisabled()` commit (`bdf4398`) to
double check it wasn't simply applied at the wrong call site (e.g. on the
label instead of the `Button`) - it wasn't; it was already on the outermost
`Button`, after `.buttonStyle(...)`, which is the architecturally correct
place. That rules out "wrong placement" as the explanation for why it had no
effect, and points at something below SwiftUI's `hoverEffect` API surface
entirely - most likely the `UIPointerInteraction` UIKit adds automatically
to button-like controls whenever a pointer (Simulator mouse/trackpad, or a
real trackpad on a real iPad) is present, which isn't something
`.hoverEffect`/`.hoverEffectDisabled()` were ever meant to touch.

No code changed. Documented the re-check and a concrete, low-risk next step
(toggle the Simulator's pointer-input setting off and see if the spam
disappears, which would confirm this is Simulator-mouse-testing-only noise)
in `text/TASKS.md` instead of guessing a third SwiftUI modifier from memory.

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
