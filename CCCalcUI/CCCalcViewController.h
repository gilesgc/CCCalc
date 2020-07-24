#import "CCCalcButton.h"
#import "CCCalcBrain.h"
#import "CCCalcDisplayView.h"
#import "CCCalcScrollView.h"
#import "CCCalcPage.h"

@interface CCCalcViewController : UIViewController <CCCalcDelegate, UIScrollViewDelegate> {
    CCCalcScrollView *_scrollView;
    CCCalcPage *_pageOne;
    CCCalcPage *_pageTwo;
    BOOL _didLayout;
}
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, CCCalcButton *> *buttons;
@property (nonatomic, retain) CCCalcDisplayView *displayView;
@property (nonatomic, retain) CCCalcBrain *brain;
- (void)buttonTapped:(unsigned)identifier;
- (BOOL)_canShowWhileLocked;
@end
