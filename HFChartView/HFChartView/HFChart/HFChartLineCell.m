//
//  HFChartLineCell.m
//  SectionDemo
//
//  Created by HF on 2017/7/29.
//  Copyright © 2017年 HF-Liqun. All rights reserved.
//

#import "HFChartLineCell.h"
#import "HFChart.h"

NSString *const kHFChartLineCellId = @"kHFChartLineCellId";

@interface HFChartLineCell () <HFChartDataSource>
{
    NSIndexPath *path;
    HFChart *chartView;
    CGFloat screenWidth;
    
}

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation HFChartLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        [self initView];
    }
    return self;
}

- (void)initView
{
    //none
}

- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    // 3 is the number of set yValue gradient ，you can set the number with your data
    chartView = [[HFChart alloc]initWithFrame:CGRectMake(0, 0, screenWidth, HFChartLevelHeight * 3 + HFChartLevelHeight)
                                   dataSource:self
                                        style:HFChartStyleLine];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"12.2%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(HFChart *)chart
{
    return [self getXTitles:7];
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(HFChart *)chart
{
    NSArray *ary = @[@"90",@"30",@"60",@"100",@"90",@"60",@"30",@"30",@"60",@"90"];
    return @[ary];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(HFChart *)chart
{
    return @[[UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]]; //绿色
}
//显示数值范围
- (CGRange)chartRange:(HFChart *)chart
{
    return CGRangeMake(100, 0);
//    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(HFChart *)chart
{
    if (path.row == 2) {
        return CGRangeMake(25, 75);
    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)chart:(HFChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(HFChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return path.row == 2;
}

+ (CGFloat)getHeight
{
    return HFChartLevelHeight * 3 + HFChartLevelHeight;
}

@end
