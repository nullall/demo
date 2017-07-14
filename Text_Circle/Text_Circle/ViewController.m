//
//  ViewController.m
//  Text_Circle
//
//  Created by Da.W on 16/9/3.
//  Copyright © 2016年 daw. All rights reserved.
//参考：http://www.cnblogs.com/thbbsky/p/4516726.html

#import "ViewController.h"
#import "CircleView.h"
@interface ViewController ()
{
    CircleView *progressView;
    CircleView *progressView2;
    
    UIButton *btn;
}
@property (weak, nonatomic) IBOutlet CircleView *circleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    progressView = [[CircleView alloc]initWithFrame:CGRectMake(40,80, 150, 100)];
//    progressView.progressColor = [UIColor colorWithRed:0.00 green:0.73 blue:0.61 alpha:1.00];
    progressView.progressColor = [UIColor colorWithRed:0.40 green:0.80 blue:0.80 alpha:1.00];
    progressView.progressStrokeWidth = 10.f;
    progressView.progressTrackColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    progressView.progressValue=1.0f;
//    progressView.fontsize=30;
    progressView.image=[UIImage imageNamed:@"complete"];
//    progressView.imagesize=CGSizeMake(40, 40);
    [self.view addSubview:progressView];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(80, 220, 80, 35)];
    btn.backgroundColor=[UIColor colorWithRed:1.00 green:0.40 blue:0.40 alpha:1.00];
    [btn setTitle:@"reload" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
     
    
//    self.circleView = [[CircleView alloc]initWithFrame:CGRectMake(40,80, 150, 100)];
    self.circleView.progressColor = [UIColor colorWithRed:0.40 green:0.80 blue:0.80 alpha:1.00];
    self.circleView.progressStrokeWidth = 5.f;
    self.circleView.progressTrackColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    self.circleView.progressValue=0.3f;
    self.circleView.image=[UIImage imageNamed:@"complete"];
    
    [self initAnnulus];
}

-(void)reloadAction:(id)sender{
    [progressView removeFromSuperview];
    progressView = [[CircleView alloc]initWithFrame:CGRectMake(40,80, 150, 100)];
    progressView.progressColor = [UIColor colorWithRed:0.40 green:0.80 blue:0.80 alpha:1.00];
    progressView.progressStrokeWidth = 10.f;
    progressView.progressTrackColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.00];
    progressView.progressValue=(arc4random()%100+1)/100.f;
    progressView.image=[UIImage imageNamed:@"complete"];
    [self.view addSubview:progressView];
    NSLog(@"%f",progressView.progressValue);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAnnulus{
    CAShapeLayer *succeedLayer;     //成功次数的图层
    CAShapeLayer *failedLayer;      //失败次数的图层
    UIBezierPath *succeedBezierPath; //成功次数贝赛尔曲线
    UIBezierPath *failedBezierPath;  //失败次数的贝赛尔曲线
    UIColor *succeedColor=[UIColor colorWithRed:187/255.0 green:45/255.0 blue:42/255.0 alpha:1];
    UIColor *failedColor=[UIColor colorWithRed:255/255.0 green:185/255.0 blue:46/255.0 alpha:1];
    CGPoint circleCenter;//中心坐标
    CGFloat diam;//直径
    CGFloat radius;//内环半径
    CGFloat progressStrokeWidth=25;//圆环宽度
    CGFloat succeedTime=5;
    CGFloat failedTime=9;
    CGFloat succeedValue=succeedTime/(succeedTime+failedTime);
    CGFloat failedValue=failedTime/(succeedTime+failedTime);
    
    if (succeedTime==0&&failedTime==0) {
        succeedValue=0.5;
        failedValue=0.5;
    }
    
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(80, 300, 160, 160)];
    [self.view addSubview:view];
