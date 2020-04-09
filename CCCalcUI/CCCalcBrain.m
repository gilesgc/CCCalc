#import "CCCalcBrain.h"

//This object handles all the calculations

@implementation CCCalcBrain

- (id)init {
    self = [super init];
    if(self) {
        [self clearDisplay];
    }
    return self;
}

- (void)evaluateTap:(unsigned)identifier {

    if(identifier <= 9) {
        if(identifier == BTN_0 && [displayValue isEqualToString:@"0"])
            return;
        if(willStartSecondValue) {
            [self clearDisplay];
            willStartSecondValue = NO;
            isOnSecondValue = YES;
        }
        if(isShowingResult) {
            displayValue = @"";
            isShowingResult = NO;
        }
        if(displayValue.length >= 9)
            return;

        [self appendToDisplay:[@(identifier) stringValue]];
    }
    else {
        switch(identifier) {
            case BTN_DECIMAL:
                if(willStartSecondValue) {
                    [self clearDisplay];
                    willStartSecondValue = NO;
                    isOnSecondValue = YES;
                } else if(previouslyTappedAddOrSub) {
                    [self clearDisplay];
                }
                if(![displayValue containsString:@"."]) {
                    [self appendToDisplay:@"."];
                }
                isShowingResult = NO;
                break;

            case BTN_CLEAR:
                [self clearDisplay];
                if(previouslyTappedClear) {
                    isOnSecondValue = NO;
                    willStartSecondValue = NO;
                    firstNumber = 0.0;
                    secondNumber = 0.0;
                    backgroundNumber = 0.0;
                    operation = 0.0;
                    backgroundOperation = 0.0;
                }
                previouslyTappedClear = YES;
                break;

            case BTN_NEGATE:
                if([displayValue containsString:@"-"])
                    displayValue = [displayValue substringWithRange:NSMakeRange(1, displayValue.length - 1)];
                else
                    displayValue = [@"-" stringByAppendingString:displayValue];
                break;

            case BTN_PERCENT:
                if(isOnSecondValue)
                    displayValue = [@(firstNumber * [displayValue doubleValue] / 100.0) stringValue];
                else if(backgroundNumber != 0)
                    displayValue = [@(backgroundNumber * [displayValue doubleValue] / 100.0) stringValue];
                else
                    displayValue = [@([displayValue doubleValue] / 100.0) stringValue];
                break;

            case BTN_EQUAL:
                if(operation == 0)
                    return;
                if(isOnSecondValue) {
                    secondNumber = [displayValue doubleValue];
                    [self evaluateWithOperation:operation firstNumber:&firstNumber secondNumber:secondNumber];
                    if(backgroundNumber != 0) {
                        [self evaluateWithOperation:backgroundOperation firstNumber:&backgroundNumber secondNumber:firstNumber];
                        firstNumber = backgroundNumber;
                        backgroundNumber = 0.0;
                    }
                    displayValue = [@(firstNumber) stringValue];
                    isOnSecondValue = NO;
                }
                else {
                    if(backgroundNumber != 0) {
                        secondNumber = [displayValue doubleValue];
                        [self evaluateWithOperation:backgroundOperation firstNumber:&backgroundNumber secondNumber:secondNumber];
                        firstNumber = backgroundNumber;
                        backgroundNumber = 0.0;
                    } else {
                        [self evaluateWithOperation:operation firstNumber:&firstNumber secondNumber:secondNumber];
                    }
                    displayValue = [@(firstNumber) stringValue];
                }
                isShowingResult = YES;
                break;

            case BTN_ADD:
            case BTN_SUBTRACT:
                previouslyTappedAddOrSub = YES;
                willStartSecondValue = NO;
                if(isShowingResult) {
                    operation = identifier;
                    backgroundOperation = identifier;
                    backgroundNumber = [displayValue doubleValue];
                    break;
                }
                if(backgroundNumber == 0) {
                    if(isOnSecondValue) {
                        secondNumber = [displayValue doubleValue];
                        [self evaluateWithOperation:operation firstNumber:&firstNumber secondNumber:secondNumber];
                        displayValue = [@(firstNumber) stringValue];
                    }
                    backgroundOperation = identifier;
                    backgroundNumber = [displayValue doubleValue];
                    isOnSecondValue = NO;
                    isShowingResult = YES;
                }
                else {
                    if(isOnSecondValue) {
                        secondNumber = [displayValue doubleValue];
                        [self evaluateWithOperation:operation firstNumber:&firstNumber secondNumber:secondNumber];
                        [self evaluateWithOperation:backgroundOperation firstNumber:&backgroundNumber secondNumber:firstNumber];
                        displayValue = [@(backgroundNumber) stringValue];
                    } else {
                        firstNumber = [displayValue doubleValue];
                        [self evaluateWithOperation:backgroundOperation firstNumber:&backgroundNumber secondNumber:firstNumber];
                        displayValue = [@(backgroundNumber) stringValue];
                        isShowingResult = YES;
                    }
                }
                operation = identifier;
                backgroundOperation = identifier;
                break;

            case BTN_MULTIPLY:
            case BTN_DIVIDE:
                previouslyTappedMulOrDiv = YES;
                if(previouslyTappedAddOrSub) {
                    operation = identifier;
                    firstNumber = backgroundNumber;
                    backgroundNumber = 0.0;
                    backgroundOperation = 0.0;
                    willStartSecondValue = YES;
                    break;
                }
                if(isOnSecondValue) {
                    secondNumber = [displayValue doubleValue];
                    [self evaluateWithOperation:operation firstNumber:&firstNumber secondNumber:secondNumber];
                    displayValue = [@(firstNumber) stringValue];
                    isOnSecondValue = NO;
                    isShowingResult = YES;
                }
                operation = identifier;
                firstNumber = [displayValue doubleValue];
                willStartSecondValue = YES;
                break;

        }
    }
    if(identifier != BTN_CLEAR)
        previouslyTappedClear = NO;
    if(identifier != BTN_ADD && identifier != BTN_SUBTRACT)
        previouslyTappedAddOrSub = NO;
    if(identifier != BTN_MULTIPLY && identifier != BTN_DIVIDE)
        previouslyTappedMulOrDiv = NO;
}

