@interface CCCalcPage : UIView {
    CGRect _circleBounds;
    unsigned int _columns;
    unsigned int _rows;
}
- (id)initWithCircleBounds:(CGRect)circleBounds columns:(unsigned int)columns rows:(unsigned int)rows;
- (float)column:(unsigned)column;
- (float)row:(unsigned)row;
- (CGRect)positionAtColumn:(unsigned int)column row:(unsigned int)row;
- (void)addButton:(UIControl *)button atColumn:(unsigned int)column row:(unsigned int)row;
@end