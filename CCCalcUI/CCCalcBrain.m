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
                    isShowingResult = NO;
                }
                if(![displayValue containsString:@"."]) {
                    [self appendToDisplay:@"."];
                    isShowingResult = NO;
                }
                break;

            case BTN_CLEAR:
                [self clearDisplay];
                if(previouslyTappedClear) {
                    isOnSecondValue = NO;
                    willStartSecondValue = NO;
                    firstNumber = 0.0;
                    secondNumber = 0.0;
                    operation = 0.0;
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
                else
                    displayValue = [@([displayValue doubleValue] / 100.0) stringValue];
                break;

            case BTN_EQUAL:
                if(!isOnSecondValue) {
                    if(secondNumber == 0)
                        break;
                    [self evaluate];
                    displayValue = [@(firstNumber) stringValue];
                    break;
                }
                
                secondNumber = [displayValue doubleValue];
                [self evaluate];

                displayValue = [@(firstNumber) stringValue];

                isOnSecondValue = NO;
                isShowingResult = YES;
                break;

            case BTN_ADD:
            case BTN_SUBTRACT:
            case BTN_MULTIPLY:
            case BTN_DIVIDE:
                if(isOnSecondValue) {
                    secondNumber = [displayValue doubleValue];
                    [self evaluate];
                    displayValue = [@(firstNumber) stringValue];
                    isOnSecondValue = NO;
                    isShowingResult = YES;
                }
                operation = identifier;
                firstNumber = [displayValue doubleValue];
                willStartSecondValue = YES;
        }
    }
    if(identifier != BTN_CLEAR)
        previouslyTappedClear = NO;
}

- (void)evaluate {
    if(operation == BTN_ADD)
        firstNumber += secondNumber;
    else if(operation == BTN_SUBTRACT)
        firstNumber -= secondNumber;
    else if(operation == BTN_MULTIPLY)
        firstNumber *= secondNumber;
    else if(operation == BTN_DIVIDE)
        firstNumber /= secondNumber;
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