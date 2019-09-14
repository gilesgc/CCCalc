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
        [self appendToDisplay:[@(identifier) stringValue]];
    }
    else {
        switch(identifier) {
            case BTN_DECIMAL:
                if(![displayValue containsString:@"."])
                    [self appendToDisplay:@"."];
                break;

            case BTN_CLEAR:
                [self clearDisplay];
                break;

            case BTN_NEGATE:
                if([displayValue containsString:@"-"])
                    displayValue = [displayValue substringWithRange:NSMakeRange(1, displayValue.length - 1)];
                else
                    displayValue = [@"-" stringByAppendingString:displayValue];
                break;

            case BTN_PERCENT:
                displayValue = [@([displayValue doubleValue] / 100.0) stringValue];
                break;

            case BTN_EQUAL:
                if(!isOnSecondValue)
                    break;
                
                secondNumber = [displayValue doubleValue];
                if(operation == BTN_ADD)
                    firstNumber += secondNumber;
                else if(operation == BTN_SUBTRACT)
                    firstNumber -= secondNumber;
                else if(operation == BTN_MULTIPLY)
                    firstNumber *= secondNumber;
                else if(operation == BTN_DIVIDE)
                    firstNumber /= secondNumber;

                displayValue = [@(firstNumber) stringValue];

                isOnSecondValue = NO;
                isShowingResult = YES;
                break;

            case BTN_ADD:
            case BTN_SUBTRACT:
            case BTN_MULTIPLY:
            case BTN_DIVIDE:
                operation = identifier;
                firstNumber = [displayValue doubleValue];
                willStartSecondValue = YES;
        }
    }
}

- (void)appendToDisplay:(NSString *)string {
    displayValue = [displayValue stringByAppendingString:string];
}

- (void)clearDisplay {
    displayValue = @"0";
    isShowingResult = YES;
}

- (NSString *)currentValue {
    return displayValue;
}

@end