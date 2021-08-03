#import <objc/runtime.h>
#import "Tweak.h"
#import "CCCalcUI/CCCalcUI.h"

bool class_hasSubIvar(const char *cls, const char *ivar) {
	unsigned int icount = 0;
	Ivar *ivars = class_copyIvarList(objc_getClass(cls), &icount);
	for (int i = 0; i < icount; i++) {
		if (strcmp(ivar_getName(ivars[i]), ivar) == 0) {
			free(ivars);
			return true;
		}
	}
	free(ivars);
	return false;
}

%subclass CCCalcButton : TPNumberPadDarkStyleButton
//Subclass of the lockscreen keypad buttons
%property (nonatomic, retain) id delegate;
%property (assign) BOOL shouldStayHighlighted;

+ (id)imageForCharacter:(unsigned)character {
	if(character == BTN_MULTIPLY || character == BTN_NEGATE || character == BTN_BACK) {
		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.gilesgc.cccalc.bundle"];
		if(character == BTN_BACK)
			return [UIImage imageWithContentsOfFile:[bundle pathForResource:@"back" ofType:@"png"]];
		else
			return [UIImage imageWithContentsOfFile:[bundle pathForResource:(character == BTN_MULTIPLY ? @"multiply" : @"plus-minus") ofType:@"png"]];
	}
	else if(character >= 20) {
		//function buttons
		return [CCCalcFunction.functions[@(character)] image];
	}

	return [[self class] textToImage:[[self class] textForButtonID:character]];
}

%new + (UIImage *)textToImage:(NSString *)text {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,75,75)];
	[label setTextColor:[UIColor whiteColor]];
	[label setFont:[UIFont boldSystemFontOfSize:25]];
	[label setTextAlignment:NSTextAlignmentCenter];

	[label setText:text];

	return [label performSelector:@selector(_image)];
}