- (void)evaluateWithOperation:(unsigned)op firstNumber:(double *)fn secondNumber:(double)sn {
    if(op == BTN_ADD)
        *fn += sn;
    else if(op == BTN_SUBTRACT)
        *fn -= sn;
    else if(op == BTN_MULTIPLY)
        *fn *= sn;
    else if(op == BTN_DIVIDE)
        *fn /= sn;
}

- (void)appendToDisplay:(NSString *)string {
    displayValue = [displayValue stringByAppendingString:string];
}

- (void)clearDisplay {
    displayValue = @"0";
    isShowingResult = YES;
}

+ (NSString *)commaFormat:(NSString *)input {
    NSString *formatted = @"";
    BOOL isNegative = NO;

    if([[input substringWithRange:NSMakeRange(0,1)] isEqualToString:@"-"]) {
        isNegative = YES;
        input = [input substringWithRange:NSMakeRange(1, input.length - 1)];    
    }

    int start = input.length % 3;

    for(int c = 0; c < input.length; c++) {
        if((c - start) % 3 == 0 && c != 0) {
            formatted = [formatted stringByAppendingString:@","];
        }
        formatted = [formatted stringByAppendingString:[input substringWithRange:NSMakeRange(c, 1)]];
    }

    return isNegative ? [@"-" stringByAppendingString:formatted] : formatted;
}

- (NSString *)currentValue {
    return displayValue;
}

- (NSString *)currentValueWithCommas {
    if(displayValue.length >= 4) {

        if([displayValue containsString:@"."]) {
            NSArray *split = [displayValue componentsSeparatedByString:@"."];
            return [NSString stringWithFormat:@"%@.%@",[CCCalcBrain commaFormat:split[0]],split[1]];
        }
        else {
            return [CCCalcBrain commaFormat:displayValue];
        }
    }
    return displayValue;
}

@end