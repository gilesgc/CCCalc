#import "CCCalcScrollView.h"

@implementation CCCalcScrollView

- (id)initWithPageSize:(CGSize)size {
    self = [super init];
    
    if(self) {
        _pages = [[NSMutableArray alloc] init];
        _pageSize = size;
        self.canCancelContentTouches = YES;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delaysContentTouches = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
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

    for(int i = 0; i < [_pages count]; i++) {
        [_pages[i] setFrame:CGRectMake(i * _pageSize.width, 0, _pageSize.width, _pageSize.height)];
    }

    [self setContentSize:CGSizeMake(_pageSize.width * _pages.count, _pageSize.height)];
}

- (void)setFrame:(CGRect)frame {
    if(([[[UIDevice currentDevice] systemVersion] compare:@"12.4.1" options:NSNumericSearch] != NSOrderedDescending)) {
        [super setFrame:frame];
        return;
    }

    if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
        [super setFrame:CGRectMake(0, self.frame.origin.y, _pageSize.width, (UIScreen.mainScreen.bounds.size.height - self.frame.origin.y - 24.5))];
    } else {
        [super setFrame:frame];
    }
}

@end