- (void)setFrame:(CGRect)frame {
	%orig;

	for(UIView *view in [self subviews])
		[view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

	if([self character] == BTN_0) {
		for(UIView *subview in [self subviews]) {
			for(CALayer *sublayer in [[subview layer] sublayers]) {
				if([NSStringFromClass([sublayer class]) isEqualToString:@"CABackdropLayer"]) {
					[sublayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
					break;
				}
			}
		}
	}
}

+ (CGRect)circleBounds {
	return CGRectMake(0,0,65,65);
}

- (void)setGlyphLayer:(CALayer *)layer {
	%orig;
	[layer setFrame:[[self class] circleBounds]];
}

%new - (void)setImage:(UIImage *)image {
	for(CALayer *layer in self.layer.sublayers) {
		if(layer.contents) {
			[layer setContents:((id)image.CGImage)];
			return;
		}
	}
}

%new +(NSString *)textForButtonID:(unsigned)identifier {
	if(identifier <= 9) {
		return [@(identifier) stringValue];
	} else {
		switch(identifier) {
			case BTN_CLEAR:
				return @"AC";
			case BTN_NEGATE:
				return @"+/-";
			case BTN_PERCENT:
				return @"%";
			case BTN_DIVIDE:
				return @"÷";
			case BTN_MULTIPLY:
				return @"x";
			case BTN_SUBTRACT:
				return @"−";
			case BTN_ADD:
				return @"+";
			case BTN_EQUAL:
				return @"=";
			case BTN_DECIMAL:
				return @".";
			default:
				return @"?";
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
static CGRect _circleBounds = [%c(CCCalcButton) circleBounds];
static UIImage *clearC;
static UIImage *clearAC;

static int _buttonsGrid[4][4] = {
	{ BTN_CLEAR,	BTN_NEGATE, BTN_PERCENT, 	BTN_DIVIDE },
	{ BTN_7, 		BTN_8, 		BTN_9, 			BTN_MULTIPLY },
	{ BTN_4, 		BTN_5, 		BTN_6, 			BTN_SUBTRACT },
	{ BTN_1, 		BTN_2, 		BTN_3, 			BTN_ADD }
};

static int _functionsGrid[5][4] = {
	{ BTN_TRIGUNITSSWITCHER,	BTN_RANDOM,				BTN_SQUARE,			BTN_CUBE },
	{ BTN_EXPONENTIAL,			BTN_NATURALLOGARITHM,	BTN_SQUAREROOT,		BTN_CUBEROOT },
	{ BTN_TENRAISEDTOX,			BTN_LOGARITHM,			BTN_RECIPROCAL,		BTN_EULERSNUMBER },
	{ BTN_SINE, 				BTN_COSINE,				BTN_TANGENT,		BTN_PI },
	{ BTN_INVERSESINE,			BTN_INVERSECOSINE,		BTN_INVERSETANGENT,	BTN_BACK }
};

- (id)initWithPageSize:(CGSize)size {
	self = [super init];

	if(self) {
		_buttons = [[NSMutableDictionary alloc] init];

		_displayView = [[CCCalcDisplayView alloc] init];
		[_displayView setFrame:CGRectMake(0,0,100,100)];
		[[_displayView labelView] setTextColor:[UIColor whiteColor]];
		[[_displayView labelView] setFrame:CGRectMake(0,0,100,100)];
		[_displayView setText:@"0"];

		_scrollView = [[CCCalcScrollView alloc] initWithPageSize:size];
		_pageOne = [[CCCalcPage alloc] initWithCircleBounds:_circleBounds columns:4 rows:5];
		_pageTwo = [[CCCalcPage alloc] initWithCircleBounds:_circleBounds columns:4 rows:5];
		[_scrollView addPage:_pageOne];
		[_scrollView addPage:_pageTwo];
		[_scrollView setDelegate:self];

		_brain = [[CCCalcBrain alloc] init];
	}

	return self;
}

- (void)loadView {
	self.view = _scrollView;
	[self.view addSubview:self.displayView];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	if(!_didLayout) {
		[self initButtons];
		[self layoutButtons];
		clearC = [%c(CCCalcButton) textToImage:@"C"];
		clearAC = [%c(CCCalcButton) textToImage:@"AC"];
		_didLayout = YES;
	}
}

- (void)initButtons {
	for(int i = 0; i <= 39; i++) {
		if(i == 13)
			continue;

		CCCalcButton *button = [[%c(CCCalcButton) alloc] initForCharacter:i];
		[[self buttons] setObject:button forKey:@(i)];
		[button setDelegate:self];
	}
}

- (void)layoutButtons {
	for(int row = 0; row <= 3; row++)
		for(int column = 0; column <= 3; column++)
			[_pageOne addButton:self.buttons[@(_buttonsGrid[row][column])] atColumn:column row:row];

	[_pageOne addButton:self.buttons[@(BTN_DECIMAL)] atColumn:2 row:4];
	[_pageOne addButton:self.buttons[@(BTN_EQUAL)] atColumn:3 row:4];
	[_pageOne addSubview:self.buttons[@(BTN_0)]];
	[self.buttons[@(BTN_0)] setFrame:CGRectMake([_pageOne column:0], [_pageOne row:4], [_pageOne column:1] + _circleBounds.size.width - ((double)[self view].frame.size.width / 4.0f - _circleBounds.size.width)/2.0f, _circleBounds.size.height)];

	for(int row = 0; row <= 4; row++)
		for(int column = 0; column <= 3; column++)
			[_pageTwo addButton:self.buttons[@(_functionsGrid[row][column])] atColumn:column row:row];
}

- (void)buttonTapped:(unsigned)identifier {
	[_brain evaluateTap:identifier];
	[[self displayView] setText:[_brain currentValueWithCommas]];

	if([_brain displayingAC])
		[_buttons[@(BTN_CLEAR)] setImage:clearAC];
	else
		[_buttons[@(BTN_CLEAR)] setImage:clearC];

	if(identifier == BTN_BACK) {
		[UIView animateWithDuration:0.25 animations:^{
			_scrollView.contentOffset = CGPointMake(0, _scrollView.contentOffset.y);
		}];
	}
	else if(identifier == BTN_TRIGUNITSSWITCHER) {
		[_buttons[@(BTN_TRIGUNITSSWITCHER)] setImage:CCCalcFunction.functions[@(BTN_TRIGUNITSSWITCHER)].image];
	}
	else if(identifier == BTN_ADD || identifier == BTN_SUBTRACT || identifier == BTN_MULTIPLY || identifier == BTN_DIVIDE) {
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSArray *operationButtons = self.operationButtons;
	for(CCCalcButton *button in [_buttons allValues]) {
		if([operationButtons containsObject:button])
			continue;
		[button highlightCircleView:NO animated:YES];
	}
}

- (BOOL)_canShowWhileLocked {
	return YES;
}

@end



static CCCalcViewController *ccCalcController;

%hook CCUIAppLauncherViewController

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	%orig;

	if(![self isCalcModule])
		return;

	if(expanded) {

		if(!ccCalcController) {
			ccCalcController = [[CCCalcViewController alloc] initWithPageSize:CGSizeMake(self.preferredExpandedContentWidth, self.preferredExpandedContentHeight - (self.headerHeight + self._footerHeight))];
			MSHookIvar<UIView *>(self, "_contentView") = ccCalcController.view;
			[self.view addSubview:ccCalcController.displayView];
			[self.view addSubview:ccCalcController.view];

			[ccCalcController.displayView setFrame:CGRectMake(0, 0, self.preferredExpandedContentWidth, self.headerHeight)];
		}

		for(UIView *menuItem in MSHookIvar<UIStackView *>(self, "_menuItemsContainer").arrangedSubviews) {
			menuItem.hidden = YES;
		}

		ccCalcController.view.hidden = NO;
		ccCalcController.displayView.hidden = NO;
		self.buttonView.hidden = YES;
	
	} else {
		ccCalcController.view.hidden = YES;
		ccCalcController.displayView.hidden = YES;
		self.buttonView.hidden = NO;
	}

}

- (CGFloat)preferredExpandedContentHeight {
	double preferredExpandedSizeRatio = 525.0 / 321.0;

	if([self isCalcModule])
		return self.preferredExpandedContentWidth * preferredExpandedSizeRatio;
	
	return %orig;
}

- (void)_setupTitleLabel {
	if([self isCalcModule])
		return;

	%orig;
}

%end

%group beforeiOS14
%hook CCUIAppLauncherViewController

%new -(BOOL)isCalcModule {
	return [[MSHookIvar<SBFApplication *>(self, "_application") applicationBundleIdentifier] isEqualToString:@"com.apple.calculator"];
}

%end
%end

%group afteriOS14
%hook CCUIAppLauncherViewController

%new -(BOOL)isCalcModule {
	return [[MSHookIvar<SBFApplication *>(MSHookIvar<CCUIAppLauncherModule *>(self, "_module"), "_application") applicationBundleIdentifier] isEqualToString:@"com.apple.calculator"];
}

%end
%end

%ctor {
	if (class_hasSubIvar("CCUIAppLauncherViewController", "_application")) {
		%init(beforeiOS14);
	} else {
		%init(afteriOS14);
	}
	%init(_ungrouped);
}
