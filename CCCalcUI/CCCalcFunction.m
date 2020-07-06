#import "CCCalcFunction.h"
#import "CCCalcButtons.h"

static NSBundle *bundle;
static TrigUnits trigUnits = Radians;

@implementation CCCalcFunction

static NSDictionary<NSNumber *, CCCalcFunction *> *_functions;

+ (void)initialize {
    bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.gilesgc.cccalc.bundle"];
    _functions = @{
        @(BTN_SINE): [[Sine alloc] init],
        @(BTN_COSINE): [[Cosine alloc] init],
        @(BTN_TANGENT): [[Tangent alloc] init],
        @(BTN_RECIPROCAL): [[Reciprocal alloc] init],
        @(BTN_SQUARE): [[Square alloc] init],
        @(BTN_CUBE): [[Cube alloc] init],
        @(BTN_SQUAREROOT): [[SquareRoot alloc] init],
        @(BTN_CUBEROOT): [[CubeRoot alloc] init],
        @(BTN_LOGARITHM): [[Logarithm alloc] init],
        @(BTN_NATURALLOGARITHM): [[NaturalLogarithm alloc] init],
        @(BTN_EULERSNUMBER): [[EulersNumber alloc] init],
        @(BTN_PI): [[Pi alloc] init],
        @(BTN_EXPONENTIAL): [[Exponential alloc] init],
        @(BTN_TENRAISEDTOX): [[TenRaisedToX alloc] init],
        @(BTN_INVERSESINE): [[InverseSine alloc] init],
        @(BTN_INVERSECOSINE): [[InverseCosine alloc] init],
        @(BTN_INVERSETANGENT): [[InverseTangent alloc] init],
        @(BTN_TRIGUNITSSWITCHER): [[TrigUnitsSwitcher alloc] init],
        @(BTN_RANDOM): [[Random alloc] init]
    };
}

+ (NSDictionary<NSNumber *, CCCalcFunction *> *)functions {
    return _functions;
}

- (double)evaluateWithInput:(double)input {
    NSLog(@"[CCCalc] evaluateWithInput requires override");
    return 0;
}
- (UIImage *)image {
    NSLog(@"[CCCalc] image requires override");
    return nil;
}

+ (UIImage *)imageFromBundle:(NSString *)imageName {
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:@"png"]];
    if(image)
        return image;

    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0,0,75,75)];
	[text setTextColor:[UIColor whiteColor]];
	[text setFont:[UIFont boldSystemFontOfSize:18]];
	[text setTextAlignment:NSTextAlignmentCenter];

	[text setText:imageName];

    if([imageName isEqualToString:@"random"])
        text.text = @"Rand";
    else if([imageName isEqualToString:@"radians"])
        text.text = @"Rad";
    else if([imageName isEqualToString:@"degrees"])
        text.text = @"Deg";

	return [text performSelector:@selector(_image)];
}

@end

double degreesToRadians(double deg) {
    return deg * M_PI / 180.0f;
}
double radiansToDegrees(double rad) {
    return rad * 180.0f / M_PI;
}

@implementation Sine
- (double)evaluateWithInput:(double)input {
    double output;
    if(trigUnits == Degrees)
        output = sin(degreesToRadians(input));
    else
        output = sin(input);

    if(fabs(output) < 0.00000001)
        return 0;
    else
        return output;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"sine"];
}
@end

@implementation Cosine
- (double)evaluateWithInput:(double)input {
    double output;
    if(trigUnits == Degrees)
        output = cos(degreesToRadians(input));
    else
        output = cos(input);

    if(fabs(output) < 0.00000001)
        return 0;
    else
        return output;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"cosine"];
}
@end

@implementation Tangent
- (double)evaluateWithInput:(double)input {
    double output;
    if(trigUnits == Degrees)
        output = tan(degreesToRadians(input));
    else
        output = tan(input);

    if(fabs(output) < 0.00000001)
        return 0;
    else
        return output;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"tangent"];
}
@end

@implementation Reciprocal
- (double)evaluateWithInput:(double)input {
    return 1.0f/input;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"reciprocal"];
}
@end

@implementation SquareRoot
- (double)evaluateWithInput:(double)input {
    return sqrt(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"squareroot"];
}
@end

@implementation CubeRoot
- (double)evaluateWithInput:(double)input {
    return pow(input, 1.0/3.0);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"cuberoot"];
}
@end

@implementation Square
- (double)evaluateWithInput:(double)input {
    return pow(input, 2);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"square"];
}
@end

@implementation Cube
- (double)evaluateWithInput:(double)input {
    return pow(input, 3);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"cube"];
}
@end

@implementation Logarithm
- (double)evaluateWithInput:(double)input {
    return log10(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"logarithm"];
}
@end

@implementation NaturalLogarithm
- (double)evaluateWithInput:(double)input {
    return log(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"naturallogarithm"];
}
@end

@implementation EulersNumber
- (double)evaluateWithInput:(double)input {
    return M_E;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"eulersnumber"];
}
@end

@implementation Pi
- (double)evaluateWithInput:(double)input {
    return M_PI;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"pi"];
}
@end

@implementation Exponential
- (double)evaluateWithInput:(double)input {
    return exp(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"exponential"];
}
@end

@implementation TenRaisedToX
- (double)evaluateWithInput:(double)input {
    return pow(10, input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"tenraisedtox"];
}
@end

@implementation InverseSine
- (double)evaluateWithInput:(double)input {
    if(trigUnits == Degrees)
        return radiansToDegrees(asin(input));
    else
        return asin(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"inversesine"];
}
@end

@implementation InverseCosine
- (double)evaluateWithInput:(double)input {
    if(trigUnits == Degrees)
        return radiansToDegrees(acos(input));
    else
        return acos(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"inversecosine"];
}
@end

@implementation InverseTangent
- (double)evaluateWithInput:(double)input {
    if(trigUnits == Degrees)
        return radiansToDegrees(atan(input));
    else
        return atan(input);
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"inversetangent"];
}
@end

@implementation TrigUnitsSwitcher
- (double)evaluateWithInput:(double)input {
    trigUnits = trigUnits == Radians ? Degrees : Radians;
    return 0;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:(trigUnits == Radians ? @"radians" : @"degrees")];
}
@end

@implementation Random
- (double)evaluateWithInput:(double)input {
    return (double)arc4random() / UINT32_MAX;
}
- (UIImage *)image {
    return [CCCalcFunction imageFromBundle:@"random"];
}
@end