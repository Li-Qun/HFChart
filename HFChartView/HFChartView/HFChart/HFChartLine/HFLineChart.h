//
//  HFLineChart.h
//  SectionDemo
//
//  Created by HF on 2017/7/29.
//  Copyright © 2017年 HF-Liqun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFChartConst.h"

@interface HFLineChart : UIView

@property (strong, nonatomic) NSArray * xLabels; //展示横坐标参数
@property (strong, nonatomic) NSArray * yLabels; //展示纵坐标参数
@property (strong, nonatomic) NSArray * yValues; //纵坐标值
@property (strong, nonatomic) NSArray * colors;  //颜色

@property (strong, nonatomic) NSMutableArray *showHorizonLine;//展示横刻度线
@property (strong, nonatomic) NSMutableArray *showMaxMinArray;//最大最小值集合 布尔值

@property (nonatomic) CGFloat xLabelWidth;//横坐标宽度
@property (nonatomic) CGFloat yValueMin;  //最小y值
@property (nonatomic) CGFloat yValueMax;  //最大y值

@property (nonatomic, assign) CGRange markRange;

@property (nonatomic, assign) CGRange chooseRange;


/**
 画图 描点连线 加阴影
 */
- (void)strokeChart;


- (NSArray *)chartLabelsForX;


@end
