#import "CCCalcScrollView.h"

@implementation CCCalcScrollView

- (id)initWithPageSize:(CGSize)size {
    self = [super init];
    
    if(self) {
        _pages = [[NSMutableArray alloc] init];
        _pageSize = size;
        [self setCanCancelContentTouches:YES];
        [self setPagingEnabled:YES];
        [self setBounces:NO];
        [self setDelaysContentTouches:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
    }

    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if( [view isKindOfClass:[UIControl class]] ) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (void)addPage:(CCCalcPage *)page {
    [_pages addObject:page];
    [self addSubview:page];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];

    for(int i = 0; i < [_pages count]; i++) {
        [_pages[i] setFrame:CGRectMake(i * self.frame.size.width, 0, _pageSize.width, _pageSize.height)];
    }

    [self setContentSize:CGSizeMake(self.frame.size.width * _pages.count, _pageSize.height)];
}

@end