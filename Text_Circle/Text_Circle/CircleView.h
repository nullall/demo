//
//  CircleView.h
//  Text_Circle
//
//  Created by Da.W on 16/9/3.
//  Copyright © 2016年 daw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat progressValue;

/**
 *  边宽
 */
@property(nonatomic,assign) CGFloat progressStrokeWidth;

/**
 *  进度条颜色
 */
@property(nonatomic,strong)UIColor *progressColor;

/**
 *  进度条轨道颜色
 */
@property(nonatomic,strong)UIColor *progressTrackColor;
/**
 *  百分比
 */
@property(nonatomic,strong)UILabel *label;
/**
 *  字体大小
 */
@property(nonatomic,assign)CGFloat fontsize;
/**
 *  100%的时候显示的图片
 */
@property(nonatomic,strong)UIImage *image;
/**
 *  图片大小
 */
@property(nonatomic,assign)CGSize imagesize;
@end
