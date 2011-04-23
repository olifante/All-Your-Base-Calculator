//
//  Digits.m
//  AllYourBase
//
//  Created by Tiago Henriques on 4/4/11.
//  Copyright 2011 notknot. All rights reserved.
//

#import "Digits.h"

static NSString *allDigits = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
//static NSString *hexaVigesimal = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"; // 'A' == 0, 'Z' == 25
//static NSString *base64 = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; // 'A' == 0, '/' == 63
//static NSString *base64url = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"; // 'A' == 0, '_' == 63
//static NSString *base32 = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"; // 'A' == 0, '7' == 31 (RFC 4648)
//static NSString *base36 = @"abcdefghijklmnopqrstuvwxyz0123456789/"; // 'a' == 0, '9' == 35
//static NSString *crockfordBase32 = @"0123456789ABCDEFGHJKMNPQRSTVWXYZ"; // 'Z' == 31, I, L, O and U excluded

const char *divideErrorMessage = "m \xc3\xb7 0 undefined"; // UTF8 sequence for 0x00f7 ÷ DIVISION SIGN is \xc3\xb7
const char *invertErrorMessage = "1 \xc3\xb7 0 undefined";
const char *zeroPowerOfZeroErrorMessage = "0 ^ 0 undefined";
const char *negativePowerOfZeroErrorMessage = "0 ^ -m undefined";
const char *fractionalPowerOfNegativeErrorMessage = "-m ^ 1/n undefined";

const unichar negativeChar = 0x002d; // - HYPHEN-MINUS
//const unichar negativeChar = 0xfe63; // ﹣ SMALL HYPHEN-MINUS
//const unichar negativeChar = 0x02d7; // ˗ MODIFIER LETTER MINUS SIGN
const unichar pointChar = 0x2027; // ‧ HYPHENATION POINT
//const unichar pointChar = 0x2219; // ∙ BULLET OPERATOR

@implementation Digits

@synthesize base;
@synthesize signedDigits, allowedDigits;
@synthesize allowedDigitSet, forbiddenDigitSet;
@synthesize digitValues;

# pragma mark overridden methods

- (void)dealloc
{
    self.signedDigits = nil;
    self.allowedDigits = nil;
    self.allowedDigitSet = nil;
    self.forbiddenDigitSet = nil;
    self.digitValues = nil;
    [super dealloc];
}

- (NSString *)description
{
    NSString *negativePrefix = @"";
    NSString *zeroPrefix = @"";
    NSString *result;
    
    if (self.startsWithMinus) {
        zeroPrefix = @"-";
    }
    
    if (self.startsWithPoint) {
        zeroPrefix = @"0";
    }
    
    if (!self.signedDigits) {
        result = @"";
    } else
    if ([self.signedDigits isEqualToString:@""]) {
        result = @"0";
    } else
    if ([self.signedDigits isEqualToString:@"-"]) {
        result = @"-";
    } else 
    {        
        result = [NSString stringWithFormat:@"%@%@%@"
                  , negativePrefix
                  , zeroPrefix
                  , self.unsignedDigits ? self.unsignedDigits : @""
                  ];
    }
    
    return result;
}

- (id)init
{
    self = [self initWithString:@"" base:10];    
    return self;
}

# pragma mark initializers

- (id)initWithLongLong:(long long int)someInt base:(int)someBase
{
    NSString *someDigits = [Digits convertInteger:someInt toBase:someBase];
    self = [self initWithString:someDigits base:someBase];
    return self;
}

- (id)initWithLongLong:(long long int)someInt
{
    self = [self initWithLongLong:someInt base:10];
    return self;
}

