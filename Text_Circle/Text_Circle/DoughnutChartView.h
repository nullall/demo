//
//  DoughnutChartView.h
//  Text_Circle
//
//  Created by Da.W on 2017/7/19.
//  Copyright © 2017年 daw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoughnutChartView : UIView
/**圆形直径*/
@property(assign, nonatomic) CGFloat chartDiameter;
/**圆环宽度*/
@property(assign, nonatomic) CGFloat progressStrokeWidth;
/**数据*/
@property(assign, nonatomic) CGFloat count1;
@property(assign, nonatomic) CGFloat count2;
/**颜色*/
@property(strong, nonatomic) UIColor *color1;
@property(strong, nonatomic) UIColor *color2;
/**数据类型*/
@property(strong, nonatomic) NSString *type1;
@property(strong, nonatomic) NSString *type2;
/**
 *  刷新图表
 */
-(void)reloadView;
@end
