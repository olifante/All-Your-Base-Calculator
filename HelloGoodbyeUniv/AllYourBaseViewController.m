//
//  AllYourBaseViewController.m
//  AllYourBase
//
//  Created by Tiago Henriques on 3/26/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "AllYourBaseViewController.h"
#import "Digits.h"

const unichar plus = 0x002b;        // + PLUS SIGN
const unichar minus = 0x2212;       // − MINUS SIGN
const unichar times = 0x00d7;       // × MULTIPLICATION SIGN
const unichar divide = 0x00f7;      // ÷ DIVISION SIGN
const unichar power = 0x2191;       // ↑ UPWARDS ARROW
const unichar point = 0x2219;       // ∙ BULLET OPERATOR
const unichar negate = 0x2213;      // ∓ MINUS-OR-PLUS SIGN
const unichar negative = 0x002d;    // - HYPHEN-MINUS

static const NSInteger AllYourBaseDigitPadColumns = 5;

@implementation AllYourBaseViewController

# pragma mark initializers

- (instancetype)initWithModel:(AllYourBaseModel *)theModel
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.base = 10;
        self.model = theModel ?: [[AllYourBaseModel alloc] init];
    }
    return self;
}

# pragma mark release method

- (void)releaseMembers
{
    self.previousDisplayLabel = nil;
    self.currentDisplayLabel = nil;
    self.model = nil;
}

# pragma mark NSObject overridden methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ saw keypath %@", self, keyPath);
    [self updateLabels];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"base %02d controller", self.base];
}

# pragma mark UIViewController overridden methods

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor systemBackgroundColor];
    self.view = contentView;

    self.previousDisplayLabel = [self displayLabelWithFontSize:20 alpha:0.6];
    self.currentDisplayLabel = [self displayLabelWithFontSize:40 alpha:1.0];

    UIStackView *displayStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.previousDisplayLabel, self.currentDisplayLabel]];
    displayStack.axis = UILayoutConstraintAxisVertical;
    displayStack.alignment = UIStackViewAlignmentTrailing;
    displayStack.spacing = 4;

    UIStackView *buttonsGrid = [self buildButtonGrid];

    UIStackView *mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[displayStack, buttonsGrid]];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 16;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:mainStack];

    UILayoutGuide *safeArea = contentView.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:16],
        [mainStack.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:16],
        [mainStack.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-16],
        [mainStack.bottomAnchor constraintLessThanOrEqualToAnchor:safeArea.bottomAnchor constant:-16],
    ]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    int modelBase = self.model.base;
    int controllerBase = self.base;
    if (modelBase != controllerBase) {
        self.model.base = controllerBase;
    }

    for (NSString *name in @[@"mainDisplay", @"secondaryDisplay"]) {
        [self.model addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:nil];
    }

    [self updateLabels];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    for (NSString *name in @[@"mainDisplay", @"secondaryDisplay"]) {
        [self.model removeObserver:self forKeyPath:name];
    }
}

# pragma mark view construction

- (UILabel *)displayLabelWithFontSize:(CGFloat)fontSize alpha:(CGFloat)alpha
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont monospacedDigitSystemFontOfSize:fontSize weight:UIFontWeightRegular];
    label.textColor = [[UIColor labelColor] colorWithAlphaComponent:alpha];
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 1;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    return label;
}

- (UIButton *)calculatorButtonWithTitle:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    button.backgroundColor = [UIColor secondarySystemBackgroundColor];
    button.layer.cornerRadius = 8;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintGreaterThanOrEqualToConstant:44].active = YES;
    return button;
}

- (UIStackView *)rowStackWithButtons:(NSArray<UIView *> *)buttons
{
    UIStackView *rowStack = [[UIStackView alloc] initWithArrangedSubviews:buttons];
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    rowStack.distribution = UIStackViewDistributionFillEqually;
    rowStack.spacing = 8;
    return rowStack;
}

- (UIStackView *)buildButtonGrid
{
    UIStackView *utilityRow = [self rowStackWithButtons:@[
        [self calculatorButtonWithTitle:[self negateString] action:@selector(negatePressed)],
        [self calculatorButtonWithTitle:@"⌫" action:@selector(deletePressed)],
        [self calculatorButtonWithTitle:@"C" action:@selector(cleanPressed)],
    ]];

    NSMutableArray<UIButton *> *digitButtons = [NSMutableArray array];
    NSString *allowedDigits = [Digits allowedDigitsForBase:self.base];
    for (NSUInteger i = 0; i < allowedDigits.length; i++) {
        NSString *title = [NSString stringWithFormat:@"%C", [allowedDigits characterAtIndex:i]];
        [digitButtons addObject:[self calculatorButtonWithTitle:title action:@selector(digitPressed:)]];
    }
    [digitButtons addObject:[self calculatorButtonWithTitle:[self pointString] action:@selector(digitPressed:)]];

    UIStackView *digitPad = [[UIStackView alloc] init];
    digitPad.axis = UILayoutConstraintAxisVertical;
    digitPad.distribution = UIStackViewDistributionFillEqually;
    digitPad.spacing = 8;
    for (NSUInteger i = 0; i < digitButtons.count; i += AllYourBaseDigitPadColumns) {
        NSUInteger rowLength = MIN((NSUInteger)AllYourBaseDigitPadColumns, digitButtons.count - i);
        NSMutableArray<UIView *> *rowViews = [[digitButtons subarrayWithRange:NSMakeRange(i, rowLength)] mutableCopy];
        for (NSUInteger pad = rowLength; pad < AllYourBaseDigitPadColumns; pad++) {
            UIView *spacer = [[UIView alloc] init];
            spacer.userInteractionEnabled = NO;
            [rowViews addObject:spacer];
        }
        [digitPad addArrangedSubview:[self rowStackWithButtons:rowViews]];
    }

    UIStackView *operatorRow = [self rowStackWithButtons:@[
        [self calculatorButtonWithTitle:[self plusString] action:@selector(operationPressed:)],
        [self calculatorButtonWithTitle:[self minusString] action:@selector(operationPressed:)],
        [self calculatorButtonWithTitle:[self timesString] action:@selector(operationPressed:)],
        [self calculatorButtonWithTitle:[self divideString] action:@selector(operationPressed:)],
        [self calculatorButtonWithTitle:[self powerString] action:@selector(operationPressed:)],
        [self calculatorButtonWithTitle:@"=" action:@selector(resultPressed)],
    ]];

    UIStackView *rowsStack = [[UIStackView alloc] initWithArrangedSubviews:@[utilityRow, digitPad, operatorRow]];
    rowsStack.axis = UILayoutConstraintAxisVertical;
    rowsStack.distribution = UIStackViewDistributionFill;
    rowsStack.spacing = 8;
    return rowsStack;
}