- (id)initWithString:(NSString *)someString base:(int)someBase
{
    if (!someString) {
        NSLog(@"someString must not be nil");
        return nil; // early return because it's useless to invoke [super init]
    }
    
    if (!someBase || (someBase < 2) || (someBase > 100)) {
        NSLog(@"only bases from 2 to 100 are supported");
        return nil; // early return because it's useless to invoke [super init]
    }
    
    self = [super init];
    if (self) {
        self.base = someBase;
        
        self.allowedDigits = [[allDigits substringToIndex:someBase] stringByAppendingString:@"."];
        self.allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:self.allowedDigits];
        self.forbiddenDigitSet = [self.allowedDigitSet invertedSet];
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        for (int i = 0; i < someBase; i++) {
            NSString *digit = [NSString stringWithFormat:@"%C", [self.allowedDigits characterAtIndex:i]];
            [dict setObject:[NSNumber numberWithInt:i] forKey:digit]; 
        }
        self.digitValues = [NSDictionary dictionaryWithDictionary:dict];
        
        NSScanner *scanner = [NSScanner scannerWithString:someString];        
        
        [scanner scanString:@" " intoString:NULL];
        
        NSString *negativePrefix = @"";
        if ([scanner scanString:@"-" intoString:NULL]) {
            negativePrefix = @"-";
            [scanner scanString:@" " intoString:NULL];
        }
        
        NSString *someSignedDigits = nil;
        if ([scanner scanUpToCharactersFromSet:self.forbiddenDigitSet intoString:&someSignedDigits]) {
            self.signedDigits = [negativePrefix stringByAppendingString:someSignedDigits];
        }
    }
    return self;
}

- (id)initWithString:(NSString *)someString
{
    self = [self initWithString:someString base:10];
    return self;
}

# pragma mark computed readonly properties

- (long long int)integerValue
{
    if (self.signedDigits) {
        const char *char_string = [self.signedDigits UTF8String];
        return strtoll(char_string, NULL, self.base);       
    } else
    {
        return 0LL;
    }
}

- (NSNumber *)value
{
    return [NSNumber numberWithLongLong:[self integerValue]];    
}

- (NSString *)unsignedDigits
{
    NSString *result;
    if (!self.signedDigits) {
        result = nil;
    } else if ([self.signedDigits isEqualToString:@"-"]) {
        result = nil;
    } else if (self.startsWithMinus) {
        result = [self.signedDigits substringFromIndex:1];
    } else {
        result = [[self.signedDigits copy] autorelease];
    }
    return result;
}

- (BOOL)isEmpty
{
    return [Digits isEmpty:self.signedDigits];
}

- (BOOL)startsWithMinus
{
    return [Digits startsWithMinus:self.signedDigits];
}

- (BOOL)startsWithPoint
{
    return [Digits startsWithPoint:self.unsignedDigits];
}

- (BOOL)containsPoint
{
    return [Digits containsPoint:self.signedDigits];
}

- (unichar)zeroChar
{
    return [self.allowedDigits characterAtIndex:0];
}

# pragma mark mutating methods

- (void)pushDigit:(NSString *)digit
{
    if (![self isDigit:digit]) {
        NSLog(@"digit '%@' is not an allowed digit", digit);
        return; // early return because the rest of the method is meaningless with bad input
    }
    
    if ([digit isEqualToString:@"."] && [self containsPoint]) {
        NSLog(@"digit '%@' already present in signed digits '%@'", digit, self.signedDigits);
        return; // early return because the rest of the method is meaningless with bad input
    }
    
    if ([digit isEqualToString:@"-"]) {
        return [self negate]; // hand job over to negate method
    }
    
    if ([digit isEqualToString:@"."] && !self.signedDigits) {
        self.signedDigits = [@"0" stringByAppendingString:digit];          
    } else
    if ([digit isEqualToString:@"."] && [self.signedDigits isEqualToString:@"0"]) {
        self.signedDigits = [@"0" stringByAppendingString:digit];          
    } else
    if ([digit isEqualToString:@"."] && [self.signedDigits isEqualToString:@"-0"]) {
        self.signedDigits = [@"-0" stringByAppendingString:digit];          
    } else
    if (!self.signedDigits) {
        self.signedDigits = digit;
    } else 
    if ([self.signedDigits isEqualToString:@"0"]) {
        self.signedDigits = digit;
    } else 
    if ([self.signedDigits isEqualToString:@"-0"]) {
        self.signedDigits = [@"-" stringByAppendingString:digit];          
    } else
    {
        self.signedDigits = [self.signedDigits stringByAppendingString:digit];
    }
    
    return;
}

- (NSString *)popDigit
{
    NSString *lastDigit;
    int length = self.signedDigits.length;
    
    if (!self.signedDigits || length == 0) {
        lastDigit = nil;
    } else 
    if (length == 1) {
        lastDigit = [[self.signedDigits copy] autorelease];
        self.signedDigits = nil;
    } else {
        lastDigit = [self.signedDigits substringFromIndex:length - 1];
        self.signedDigits = [self.signedDigits substringToIndex:length - 1];
    }
    return lastDigit;
}

