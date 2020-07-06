#import "CCCalcPage.h"

@interface CCCalcScrollView : UIScrollView {
    NSMutableArray<UIView *> *_pages;
    CGSize _pageSize;
}
- (id)initWithPageSize:(CGSize)pageSize;
- (void)addPage:(CCCalcPage *)page;
@end