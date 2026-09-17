# Examples

## Switching bases without losing your value

This is the app's core trick, preserved from the original: every tab shares
one `CalculatorModel`, and selecting a tab calls `changeBase(to:)`, which
re-expresses the current/previous operands in the new base instead of
resetting them.

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
let keys = KeypadLayout.sequentialKeys(forBase: 16)
// [clear, delete, negate, shiftLeft, shiftRight, point,
//  0, 1, 2, ..., 9, A, B, C, D, E, F,
//  +, -, *, /, ^, =]

CalculatorKeypadView(keys: keys, columns: 6) { key in
    // dispatch key.action to a CalculatorModel, see CalculatorScreenView.swift
}
```

This one call (base 2 through 36) replaces what the original expressed as a
separate hand-built `.xib` nib per base.

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
