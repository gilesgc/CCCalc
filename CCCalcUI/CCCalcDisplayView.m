#import "CCCalcDisplayView.h"

@implementation CCCalcLabelView

- (id)init {
	self = [super init];
	
	if(self) {
		[self setUserInteractionEnabled:YES];
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)]];
		[self setAdjustsFontSizeToFitWidth:YES];
		[self setTextAlignment:NSTextAlignmentRight];
		[self setFont:[UIFont systemFontOfSize:45 weight:UIFontWeightLight]];
	}

	return self;
}
- (void)copy:(id)sender {
	[UIPasteboard generalPasteboard].string = [self text];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	return action == @selector(copy:);
}
- (void)tapped {
	[self becomeFirstResponder];
	UIMenuController *menu = [UIMenuController sharedMenuController];
	CGRect myFrame = self.frame;
	[menu setTargetRect:CGRectMake(0,0,myFrame.size.width, myFrame.size.height) inView:self];
	[menu setMenuVisible:YES animated:YES];
}
- (BOOL)canBecomeFirstResponder {
	return YES;
}
@end

@implementation CCCalcDisplayView
- (id)init {
	self = [super init];
	if(self) {
		_labelView = [[CCCalcLabelView alloc] init];
		[self addSubview:_labelView];
		[_labelView becomeFirstResponder];
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