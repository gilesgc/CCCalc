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
    BOOL isBackgroundNumberSet;
    BOOL previouslyTappedClear;
    BOOL previouslyTappedAddOrSub;
}
- (void)evaluateTap:(unsigned)identifier;
- (NSString *)currentValue;
- (NSString *)currentValueWithCommas;
- (BOOL)displayingAC;
@end