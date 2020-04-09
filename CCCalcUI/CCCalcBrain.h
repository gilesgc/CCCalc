#import "CCCalcButtons.h"

@interface CCCalcBrain : NSObject {
    double firstNumber;
    double secondNumber;
    double backgroundNumber;
    unsigned operation;
    unsigned backgroundOperation;
    NSString *displayValue;

    BOOL willStartSecondValue;
    BOOL isOnSecondValue;
    BOOL isShowingResult;
    BOOL previouslyTappedClear;
    BOOL previouslyTappedAddOrSub;
    BOOL previouslyTappedMulOrDiv;
}
- (void)evaluateTap:(unsigned)identifier;
- (NSString *)currentValue;
- (NSString *)currentValueWithCommas;
@end