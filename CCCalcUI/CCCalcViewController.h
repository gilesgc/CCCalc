#import "CCCalcButton.h"
#import "CCCalcBrain.h"
#import "CCCalcDisplayView.h"

@interface CCCalcViewController : UIViewController <CCCalcDelegate>
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, CCCalcButton *> *buttons;
@property (nonatomic, retain) CCCalcDisplayView *displayView;
@property (nonatomic, retain) CCCalcBrain *brain;
- (void)buttonTapped:(unsigned)identifier;
@end
