# Examples

Small usage examples for the Swift types, for anyone extending the app or
reusing `Digits`/`FloatingDigits` elsewhere.

## `Digits`: arbitrary-base signed integers

```swift
// Base 10 by default.
var value = Digits()             // ""
value.pushDigit("4")
value.pushDigit("2")             // "42"
value.integerValue               // 42

// Any base from 2 to 62.
let hex = Digits(longLong: 46656, base: 16)!
hex.description                  // "B640"

// Round-trip through a different base.
let sameValue = Digits(longLong: hex.integerValue, base: 2)!
sameValue.description            // "1011011001000000"

// Arithmetic throws `DigitsError` instead of taking an NSError**.
let a = Digits(string: "10")
let b = Digits(string: "0")
do {
    _ = try a.divide(b)
} catch let error as DigitsError {
    print(error.errorDescription!) // "m ÷ 0 undefined"
}

// Mutating calculator-key style editing.
var entry = Digits(base: 16)!
entry.pushDigit("F")
entry.pushDigit("F")
entry.negate()
entry.description                // "-FF"
entry.popDigit()                 // "F" (the popped digit)
entry.description                // "-F"
```

## `FloatingDigits`: the same, evaluated as a `Double`

```swift
var x = FloatingDigits(base: 10)!
x.pushDigit("1")
x.pushDigit(".")
x.pushDigit("5")
x.doubleValue                    // 1.5

let y = FloatingDigits(string: "2")
let sum = try! x.plus(y)
sum.doubleValue                  // 3.5

// Unlike `Digits.power`, negative exponents are allowed (fractional results
// are representable as a Double).
let two = FloatingDigits(string: "2")
let minusOne = FloatingDigits(string: "-1")
try! two.power(minusOne).doubleValue  // 0.5
```

## `AllYourBaseModel`: driving the calculator programmatically

This is what `CalculatorView` does on each button tap; useful for writing
new tests or automating the calculator.

```swift
let model = AllYourBaseModel(base: 10)

model.digitPressed("6")
model.digitPressed("4")
model.binaryOperationPressed("+")
model.digitPressed("1")
model.digitPressed("2")
model.resultPressed()

model.mainDisplay                // "= 76"
model.currentDigits.integerValue // 76

// Switching base re-renders the same in-progress value.
model.setBase(16)
model.mainDisplay                // "= 4C"
```