//    view.backgroundColor=[UIColor blueColor];
    
    succeedLayer=[CAShapeLayer layer];
    succeedLayer.fillColor=nil;
    succeedLayer.frame=view.bounds;
    succeedLayer.lineWidth=progressStrokeWidth;
    succeedLayer.strokeColor=succeedColor.CGColor;
    failedLayer=[CAShapeLayer layer];
    failedLayer.fillColor=nil;
    failedLayer.frame=view.bounds;
    failedLayer.lineWidth=progressStrokeWidth;
    failedLayer.strokeColor=failedColor.CGColor;
    
    //中心点的位置
    circleCenter.x=view.bounds.size.width/2;
    circleCenter.y=view.bounds.size.height/2;
    
    [view.layer addSublayer:succeedLayer];
    [view.layer addSublayer:failedLayer];
    
    diam=(CGRectGetWidth(view.bounds)<CGRectGetHeight(view.bounds)?CGRectGetWidth(view.bounds):CGRectGetHeight(view.bounds));
    radius=(diam-progressStrokeWidth)/2.f;

    //0.01是为了留一点点白色的空隙
    if (succeedValue!=0&&failedValue!=0) {
        succeedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:(2*M_PI)*failedValue-M_PI_4 endAngle:-M_PI_4-0.01 clockwise:YES];
        succeedLayer.path=succeedBezierPath.CGPath;
        failedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:-M_PI_4 endAngle:(2*M_PI)*failedValue-M_PI_4-0.01 clockwise:YES];
        failedLayer.path=failedBezierPath.CGPath;
    }else if (succeedValue==0){
        failedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        failedLayer.path=failedBezierPath.CGPath;
    }else if (failedValue==0){
        succeedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        succeedLayer.path=succeedBezierPath.CGPath;
    }
    
    //动画效果
    CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue=[NSNumber numberWithDouble:0];
    endAni.toValue=[NSNumber numberWithDouble:1];
    //    endAni.duration=1.5;
    [succeedLayer addAnimation:endAni forKey:nil];
    [failedLayer addAnimation:endAni forKey:nil];
    
    //数字label
    
    UILabel *succeedLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    UILabel *failedLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    failedLabel.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    failedLabel.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    
    
    succeedLabel.text=[NSString stringWithFormat:@"%d次",(int)succeedTime];
    succeedLabel.font=[UIFont systemFontOfSize:12];
    succeedLabel.textAlignment=UITextAlignmentCenter;
    succeedLabel.textColor=succeedColor;
    
    NSDictionary *sdic=[NSDictionary dictionaryWithObjectsAndKeys:succeedLabel.font,NSFontAttributeName, nil];
    CGSize size=CGSizeMake(0, 15);
    CGFloat sWidth=[succeedLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sdic context:nil].size.width+5;
    CGFloat sHypot=hypotf(sWidth, 12);
