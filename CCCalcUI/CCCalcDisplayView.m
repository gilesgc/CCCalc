#import "CCCalcDisplayView.h"

@implementation CCCalcDisplayView
- (id)init {
	self = [super init];
	if(self) {
		_labelView = [[UILabel alloc] init];
		[self addSubview:_labelView];
		[_labelView setTextAlignment:NSTextAlignmentRight];
		[_labelView setFont:[UIFont systemFontOfSize:45 weight:UIFontWeightLight]];
	}
	return self;
}
- (void)setText:(NSString *)text {
	[[self labelView] setText:text];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect labelFrame = CGRectMake(25,0,[self frame].size.width - 50, [self frame].size.height + 10);
	[[self labelView] setFrame:labelFrame];
}
@end