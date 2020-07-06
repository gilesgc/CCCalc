@interface CCCalcFunction : NSObject

+ (NSDictionary<NSNumber *, CCCalcFunction *> *)functions;
+ (UIImage *)imageFromBundle:(NSString *)imageName;
- (double)evaluateWithInput:(double)input;
- (UIImage *)image;

@end

typedef enum {
    Radians, Degrees
} TrigUnits;

@interface Sine : CCCalcFunction
@end

@interface Cosine : CCCalcFunction
@end

@interface Tangent : CCCalcFunction
@end

@interface Reciprocal : CCCalcFunction
@end

@interface SquareRoot : CCCalcFunction
@end

@interface CubeRoot : CCCalcFunction
@end

@interface Square : CCCalcFunction
@end

@interface Cube : CCCalcFunction
@end

@interface Logarithm : CCCalcFunction
@end

@interface NaturalLogarithm : CCCalcFunction
@end

@interface EulersNumber : CCCalcFunction
@end

@interface Pi : CCCalcFunction
@end

@interface Exponential : CCCalcFunction
@end

@interface TenRaisedToX : CCCalcFunction
@end

@interface InverseSine : CCCalcFunction
@end

@interface InverseCosine : CCCalcFunction
@end

@interface InverseTangent : CCCalcFunction
@end

@interface Random : CCCalcFunction
@end

@interface TrigUnitsSwitcher : CCCalcFunction
@end