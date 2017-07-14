//
//  CircleView.m
//  Text_Circle
//
//  Created by Da.W on 16/9/3.
//  Copyright © 2016年 daw. All rights reserved.
//

#import "CircleView.h"
@interface CircleView()
{
    
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;      //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    
    CGPoint circleCenter;//中心坐标
    CGFloat diam;//直径
    
    UILabel *perLabel;//放百分号的label
    UIImageView *imageView;//100%的时候显示图片的imageView
}
@end

@implementation CircleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
    }
    return self;
    
}

/**
 *  初始化创建图层
 */
- (void)setUp
{
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;
    backGroundLayer.frame = self.bounds;
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = nil;
    frontFillLayer.frame = self.bounds;
    
    //中心点的位置
    circleCenter.x=self.bounds.size.width/2;
    circleCenter.y=self.bounds.size.height/2;
    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:frontFillLayer];

    diam=(CGRectGetWidth(self.bounds)<CGRectGetHeight(self.bounds)?CGRectGetWidth(self.bounds):CGRectGetHeight(self.bounds));
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self initViews];
}

-(void)initViews{
    //圆环宽度
    frontFillLayer.lineWidth = _progressStrokeWidth;
    backGroundLayer.lineWidth = _progressStrokeWidth;
    
    //底部圆环设置
    backGroundLayer.strokeColor = _progressTrackColor.CGColor;
    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(diam-self.progressStrokeWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
    backGroundLayer.path = backGroundBezierPath.CGPath;
    
    //进度条圆环设置
    frontFillLayer.strokeColor = _progressColor.CGColor;
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(diam-self.progressStrokeWidth)/2.f startAngle:-M_PI endAngle:(2*M_PI)*_progressValue-M_PI clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
    
    //动画效果
    CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue=[NSNumber numberWithDouble:0];
    endAni.toValue=[NSNumber numberWithDouble:1];
    //    endAni.duration=1.5;
    [frontFillLayer addAnimation:endAni forKey:nil];
    
    //字体大小
    if (!_fontsize) {
        _fontsize=diam*3/10;
    }
    //创建百分比的label
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.label.textAlignment=NSTextAlignmentCenter;
    self.label.font=[UIFont systemFontOfSize:_fontsize];
    
    //放百分号的label
    perLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    perLabel.font=[UIFont systemFontOfSize:_fontsize/2];
    perLabel.text=@"%";
    
    [self addSubview:_label];
    [self addSubview:perLabel];
    
    //图片的位置设置
    if (_imagesize.width) {
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(circleCenter.x-_imagesize.width/2, circleCenter.y-_imagesize.height/2, _imagesize.width, _imagesize.height)];
    }else{
        CGFloat wh=diam/5;
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(circleCenter.x-wh, circleCenter.y-wh, wh*2, wh*2)];
    }
    if (_image) {
        imageView.image=_image;
    }
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.hidden=YES;
    
    if (_progressValue==1.0f&&_image) {
        imageView.tintColor=_progressColor;//修改图片颜色，要将图片的“Render As”属性设置为“Template Image”才可行。7.0无效
        imageView.hidden=NO;
    }else{
        //设置百分比的数值、百分号及其显示的位置
        NSString *value=[[NSString alloc]initWithFormat:@"%.0f",_progressValue*100];
        CGSize labelsize=[value sizeWithAttributes:@{NSFontAttributeName:_label.font}];
        CGSize persize= [perLabel.text sizeWithAttributes:@{NSFontAttributeName:perLabel.font}];
        [self.label setFrame:CGRectMake(circleCenter.x-labelsize.width/2-persize.width/2, circleCenter.y-labelsize.height/2, labelsize.width, labelsize.height)];
        self.label.text=value;
        CGRect perFrame=_label.frame;
        perFrame.origin.x=perFrame.origin.x+perFrame.size.width;
        perFrame.origin.y=perFrame.origin.y+perFrame.size.height-persize.height-persize.height/3;
        perFrame.size=persize;
        [perLabel setFrame:perFrame];
    }
}

//
//- (void)setProgressColor:(UIColor *)progressColor{
//    _progressColor = progressColor;
//    frontFillLayer.strokeColor = progressColor.CGColor;
//}
//
//- (void)setProgressTrackColor:(UIColor *)progressTrackColor{
//    _progressTrackColor = progressTrackColor;
//    backGroundLayer.strokeColor = progressTrackColor.CGColor;
//    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(diam-self.progressStrokeWidth)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
//    backGroundLayer.path = backGroundBezierPath.CGPath;
//}

- (void)setProgressValue:(CGFloat)progressValue{
    if (progressValue>1) {
        _progressValue=1.0f;
    }else{
        _progressValue = progressValue;
    }
//    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:(diam-self.progressStrokeWidth)/2.f startAngle:-M_PI endAngle:(2*M_PI)*progressValue-M_PI clockwise:YES];
//    frontFillLayer.path = frontFillBezierPath.CGPath;
//
//    //动画效果
//    CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    endAni.fromValue=[NSNumber numberWithDouble:0];
//    endAni.toValue=[NSNumber numberWithDouble:1];
////    endAni.duration=1.5;
//    [frontFillLayer addAnimation:endAni forKey:nil];
}
//
//- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth{
//    _progressStrokeWidth = progressStrokeWidth;
//    frontFillLayer.lineWidth = progressStrokeWidth;
//    backGroundLayer.lineWidth = progressStrokeWidth;
//}

@end
