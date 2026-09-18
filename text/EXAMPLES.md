# Examples

## Switching bases without losing your value

This is the app's core trick, preserved from the original: every base
selection shares one `CalculatorModel`, and picking a new base calls
`changeBase(to:)`, which re-expresses the current/previous operands in the
new base instead of resetting them.

```swift
let model = CalculatorModel(base: 10)
model.digitPressed("2")
model.digitPressed("5")
model.digitPressed("5")
model.mainDisplay // "255"

model.changeBase(to: 16)
model.mainDisplay // "FF"

model.changeBase(to: 2)
model.mainDisplay // "11111111"
```

## A chained calculation

```swift
let model = CalculatorModel()
model.digitPressed("2")
model.binaryOperationPressed("+")
model.digitPressed("3")
model.binaryOperationPressed("*") // (2 + 3) becomes the running previous operand
model.digitPressed("4")
model.resultPressed()
model.mainDisplay // "= 20"
```

Note the "= " prefix: it appears whenever `previousOperation` is set (i.e.
right after any computed result), exactly matching the original's
`self.previousOperation ? @"= " : @""` in `updateMainDisplay`.

## Building a keypad for an arbitrary base

```swift
let editing = KeypadLayout.editingKeys()          // clear, delete, negate, shiftLeft, shiftRight, inverse
let digits = KeypadLayout.digitKeys(forBase: 16)  // point, 0, 1, ..., 9, A, B, C, D, E, F
let operations = KeypadLayout.operationKeys()     // +, -, *, /, ^, =

CalculatorKeypadView(
    layout: .grouped(editing: editing, digits: digits, operations: operations, digitColumns: 6),
    onKeyTap: { key in
        // dispatch key.action to a CalculatorModel, see CalculatorScreenView.swift
    }
)
```

These three calls (any base 2 through 36) replace what the original
expressed as a separate hand-built `.xib` nib per base.

## Error handling

```swift
let model = CalculatorModel()
model.digitPressed("1")
model.binaryOperationPressed("/")
model.digitPressed("0")
model.resultPressed()
model.secondaryDisplay // "m ÷ 0 undefined" (Digits.divideErrorMessage)

model.deletePressed() // clears the error, pops a digit
model.secondaryDisplay // ""
```

## Digits arithmetic directly

```swift
let a = Digits(string: "24", base: 10)!
let b = Digits(string: "4", base: 10)!
let c = Digits(string: "-3", base: 10)!
try a.divide(b)?.divide(c)?.integerValue // -2

let overflowing = Digits(longLong: Int64.max)
try overflowing.plus(Digits(longLong: 1)) // throws DigitsError("addition overflow")
```

## Exact fraction division and inversion

Division no longer truncates like `Int64`'s `/` - a division that doesn't
come out even returns an exact, reduced fraction instead of losing the
remainder. `:` (not `/` or `÷`) separates numerator from denominator, kept
deliberately distinct from the division operator's own glyphs - see
`Digits.rationalSeparator` and `text/CHANGELOG.md`'s 2026-09-18 entry for
why.

```swift
let model = CalculatorModel()
model.digitPressed("7")
model.binaryOperationPressed("/")
model.digitPressed("2")
model.resultPressed()
model.mainDisplay // "= 7:2" - not the old truncated "= 3"

model.changeBase(to: 2)
model.mainDisplay // "= 111:10" - both 7 and 2 re-rendered in base 2

let three = Digits(string: "3", base: 10)!
try three.invert()?.description // "1:3" - not the old truncated "0"
```

Shift left/right (`≪`/`≫`) are the opposite: they're deliberately
truncating, the same way a real digit/bit shift is, so they throw rather
than silently discarding a shown fraction's denominator:

```swift
model.digitPressed("5")
model.shiftLeftPressed()
model.mainDisplay // "50" (5 * base)

let sevenHalves = try Digits(string: "7", base: 10)!.divide(Digits(string: "2", base: 10)!)
try sevenHalves?.shiftedLeft() // throws DigitsError("shift undefined for a fraction")
```