//    radius=(diam-progressStrokeWidth)/2.f-sHypot;
    CGFloat sX,sY;
    if (cosf(M_PI*failedValue-M_PI_4/2)>0) {
        sX=circleCenter.x-(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }else{
        sX=circleCenter.x-(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }
    if (sinf(M_PI*failedValue-M_PI_4/2)>0) {
        sY=circleCenter.y-(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }else{
        sY=circleCenter.y-(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }
    [succeedLabel setFrame:CGRectMake(0, 0, sWidth, 15)];
    succeedLabel.center=CGPointMake(sX, sY);
    
    
    failedLabel.text=[NSString stringWithFormat:@"%d次",(int)failedTime];
    failedLabel.font=[UIFont systemFontOfSize:12];
    failedLabel.textAlignment=UITextAlignmentCenter;
//    failedLabel.backgroundColor=[UIColor grayColor];
    failedLabel.textColor=failedColor;
    NSDictionary *fdic=[NSDictionary dictionaryWithObjectsAndKeys:succeedLabel.font,NSFontAttributeName, nil];
    CGFloat fWidth=[failedLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:fdic context:nil].size.width+5;
    CGFloat fHypot=hypotf(fWidth, 12);
//    radius=(diam-progressStrokeWidth)/2.f-fHypot;
    [failedLabel setFrame:CGRectMake(0, 0, fWidth, 15)];
    CGFloat fX,fY;
    if (cosf(M_PI*failedValue-M_PI_4/2)>0) {
        fX=circleCenter.x+(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }else{
        fX=circleCenter.x+(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }
    if (sinf(M_PI*failedValue-M_PI_4/2)>0) {
        fY=circleCenter.y+(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }else{
        fY=circleCenter.y+(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }
//    fX=circleCenter.x+radius*cosf(M_PI*failedValue-M_PI_4);
//    fY=circleCenter.y+radius*sinf(M_PI*failedValue-M_PI_4);
    failedLabel.center=CGPointMake(fX, fY);
    
    NSLog(@"\n X:(radius-progressStrokeWidth/2)*cosf(M_PI*failedValue-M_PI_4/2)=%f \n Y:(radius-progressStrokeWidth/2)*sinf(M_PI*failedValue-M_PI_4/2)=%f",(radius-progressStrokeWidth/2)*cosf(M_PI*failedValue-M_PI_4/2),(radius-progressStrokeWidth/2)*sinf(M_PI*failedValue-M_PI_4/2));
    NSLog(@"\n fX:%f \n fY:%f",fX,fY);

    //考虑下0的时候的情况-另外讨论
    
    [view addSubview:succeedLabel];
    [view addSubview:failedLabel];
    
}


#pragma mark - 饼状图
/**
 *  根据成功失败次数绘制饼状图
 *
 *  @param succeedTime 成功次数
 *  @param failedTime  失败次数
 *
 *  @return 绘制好的图
 */
-(UIView*)getPieChartSucceedTime:(CGFloat)succeedTime FailedTime:(CGFloat)failedTime{
    CAShapeLayer *succeedLayer;     //成功次数的图层
    CAShapeLayer *failedLayer;      //失败次数的图层
    UIBezierPath *succeedBezierPath; //成功次数贝赛尔曲线
    UIBezierPath *failedBezierPath;  //失败次数的贝赛尔曲线
    UIColor *succeedColor=[UIColor colorWithRed:187/255.0 green:45/255.0 blue:42/255.0 alpha:1];
    UIColor *failedColor=[UIColor colorWithRed:255/255.0 green:185/255.0 blue:46/255.0 alpha:1];
    CGPoint circleCenter;//中心坐标
    CGFloat labelHeight=13;//文本框高度
    CGFloat diam;//直径
    CGFloat radius;//内环半径
    CGFloat progressStrokeWidth=25;//圆环宽度
    CGFloat succeedValue=succeedTime/(succeedTime+failedTime);
    CGFloat failedValue=failedTime/(succeedTime+failedTime);
    if (succeedTime==0&&failedTime==0) {
        return nil;
        //        succeedValue=0.5;
        //        failedValue=0.5;
    }
    NSLog(@"成功次数：%f，失败次数：%f",failedTime,failedTime);
    NSLog(@"成功率：%f，失败率：%f",succeedValue,failedValue);
    
    if ([UIScreen mainScreen].bounds.size.width<=320) {
        progressStrokeWidth=20;
    }
    
//    CGFloat minLength = MIN(self.areaPieView.width, self.areaPieView.height);   //取长宽最小值
    CGFloat minLength = 200;   //取长宽最小值
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, minLength, minLength)];
    
    succeedLayer=[CAShapeLayer layer];
    succeedLayer.fillColor=nil;
    succeedLayer.frame=view.bounds;
    succeedLayer.lineWidth=progressStrokeWidth;
    succeedLayer.strokeColor=succeedColor.CGColor;
    failedLayer=[CAShapeLayer layer];
    failedLayer.fillColor=nil;
    failedLayer.frame=view.bounds;
    failedLayer.lineWidth=progressStrokeWidth;
    failedLayer.strokeColor=failedColor.CGColor;
    
    //中心点的位置
    circleCenter.x=view.bounds.size.width/2;
    circleCenter.y=view.bounds.size.height/2;
    
    [view.layer addSublayer:succeedLayer];
    [view.layer addSublayer:failedLayer];
    
    diam = minLength;
    //    diam = MIN(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    //    diam=(CGRectGetWidth(view.bounds)<CGRectGetHeight(view.bounds)?CGRectGetWidth(view.bounds):CGRectGetHeight(view.bounds));
    radius=(diam-progressStrokeWidth)/2.f;
    
    //0.01是为了留一点点白色的空隙
    if (succeedValue!=0&&failedValue!=0) {
        succeedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:(2*M_PI)*failedValue-M_PI_4 endAngle:-M_PI_4-0.01 clockwise:YES];
        succeedLayer.path=succeedBezierPath.CGPath;
        failedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:-M_PI_4 endAngle:(2*M_PI)*failedValue-M_PI_4-0.01 clockwise:YES];
        failedLayer.path=failedBezierPath.CGPath;
    }else if (succeedValue==0){
        failedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        failedLayer.path=failedBezierPath.CGPath;
    }else if (failedValue==0){
        succeedBezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        succeedLayer.path=succeedBezierPath.CGPath;
    }
    
    //动画效果
    CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue=[NSNumber numberWithDouble:0];
    endAni.toValue=[NSNumber numberWithDouble:1];
    //    endAni.duration=1.5;
    [succeedLayer addAnimation:endAni forKey:nil];
    [failedLayer addAnimation:endAni forKey:nil];
    
    //数字label
    
    UILabel *succeedLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, labelHeight)];
    UILabel *failedLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, labelHeight)];
    //    succeedLabel.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    //    failedLabel.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    
    succeedLabel.text=[NSString stringWithFormat:@"%d次",(int)succeedTime];
    succeedLabel.font=[UIFont systemFontOfSize:12];
    succeedLabel.textAlignment=NSTextAlignmentCenter;
    succeedLabel.textColor=succeedColor;
    succeedLabel.shadowColor = [UIColor whiteColor];    //白色阴影
    succeedLabel.shadowOffset = CGSizeMake(0.5, 0.5);
    
    NSDictionary *sdic=[NSDictionary dictionaryWithObjectsAndKeys:succeedLabel.font,NSFontAttributeName, nil];
    CGSize size=CGSizeMake(0, labelHeight);
    CGFloat sWidth=[succeedLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:sdic context:nil].size.width+5;
    
    CGFloat sX,sY;
    if (cosf(M_PI*failedValue-M_PI_4/2)>0) {
        sX=circleCenter.x-(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }else{
        sX=circleCenter.x-(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }
    if (sinf(M_PI*failedValue-M_PI_4/2)>0) {
        sY=circleCenter.y-(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }else{
        sY=circleCenter.y-(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }
//    [succeedLabel setWidth:sWidth];
    [succeedLabel setFrame:CGRectMake(0, 0, sWidth, labelHeight)];
    succeedLabel.center=CGPointMake(sX, sY);
    
    
    failedLabel.text=[NSString stringWithFormat:@"%d次",(int)failedTime];
    failedLabel.font=[UIFont systemFontOfSize:12];
    failedLabel.textAlignment=NSTextAlignmentCenter;
    failedLabel.textColor=failedColor;
    failedLabel.shadowColor = [UIColor whiteColor];
    failedLabel.shadowOffset = CGSizeMake(0.5, 0.5);
    NSDictionary *fdic=[NSDictionary dictionaryWithObjectsAndKeys:succeedLabel.font,NSFontAttributeName, nil];
    CGFloat fWidth=[failedLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:fdic context:nil].size.width+5;
    
//    [failedLabel setWidth:fWidth];
    [failedLabel setFrame:CGRectMake(0, 0, fWidth, labelHeight)];
    CGFloat fX,fY;
    if (cosf(M_PI*failedValue-M_PI_4/2)>0) {
        fX=circleCenter.x+(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }else{
        fX=circleCenter.x+(radius-progressStrokeWidth)*cosf(M_PI*failedValue-M_PI_4);
    }
    if (sinf(M_PI*failedValue-M_PI_4/2)>0) {
        fY=circleCenter.y+(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }else{
        fY=circleCenter.y+(radius-progressStrokeWidth)*sinf(M_PI*failedValue-M_PI_4);
    }
    failedLabel.center=CGPointMake(fX, fY);
    
    //    NSLog(@"\n X:radius*cosf(M_PI*failedValue-M_PI_4/2)=%f \n Y:radius*sinf(M_PI*failedValue-M_PI_4/2)=%f",radius*cosf(M_PI*failedValue-M_PI_4/2),radius*sinf(M_PI*failedValue-M_PI_4/2));
    
    [view addSubview:succeedLabel];
    [view addSubview:failedLabel];
    
    return view;
    
}


@end
