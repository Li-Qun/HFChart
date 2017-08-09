//
//  HFChart.m
//  SectionDemo
//
//  Created by HF on 2017/7/29.
//  Copyright © 2017年 HF-Liqun. All rights reserved.
//

#import "HFChart.h"
#import "HFLineChart.h"

@interface HFChart ()

@property (strong, nonatomic) HFLineChart * lineChart; 
@property (assign, nonatomic) id<HFChartDataSource> dataSource;

@end

@implementation HFChart

- (id)initWithFrame:(CGRect)rect dataSource:(id<HFChartDataSource>)dataSource style:(HFChartStyle)style
{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}

#pragma mark - delegate


#pragma mark -instance

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
    [self setUpChart];
}

#pragma mark - private

-(void)setUpChart{
    if (self.chartStyle == HFChartStyleLine) {
        [self addSubview:self.lineChart];
        //选择标记范围
        if ([self.dataSource respondsToSelector:@selector(chartHighlightRangeInLine:)]) {
            [self.lineChart setMarkRange:[self.dataSource chartHighlightRangeInLine:self]];
        }
        //选择显示范围
        if ([self.dataSource respondsToSelector:@selector(chartRange:)]) {
            [self.lineChart setChooseRange:[self.dataSource chartRange:self]];
        }
        //显示颜色
        if ([self.dataSource respondsToSelector:@selector(chartConfigColors:)]) {
            [self.lineChart setColors:[self.dataSource chartConfigColors:self]];
        }
        //显示横线
        if ([self.dataSource respondsToSelector:@selector(chart:showHorizonLineAtIndex:)]) {
            NSMutableArray *showHorizonArray = [[NSMutableArray alloc]init];
            NSInteger count = self.frame.size.height / HFChartLevelHeight; // 横线间隔设定默认值为45
            for (int i = 0; i < count ; i ++) {
                if ([self.dataSource chart:self showHorizonLineAtIndex:i]) {
                    [showHorizonArray addObject:@"1"];
                }else{
                    [showHorizonArray addObject:@"0"];
                }
            }
            [self.lineChart setShowHorizonLine:showHorizonArray];
            
        }
        //判断显示最大最小值
        if ([self.dataSource respondsToSelector:@selector(chart:showMaxMinAtIndex:)]) {
            NSMutableArray *showMaxMinArray = [[NSMutableArray alloc]init];
            NSArray *y_values = [self.dataSource chartConfigAxisYValue:self];
            if (y_values.count > 0 ){
                for (int i=0; i<y_values.count; i++) {
                    if ([self.dataSource chart:self showMaxMinAtIndex:i]) {
                        [showMaxMinArray addObject:@"1"];
                    }else{
                        [showMaxMinArray addObject:@"0"];
                    }
                }
                self.lineChart.showMaxMinArray = showMaxMinArray;
            }
        }
        
        [self.lineChart setYValues:[self.dataSource chartConfigAxisYValue:self]];
        [self.lineChart setXLabels:[self.dataSource chartConfigAxisXLabel:self]];
        
        [self.lineChart strokeChart];
    }
}


#pragma mark - settet getter

- (HFLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart = [[HFLineChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _lineChart;
}

@end
