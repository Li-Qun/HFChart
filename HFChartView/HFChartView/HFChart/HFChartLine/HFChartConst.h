//
//  HFChartConst.h
//  SectionDemo
//
//  Created by HF on 2017/7/29.
//  Copyright © 2017年 HF-Liqun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define chartMargin         10
#define xLabelMargin        15
#define yLabelMargin        15
#define UULabelHeight       10
#define UUYLabelwidth       30
#define UUTagLabelwidth     80
#define HFChartLevelHeight  45
#define kSCreenScale  [UIScreen mainScreen].scale

//范围
struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange
CGRangeMake(CGFloat max, CGFloat min){
    CGRange p;
    p.max = max;
    p.min = min;
    return p;
}

static const CGRange CGRangeZero = {0,0};

@interface  HFChartConst : NSObject

+ (UIColor *)green;

@end
