#import "CCCalcPage.h"

@implementation CCCalcPage

- (id)initWithCircleBounds:(CGRect)circleBounds columns:(unsigned int)columns rows:(unsigned int)rows {
    self = [super init];

    if(self) {
        _circleBounds = circleBounds;
        _columns = columns;
        _rows = rows;
    }

    return self;
}

- (float)column:(unsigned int)column {
	return ((double)self.frame.size.width / (double)_columns) * column + ((double)self.frame.size.width / (double)_columns - _circleBounds.size.width)/2.0f;
}

- (float)row:(unsigned int)row {
	return ((double)self.frame.size.height / (double)_rows) * row + ((double)self.frame.size.height / (double)_rows - _circleBounds.size.height)/2.0f;
}

- (CGRect)positionAtColumn:(unsigned int)column row:(unsigned int)row {
	return CGRectMake([self column:column], [self row:row], _circleBounds.size.width, _circleBounds.size.height);
}

- (void)addButton:(UIControl *)button atColumn:(unsigned int)column row:(unsigned int)row {
    [self addSubview:button];
    [button setFrame:[self positionAtColumn:column row:row]];
}

@end