@interface TPNumberPadDarkStyleButton : UIControl
-(id)initForCharacter:(unsigned)arg1;
-(id)subviews;
+(CGRect)circleBounds;
-(unsigned int)character;
@end

@protocol CCCalcDelegate <NSObject>
@required
- (void)buttonTapped:(unsigned)identifier;
@end

@interface CCCalcButton : TPNumberPadDarkStyleButton
@property (nonatomic, retain) id<CCCalcDelegate> delegate;
@property (nonatomic) BOOL shouldStayHighlighted;
+ (id)imageForCharacter:(unsigned)character;
- (void)setFrame:(CGRect)arg1;
+ (CGRect)circleBounds;
+ (NSString *)textForButtonID:(unsigned)identifier;
- (unsigned)character;
@end
