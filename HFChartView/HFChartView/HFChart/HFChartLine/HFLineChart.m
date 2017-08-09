//
//  HFLineChart.m
//  SectionDemo
//
//  Created by HF on 2017/7/29.
//  Copyright © 2017年 HF-Liqun. All rights reserved.
//

#import "HFLineChart.h"

@interface HFLineChart ()

@property (nonatomic, strong) UIView *theView;//渐变色背景板
@property (strong, nonatomic) CAGradientLayer *gradientLayer;//设置渐变颜色
@property (strong, nonatomic) NSMutableArray *pointArray; //点的坐标集合

@end

@implementation HFLineChart {
    NSHashTable *_chartLabelsForX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self setBackgroundMask];
    }
    return self;
}

#pragma mark - delegate


#pragma mark -instance

- (void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 1.0; //设置线的粗细
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (15 + _xLabelWidth / 2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight * 3;
        
        float grade = ((float)firstValue - _yValueMin) / ((float)_yValueMax - _yValueMin);
        
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.showMaxMinArray) {
            if ([self.showMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight + UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];
        
        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight + UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.showMaxMinArray) {
                    if ([self.showMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
            }
            index += 1;
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [HFChartConst green].CGColor;
        }
        
        //隐藏连线效果
        /*
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count * 0.4;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        */
        _chartLine.strokeEnd = 1.0;
    }
    [self setShaddow];
}

/**
 给坐标位置添加圆形实心点图标

 @param point 坐标
 @param index 索引
 @param isHollow 是否是空心 表示极值情况
 @param value 值
 */
- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    if (!self.pointArray) {
        self.pointArray = [NSMutableArray array];
    }
    NSArray *arr = [NSArray arrayWithObjects:@(point.x),@(point.y), nil];
    [self.pointArray addObject:arr];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0 , 5, 5)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 2.5;
    view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:[HFChartConst green];
    
    // 该点对应的值
    /*
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = view.backgroundColor;
    label.text = [NSString stringWithFormat:@"%d",(int)value];
    [self addSubview:label];
     */
    
    [self addSubview:view];
}

- (void)setShaddow
{
    //给渐变层设置 mask 属性
    {
        // 设置只显示一个三角形范围的渐变色
        UIBezierPath *shapeLayerPath = [[UIBezierPath alloc] init];
        // 点的坐标是相对于渐变层的
        [shapeLayerPath moveToPoint:CGPointMake(0,self.frame.size.height)];
        for (int i = 0; i < self.pointArray.count;i ++) {
            NSArray *arr = self.pointArray[i];
            NSInteger x = [arr[0]integerValue];
            NSInteger y = [arr[1]integerValue];
            [shapeLayerPath addLineToPoint:CGPointMake(x, y)];
        }
        
        [shapeLayerPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = shapeLayerPath.CGPath;
        
        self.gradientLayer.mask = shapeLayer;
    }
}

#pragma mark - private

- (void)setBackgroundMask
{
    [self addSubview:self.theView];
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.theView.bounds;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.theView.layer addSublayer:self.gradientLayer];
    //设置颜色数组
    self.backgroundColor = [UIColor clearColor];
    
    CGColorRef color1 = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:0.4].CGColor;
    CGColorRef color2 = [UIColor colorWithRed:0 green:0.7 blue:0 alpha:0].CGColor;
    [_gradientLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.0f), @(0.8f)];
}

#pragma mark - settet getter

#pragma mark -- settet

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

- (void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    NSInteger min = 1000000000;
    
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            NSInteger value = [valueString integerValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    max = max<5 ? 5:max;
    _yValueMin = 0;
    _yValueMax = (int)max;
    
    if (_chooseRange.max != _chooseRange.min) {
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    }
    CGFloat levelHeight = HFChartLevelHeight;
    //画横线
    NSInteger horizonLineCount = self.showHorizonLine.count;
    for (int i = 1; i < horizonLineCount; i++) {
        if ([_showHorizonLine[i] integerValue] > 0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0,i * levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,i * levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor darkGrayColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1.f / kSCreenScale;
            [self.layer addSublayer:shapeLayer];
        }
    }
}

- (void)setXLabels:(NSArray *)xLabels
{
    if( !_chartLabelsForX ){
        _chartLabelsForX = [NSHashTable weakObjectsHashTable];
    }
    
    _xLabels = xLabels;
    CGFloat num = 0;
    if (xLabels.count>=20) {
        num=20.0;
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - xLabelMargin * 2) / num;
    
    //横坐标名称
    CGFloat leftPadding = xLabelMargin;
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        UILabel * label = [self getChartLineLabel];
        label.frame = CGRectMake(i * _xLabelWidth + leftPadding, self.frame.size.height - HFChartLevelHeight, _xLabelWidth, HFChartLevelHeight);
        label.text = labelText;
        [self addSubview:label];

        [_chartLabelsForX addObject:label];
    }
}

- (void)setColors:(NSArray *)colors
{
    _colors = colors;
}

- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}

- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}

- (void)setshowHorizonLine:(NSMutableArray *)showHorizonLine
{
    _showHorizonLine = showHorizonLine;
}

#pragma mark -- getter

- (UIView *)theView
{
    if (!_theView) {
        _theView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _theView;
}

- (NSArray *)chartLabelsForX
{
    return [_chartLabelsForX allObjects];
}

- (UILabel *)getChartLineLabel
{
    UILabel *label = [UILabel new];
    // Initialization code
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setMinimumScaleFactor:5.0f];
    [label setNumberOfLines:1];
    [label setFont:[UIFont systemFontOfSize:13]];//5s 以下是 9  之上应该是 13
    [label setTextColor: [UIColor darkGrayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = YES;
    return label;
}

@end
