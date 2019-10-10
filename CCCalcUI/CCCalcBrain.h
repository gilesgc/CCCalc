#import "CCCalcButtons.h"

@interface CCCalcBrain : NSObject {
    double firstNumber;
    double secondNumber;
    unsigned operation;
    NSString *displayValue;

    BOOL willStartSecondValue;
    BOOL isOnSecondValue;
    BOOL isShowingResult;
    BOOL previouslyTappedClear;
}
- (void)evaluateTap:(unsigned)identifier;
- (NSString *)currentValue;
- (NSString *)currentValueWithCommas;
@end