- (void)negate
{
    if (!self.signedDigits) {
        self.signedDigits = @"-0";
    } else
        if ([self.signedDigits isEqualToString:@"-0"]) {
            self.signedDigits = @"0";
        } else
            if (self.startsWithMinus) {
                self.signedDigits = self.unsignedDigits;
            } else
            {
                self.signedDigits = [@"-" stringByAppendingString:self.signedDigits];
            }
    return;
}

# pragma mark arithmetic methods

- (Digits *)plus:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    long long int firstOperandValue = self.integerValue;
    long long int secondOperandValue = secondOperand.integerValue;
    
    long long int result = firstOperandValue + secondOperandValue;
    return [[[Digits alloc] initWithLongLong:result base:self.base] autorelease];
}

- (Digits *)minus:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }

    long long int firstOperandValue = self.integerValue;
    long long int secondOperandValue = secondOperand.integerValue;
    
    long long int result = firstOperandValue - secondOperandValue;
    return [[[Digits alloc] initWithLongLong:result base:self.base] autorelease];
}

- (Digits *)times:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    long long int firstOperandValue = self.integerValue;
    long long int secondOperandValue = secondOperand.integerValue;
    
    long long int result = firstOperandValue * secondOperandValue;
    return [[[Digits alloc] initWithLongLong:result base:self.base] autorelease];
}

- (Digits *)divide:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    }
    
    long long int firstOperandValue = self.integerValue;
    long long int secondOperandValue = secondOperand.integerValue;
    
    if (secondOperandValue == 0) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits divideErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else {
        long long int result = firstOperandValue / secondOperandValue;
        return [[[Digits alloc] initWithLongLong:result base:self.base] autorelease];
    }
}

- (Digits *)invertWithError:(NSError **)error
{
    long long int operandValue = self.integerValue;

    if (operandValue == 0) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits invertErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else {
        long long int result = 1 / operandValue;
        return [[[Digits alloc] initWithLongLong:result base:self.base] autorelease];
    }
}

- (Digits *)power:(Digits *)secondOperand withError:(NSError **)error
{
    if (!secondOperand) {
        return nil;
    } 
    
    long long int firstOperandValue = self.integerValue;
    long long int secondOperandValue = secondOperand.integerValue;
    
    if ((firstOperandValue == 0) && (secondOperandValue == 0)) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits zeroPowerOfZeroErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else if ((firstOperandValue == 0) && (secondOperandValue < 0)) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits negativePowerOfZeroErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else if ((firstOperandValue < 0) && ([secondOperand containsPoint])) {
        if (error) {            
            NSDictionary *userDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                       NSLocalizedString([Digits fractionalPowerOfNegativeErrorMessage], @""),
                                       NSLocalizedDescriptionKey,
                                       nil] retain];
            NSError *localError = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:EPERM userInfo:userDict] autorelease];
            *error = localError;
            [userDict release];
        }
        return nil;
    } else {
        long long int result = pow((double)firstOperandValue, (double)secondOperandValue);
        return [[[Digits alloc] initWithLongLong:result base:self.base] autorelease];
    }
}

# pragma mark convenience methods

- (BOOL)isZero:(NSString *)digitString
{
    BOOL result;
    if (!digitString || [digitString length] != 1) {
        result = NO;
    } else 
    {
        result = ([digitString characterAtIndex:0] == self.zeroChar);
    }
    return result;
}

- (BOOL)isDigit:(NSString *)digitString
{
    BOOL result;
    if (digitString && (digitString.length == 1) && [self.allowedDigitSet characterIsMember:[digitString characterAtIndex:0]]) {
        result = YES;
    } else 
    {
        result = NO;
    }
    return result;
}

# pragma mark class constants

+ (NSString *)allDigits
{
    return [[allDigits copy] autorelease];
}

+ (NSString *)pointString
{
    return [NSString stringWithFormat:@"%C", pointChar];
}

+ (NSString *)negativeString
{
    return [NSString stringWithFormat:@"%C", negativeChar];
}

# pragma mark class error messages

+ (NSString *)divideErrorMessage
{
    return [NSString stringWithUTF8String:divideErrorMessage];
}

+ (NSString *)invertErrorMessage
{
    return [NSString stringWithUTF8String:invertErrorMessage];
}