# pragma mark instance methods

- (void)updateLabels
{
    NSString *secondaryText = self.model.secondaryDisplay;
    NSString *primaryText = self.model.mainDisplay;

    NSDictionary *operations = @{
        [NSString stringWithFormat:@"%C", plus]: @"+",
        [NSString stringWithFormat:@"%C", minus]: @"-",
        [NSString stringWithFormat:@"%C", times]: @"*",
        [NSString stringWithFormat:@"%C", divide]: @"/",
        [NSString stringWithFormat:@"%C", power]: @"^"
    };

    NSString *ASCIIOperation = @"";
    for (NSString *unicodeOperation in operations) {
        ASCIIOperation = operations[unicodeOperation];
        secondaryText = [secondaryText stringByReplacingOccurrencesOfString:ASCIIOperation withString:unicodeOperation];
        primaryText = [primaryText stringByReplacingOccurrencesOfString:ASCIIOperation withString:unicodeOperation];
    }
    self.previousDisplayLabel.text = secondaryText;
    self.currentDisplayLabel.text = primaryText;
}

# pragma mark actions

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.titleLabel.text;
    NSLog(@"%@ '%@' digit pressed", self, digit);
    if ([digit isEqualToString:[self pointString]]) {
        [self.model digitPressed:@"."];
    } else {
        [self.model digitPressed:digit];
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = sender.titleLabel.text;
    NSLog(@"%@ '%@' operation pressed", self, operation);
    if ([operation isEqualToString:[self plusString]]) {
        [self.model binaryOperationPressed:@"+"];
    } else if ([operation isEqualToString:[self minusString]]) {
        [self.model binaryOperationPressed:@"-"];
    } else if ([operation isEqualToString:[self timesString]]) {
        [self.model binaryOperationPressed:@"*"];
    } else if ([operation isEqualToString:[self divideString]]) {
        [self.model binaryOperationPressed:@"/"];
    } else if ([operation isEqualToString:[self powerString]]) {
        [self.model binaryOperationPressed:@"^"];
    } else {
        [self.model binaryOperationPressed:operation];
    }
}

- (IBAction)resultPressed
{
    NSLog(@"%@ '=' pressed", self);
    [self.model resultPressed];
}

- (IBAction)deletePressed
{
    NSLog(@"%@ delete pressed", self);
    [self.model deletePressed];
}

- (IBAction)cleanPressed
{
    NSLog(@"%@ clean pressed", self);
    [self.model cleanPressed];
}

- (IBAction)reciprocalPressed
{
    NSLog(@"%@ 'INV' pressed", self);
    [self.model binaryOperationPressed:@"^"];
    [self.model negatePressed];
    [self.model digitPressed:@"1"];
}

- (IBAction)negatePressed
{
    NSLog(@"%@ 'NEG' pressed", self);
    [self.model negatePressed];
}

- (IBAction)squareRootPressed
{
    NSLog(@"%@ 'SQRT' pressed", self);
    [self.model binaryOperationPressed:@"^"];
    [self.model digitPressed:@"."];
    [self.model digitPressed:@"5"];
    [self.model resultPressed];
}

- (IBAction)cubeRootPressed
{
    NSLog(@"%@ 'CBRT' pressed", self);
    [self.model binaryOperationPressed:@"^"];
    [self.model digitPressed:@"."];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model digitPressed:@"3"];
    [self.model resultPressed];
}

# pragma mark symbol accessor methods

- (NSString *)plusString { return [NSString stringWithFormat:@"%C", plus]; }
- (NSString *)minusString { return [NSString stringWithFormat:@"%C", minus]; }
- (NSString *)timesString { return [NSString stringWithFormat:@"%C", times]; }
- (NSString *)divideString { return [NSString stringWithFormat:@"%C", divide]; }
- (NSString *)powerString { return [NSString stringWithFormat:@"%C", power]; }
- (NSString *)negateString { return [NSString stringWithFormat:@"%C", negate]; }
- (NSString *)negativeString { return [NSString stringWithFormat:@"%C", negative]; }
- (NSString *)pointString { return [NSString stringWithFormat:@"%C", point]; }

@end
