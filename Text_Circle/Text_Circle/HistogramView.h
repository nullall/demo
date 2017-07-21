//
//  HistogramView.h
//  Text_Circle
//
//  Created by Da.W on 2017/7/20.
//  Copyright © 2017年 daw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView
/**图表宽度*/
@property(assign, nonatomic)CGFloat chartWidth;
/**图表宽度*/
@property(assign, nonatomic)CGFloat chartHeight;
/**柱形图宽度*/
@property(assign, nonatomic)CGFloat barWidth;
/**数据字体大小*/
@property(assign, nonatomic)CGFloat dataFontSize;
/**类型字体大小*/
@property(assign, nonatomic)CGFloat dataTypeFontSize;
/**默认颜色*/
@property(strong, nonatomic)UIColor *defaultColor;
/**不同颜色数据*/
@property(strong, nonatomic)NSArray<UIColor *> *colorArray;
/**数据*/
@property(strong, nonatomic)NSArray<NSString *> *dataArray;
/**数据类型*/
@property(strong, nonatomic)NSArray<NSString *> *dataTypeArray;

/**
 *  刷新图表
 */
-(void)reloadView;
@end
