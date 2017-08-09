//
//  HFChart.h
//  SectionDemo
//
//  Created by HF on 2017/7/29.
//  Copyright © 2017年 HF-Liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFChartConst.h"


typedef NS_ENUM(NSInteger, HFChartStyle){
    HFChartStyleLine = 0 //目前就一种折线统计图
};

@class HFChart;
@protocol HFChartDataSource <NSObject>

@required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(HFChart *)chart;

//数值多重数组
- (NSArray *)chartConfigAxisYValue:(HFChart *)chart;

@optional
//颜色数组
- (NSArray *)chartConfigColors:(HFChart *)chart;

//显示数值范围
- (CGRange)chartRange:(HFChart *)chart;

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)chartHighlightRangeInLine:(HFChart *)chart;

//判断显示横线条
- (BOOL)chart:(HFChart *)chart showHorizonLineAtIndex:(NSInteger)index;

//判断显示最大最小值
- (BOOL)chart:(HFChart *)chart showMaxMinAtIndex:(NSInteger)index;
@end



@interface HFChart : UIView

@property (nonatomic) HFChartStyle chartStyle;

- (id)initWithFrame:(CGRect)rect dataSource:(id<HFChartDataSource>)dataSource style:(HFChartStyle)style;

- (void)showInView:(UIView *)view;

- (void)strokeChart;

@end
