#import "CCCalcUI/CCCalcUI.h"

%subclass CCCalcButton : TPNumberPadDarkStyleButton
%property (nonatomic, retain) id delegate;
%property (assign) BOOL shouldStayHighlighted;

//Using subclass of the lockscreen keypad buttons for ez and nice looking buttons

+ (id)imageForCharacter:(unsigned)character {
	UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0,0,75,75)];
	[text setTextColor:[UIColor whiteColor]];
	[text setFont:[UIFont boldSystemFontOfSize:25]];
	[text setTextAlignment:NSTextAlignmentCenter];

	[text setText:[[self class] textForButtonID:character]];

	return [text performSelector:@selector(_image)]; //private method which generates a UIImage from UILabel
}

- (void)setFrame:(CGRect)arg1 {
	%orig;
	for(UIView *view in [(UIView *)self subviews])
		[view setFrame:CGRectMake(0,0,arg1.size.width,arg1.size.height)];
	[objc_getAssociatedObject(self, @selector(glyphImage)) setFrame:CGRectMake(0,0,arg1.size.width,arg1.size.height)];
}

+ (CGRect)circleBounds {
	return CGRectMake(0,0,65,65);
}

- (void)setGlyphLayer:(CALayer *)layer {
	%orig;
	[layer setFrame:[[self class] circleBounds]];
}

%new +(NSString *)textForButtonID:(unsigned)identifier {
	if(identifier <= 9) {
		return [@(identifier) stringValue];
	} else {
		switch(identifier) {
			case BTN_CLEAR:
				return @"C";
			case BTN_NEGATE:
				return @"+/-";
			case BTN_PERCENT:
				return @"%";
			case BTN_DIVIDE:
				return @"÷";
			case BTN_MULTIPLY:
				return @"✕";
			case BTN_SUBTRACT:
				return @"−";
			case BTN_ADD:
				return @"+";
			case BTN_EQUAL:
				return @"=";
			case BTN_DECIMAL:
				return @".";
			default:
				return @"";
		}
	}
}

- (id)initForCharacter:(unsigned)character {
	CCCalcButton *me = %orig;
	[me addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
	return me;
}

%new - (void)tapped {
	if([self delegate] && [[self delegate] respondsToSelector:@selector(buttonTapped:)])
		[[self delegate] buttonTapped:[self character]];
}

- (void)setHighlighted:(BOOL)h {
	if([self shouldStayHighlighted])
		return;
	else
		%orig;
}

%end

@implementation CCCalcViewController

- (id)init {
	self = [super init];

	if(self) {
		_buttons = [[NSMutableDictionary alloc] init];

		_displayView = [[CCCalcDisplayView alloc] init];
		[_displayView setFrame:CGRectMake(0,0,100,100)];
		[[_displayView labelView] setTextColor:[UIColor whiteColor]];
		[[_displayView labelView] setFrame:CGRectMake(0,0,100,100)];
		[_displayView setText:@"0"];

		_brain = [[CCCalcBrain alloc] init];
	}

	return self;
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[[self view] addSubview:[self displayView]];
	[self initButtons];
	[self layoutButtons];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self layoutButtons];
}

- (void)initButtons {
	for(int i = 0; i <= 19; i++) {
		if(i == 13)
			continue;

		CCCalcButton *button = [[%c(CCCalcButton) alloc] initForCharacter:i];
		[[self buttons] setObject:button forKey:@(i)];
		[self.view addSubview:button];
		[button setDelegate:self];
	}
}

- (void)layoutButtons {
	//buttons placement from top left to bottom right (not including bottom row because special case)
	int buttonsGrid[4][4] = {
		{ BTN_CLEAR, BTN_NEGATE, BTN_PERCENT, BTN_DIVIDE },
		{ BTN_7, BTN_8, BTN_9, BTN_MULTIPLY },
		{ BTN_4, BTN_5, BTN_6, BTN_SUBTRACT },
		{ BTN_1, BTN_2, BTN_3, BTN_ADD }
	};
	for(int row = 0; row <= 3; row++)
		for(int column = 0; column <= 3; column++)
			[self.buttons[@(buttonsGrid[row][column])] setFrame:[self positionAtColumn:column row:row]];

	[self.buttons[@(BTN_0)] setFrame:CGRectMake([self column:0], [self row:4], [self column:1] + [%c(CCCalcButton) circleBounds].size.width - ((double)[self view].frame.size.width / 4.0f - [%c(CCCalcButton) circleBounds].size.width)/2.0f, [%c(CCCalcButton) circleBounds].size.height)];
	[self.buttons[@(BTN_DECIMAL)] setFrame:[self positionAtColumn:2 row:4]];
	[self.buttons[@(BTN_EQUAL)] setFrame:[self positionAtColumn:3 row:4]];
}

