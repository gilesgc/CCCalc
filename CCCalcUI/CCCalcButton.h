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
+ (CGRect)circleBounds;
+ (NSString *)textForButtonID:(unsigned)identifier;
+ (UIImage *)textToImage:(NSString *)text;
- (void)setFrame:(CGRect)frame;
- (void)setImage:(UIImage *)image;
- (void)highlightCircleView:(BOOL)highlight animated:(BOOL)animated;
- (unsigned)character;
@end