+ (NSString *)zeroPowerOfZeroErrorMessage
{
    return [NSString stringWithUTF8String:zeroPowerOfZeroErrorMessage];
}

+ (NSString *)negativePowerOfZeroErrorMessage
{
    return [NSString stringWithUTF8String:negativePowerOfZeroErrorMessage];
}

+ (NSString *)fractionalPowerOfNegativeErrorMessage
{
    return [NSString stringWithUTF8String:fractionalPowerOfNegativeErrorMessage];
}

# pragma mark class utility methods

+ (NSString *)allowedDigitsForBase:(int)someBase
{
    return [[Digits allDigits] substringToIndex:someBase];
}

+ (NSCharacterSet *)allowedDigitSetForBase:(int)someBase
{
    NSString *allowedDigits = [Digits allowedDigitsForBase:someBase];
    NSCharacterSet *allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:allowedDigits];
    return allowedDigitSet;
}

+ (NSCharacterSet *)forbiddenDigitSetForBase:(int)someBase
{
    return [[Digits allowedDigitSetForBase:someBase] invertedSet];
}

# pragma mark -

+ (double)log:(double)operand base:(int)base
{
    return log(operand)/log(base);
}

+ (NSString *)parseDigits:(NSString *)someDigits fromBase:(int)someBase
{
    NSString *allowedDigits = [allDigits substringToIndex:someBase];
    NSCharacterSet *allowedDigitSet = [NSCharacterSet characterSetWithCharactersInString:allowedDigits];
    NSCharacterSet *forbiddenDigitSet = [allowedDigitSet invertedSet];
    
    NSScanner *scanner = [NSScanner scannerWithString:someDigits];
    [scanner scanString:@" " intoString:NULL];
    
    NSString *negativePrefix = @"";
    if ([scanner scanString:@"-" intoString:NULL]) {
        negativePrefix = @"-";
        [scanner scanString:@" " intoString:NULL];
    }
    
    NSString *signedDigits = nil;
    [scanner scanUpToCharactersFromSet:forbiddenDigitSet intoString:&signedDigits];
    
    return [NSString stringWithFormat:@"%@%@"
            , negativePrefix
            , signedDigits ? signedDigits : @""
            ];
}

+ (NSString *)convertInteger:(long long int)someInt toBase:(int)someBase
{
    NSString *result = @"";
    NSString *allowedDigits = [allDigits substringToIndex:someBase];
    int negative = signbit(someInt);
    unsigned long long int absoluteValue = llabs(someInt);
    
    if (absoluteValue == 0) {

        result = [allowedDigits substringToIndex:1]; // 

    } else
    {
        NSMutableString *someMutableDigits = [NSMutableString stringWithString:@""];
        
        if (negative) {
            [someMutableDigits appendString:@"-"];
        }
        
        if (absoluteValue < someBase) {
            [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:absoluteValue]];
        } else
        {
            unsigned long long int remainder = absoluteValue;
            unsigned long long int maximumBasePower = floor([Digits log:remainder base:someBase]);
            unsigned long long int power, quotient;
            
            for (unsigned long long int exponent = maximumBasePower; exponent > 0; exponent--) {
                power = pow((double)someBase, (double)exponent);
                quotient = remainder / power;
                remainder = remainder % power;
                [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:quotient]];
            }
            
            [someMutableDigits appendFormat:@"%C", [allowedDigits characterAtIndex:remainder]];
            
        }

        result = [NSString stringWithString:someMutableDigits];

    }
    return result;
}

# pragma mark -

+ (BOOL)startsWithMinus:(NSString *)someString
{
    BOOL result;
    if (!someString || [someString length] == 0) {
        result = NO;
    } else {
        result = [[someString substringToIndex:1] isEqualToString:@"-"];
    }
    return result;
}

+ (BOOL)startsWithPoint:(NSString *)digitString
{
    BOOL result;
    if (!digitString || [digitString length] == 0) {
        result = NO;
    } else {
        result = ([[digitString substringToIndex:1] isEqualToString:@"."]);
    }
    return result;
}

+ (BOOL)containsPoint:(NSString *)digitString
{
    return [digitString rangeOfString:@"."].length > 0;
}

+ (BOOL)isEmpty:(NSString *)digitString
{
    BOOL result;
    if (!digitString || [digitString length] != 0) {
        result = NO;
    } else {
        result = YES;
    }
    return result;
}

@end