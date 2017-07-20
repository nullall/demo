//
//  DoughnutChartView.h
//  Text_Circle
//
//  Created by Da.W on 2017/7/19.
//  Copyright © 2017年 daw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoughnutChartView : UIView
@property(assign, nonatomic) CGFloat chartDiameter;
@property(assign, nonatomic) CGFloat count1;
@property(assign, nonatomic) CGFloat count2;
@property(assign, nonatomic) CGFloat progressStrokeWidth;   //圆环宽度
@property(strong, nonatomic) UIColor *color1;
@property(strong, nonatomic) UIColor *color2;
-(void)drawChart;
@end
