@interface CCUIAppLauncherViewController : UIViewController
- (UIView *)contentView;
- (UIImage *)glyphImage;
- (BOOL)isCalcModule;
- (UIView *)buttonView;
- (double)headerHeight;
- (double)_footerHeight;
- (CGFloat)preferredExpandedContentWidth;
- (CGFloat)preferredExpandedContentHeight;
@end

@interface SBFApplication : NSObject
- (NSString *)applicationBundleIdentifier;
@end

@interface CCUIAppLauncherModule : NSObject
@end