- (float)column:(unsigned int)column {
	return ((double)[self view].frame.size.width / 4.0f) * column + ((double)[self view].frame.size.width / 4.0f - [%c(CCCalcButton) circleBounds].size.width)/2.0f;
}

- (float)row:(unsigned int)row {
	return ((double)[self view].frame.size.height / 5.0f) * row + ((double)[self view].frame.size.height / 5.0f - [%c(CCCalcButton) circleBounds].size.height)/2.0f;
}

- (CGRect)positionAtColumn:(unsigned int)column row:(unsigned int)row {
	return CGRectMake([self column:column], [self row:row], [%c(CCCalcButton) circleBounds].size.width, [%c(CCCalcButton) circleBounds].size.height);
}

- (void)buttonTapped:(unsigned)identifier {
	[[self brain] evaluateTap:identifier];
	[[self displayView] setText:[[self brain] currentValue]];

	if(identifier == BTN_ADD || identifier == BTN_SUBTRACT || identifier == BTN_MULTIPLY || identifier == BTN_DIVIDE) {
		CCCalcButton *operationButton = [self buttons][@(identifier)];
		[operationButton setShouldStayHighlighted:YES];

		for(CCCalcButton *opBtn in [self operationButtons]) {
			if(opBtn == operationButton)
				continue;
			[opBtn setShouldStayHighlighted:NO];
			[opBtn setHighlighted:NO];
		}
	} else {
		for(CCCalcButton *opBtn in [self operationButtons]) {
			[opBtn setShouldStayHighlighted:NO];
			[opBtn setHighlighted:NO];
		}
	}
}

- (NSArray<CCCalcButton *> *)operationButtons {
	return @[[self buttons][@(BTN_ADD)], [self buttons][@(BTN_SUBTRACT)], [self buttons][@(BTN_MULTIPLY)], [self buttons][@(BTN_DIVIDE)]];
}

@end

@interface CCUIAppLauncherViewController : UIViewController
-(UIView *)contentView;
-(UIImage *)glyphImage;
-(BOOL)isCalcModule;
-(UIView *)buttonView;
-(CGFloat)headerHeight;
-(CGFloat)preferredExpandedContentWidth;
@end

@interface SBFApplication : NSObject
- (NSString *)applicationBundleIdentifier;
@end

static CCCalcViewController *ccCalcController;

%hook CCUIAppLauncherViewController

-(void)willTransitionToExpandedContentMode:(BOOL)expanded {
	%orig;

	if(![self isCalcModule])
		return;

	if(expanded) {

		if(!ccCalcController) {
			ccCalcController = [[CCCalcViewController alloc] init];
			MSHookIvar<UIView *>(self, "_contentView") = [ccCalcController view];
			[[self view] addSubview:[ccCalcController displayView]];
			[[self view] addSubview:[ccCalcController view]];

			[[ccCalcController displayView] setFrame:CGRectMake(0,0,[self preferredExpandedContentWidth],[self headerHeight])];
		}

		for(UIView *menuItem in MSHookIvar<NSMutableArray *>(self, "_menuItemsViews")) {
			[menuItem setHidden:YES];
		}

		[[ccCalcController view] setHidden:NO];
		[[ccCalcController displayView] setHidden:NO];
		[[self buttonView] setHidden:YES];
	
	} else {
		[[ccCalcController view] setHidden:YES];
		[[ccCalcController displayView] setHidden:YES];
		[[self buttonView] setHidden:NO];
	}

}

-(CGFloat)preferredExpandedContentHeight {
	if([self isCalcModule])
		return 525.0f;
	else
		return %orig;
}

-(void)_setupTitleLabel {
	if([self isCalcModule])
		return;

	%orig;
}

%new -(BOOL)isCalcModule {
	return [[MSHookIvar<SBFApplication *>(self, "_application") applicationBundleIdentifier] isEqualToString:@"com.apple.calculator"];
}

%end