//
//  DoughnutChartView.m
//  Text_Circle
//
//  Created by Da.W on 2017/7/19.
//  Copyright © 2017年 daw. All rights reserved.
//

#import "DoughnutChartView.h"
#import "Define.h"

@interface DoughnutChartView ()
@property(strong,nonatomic) UIView *chartView;
@end

@implementation DoughnutChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}


-(void)initViews{
    
    [self drawChart];
    
}

-(void)drawChart{
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    self.chartView=[[UIView alloc]initWithFrame:CGRectMake((screenWidth-self.chartDiameter)/2, 25, self.chartDiameter, self.chartDiameter)];
    [self addSubview:_chartView];
    
    CAShapeLayer *layer1;
    CAShapeLayer *layer2;
    UIBezierPath *bezierPath1;
    UIBezierPath *bezierPath2;
    UIColor *color1=[UIColor colorWithRed:254/255.0 green:200/255.0 blue:81/255.0 alpha:1];
    UIColor *color2=[UIColor colorWithRed:114/255.0 green:201/255.0 blue:245/255.0 alpha:1];
    CGPoint circleCenter;//中心坐标
    CGFloat diam=_chartDiameter;//直径
    CGFloat radius;//内环半径
    CGFloat scale1=_count1/(_count1+_count2);
    CGFloat scale2=_count2/(_count1+_count2);
    
    if (_count1==0&&_count2==0) {
        return ;
    }
    
    layer1=[CAShapeLayer layer];
    layer1.fillColor=nil;
    layer1.frame=_chartView.bounds;
    layer1.lineWidth=_progressStrokeWidth;
    layer1.strokeColor=color1.CGColor;
    layer2=[CAShapeLayer layer];
    layer2.fillColor=nil;
    layer2.frame=_chartView.bounds;
    layer2.lineWidth=_progressStrokeWidth;
    layer2.strokeColor=color2.CGColor;
    
    //中心点的位置
    circleCenter.x=_chartView.bounds.size.width/2;
    circleCenter.y=_chartView.bounds.size.height/2;
    
    [_chartView.layer addSublayer:layer1];
    [_chartView.layer addSublayer:layer2];
    
    radius=(diam-_progressStrokeWidth)/2.f;
    
    //0.01是为了留一点点白色的空隙
    if (scale1!=0&&scale2!=0) {
        bezierPath1=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:-M_PI_4 endAngle:(2*M_PI)*scale1-M_PI_4-0.01 clockwise:YES];
        layer1.path=bezierPath1.CGPath;
        bezierPath2=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:(2*M_PI)*scale1-M_PI_4 endAngle:-M_PI_4-0.01 clockwise:YES];
        layer2.path=bezierPath2.CGPath;
    }else if (scale1==0){
        bezierPath2=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        layer2.path=bezierPath2.CGPath;
    }else if (scale2==0){
        bezierPath1=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
        layer1.path=bezierPath1.CGPath;
    }
    
    //动画效果
    CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue=[NSNumber numberWithDouble:0];
    endAni.toValue=[NSNumber numberWithDouble:1];
    //    endAni.duration=1.5;
    [layer1 addAnimation:endAni forKey:nil];
    [layer2 addAnimation:endAni forKey:nil];
    
    CGFloat x1,y1;
    if (cosf(M_PI*scale1-M_PI_4/2)>0) {
        x1=_chartView.center.x+(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
    }else{
        x1=_chartView.center.x+(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
    }
    if (sinf(M_PI*scale1-M_PI_4/2)>0) {
        y1=_chartView.center.y+(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
    }else{
        y1=_chartView.center.y+(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
    }
//    NSLog(@"%f,%f",_chartView.center.x,_chartView.center.y);
    [self setData:[NSString stringWithFormat:@"%.0f个 %.2f%%",_count1,scale1*100] dataType:@"未施工" color:color1 origin:CGPointMake(x1, y1)];
    
    CGFloat x2,y2;
    if (cosf(M_PI*scale1-M_PI_4/2)>0) {
        x2=_chartView.center.x-(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
    }else{
        x2=_chartView.center.x-(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
    }
    if (sinf(M_PI*scale1-M_PI_4/2)>0) {
        y2=_chartView.center.y-(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
    }else{
        y2=_chartView.center.y-(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
    }
//    NSLog(@"%f,%f",_chartView.center.x,_chartView.center.y);
    [self setData:[NSString stringWithFormat:@"%.0f个 %.2f%%",_count2,scale2*100] dataType:@"已施工" color:color2 origin:CGPointMake(x2, y2)];

}

//应当传入数据：颜色，位置，label1，label2

-(void)setData:(NSString *)data dataType:(NSString *)dataType color:(UIColor *)color origin:(CGPoint)point{
    if (point.x<self.center.x) {
        point.x=point.x-100;
    }
    UIView *dataView=[[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, 100, 35)];
    [self addSubview:dataView];
    /*
     *画实线
     */
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[[UIColor colorWithRed:238/255.0 green:243/255.0 blue:247/255.0 alpha:1] CGColor]];
    solidShapeLayer.lineWidth = 1.0f ;
    if (point.x>self.center.x) {
        CGPathMoveToPoint(solidShapePath, NULL, 0, 0);
        CGPathAddLineToPoint(solidShapePath, NULL, 13,17);
        CGPathAddLineToPoint(solidShapePath, NULL, 100,17);
    }else{
        CGPathMoveToPoint(solidShapePath, NULL, 100, 0);
        CGPathAddLineToPoint(solidShapePath, NULL, 100-13,17);
        CGPathAddLineToPoint(solidShapePath, NULL, 0,17);
    }
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [dataView.layer addSublayer:solidShapeLayer];
    
    /*
     *画实线圆
     */
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 1.0f ;
    solidLine.strokeColor = color.CGColor;
    solidLine.fillColor = color.CGColor;
    if (point.x>self.center.x) {
        CGPathAddEllipseInRect(solidPath, nil, CGRectMake(0, 0, 3, 3));
    }else{
        CGPathAddEllipseInRect(solidPath, nil, CGRectMake(100-3, 0, 3, 3));
    }
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [dataView.layer addSublayer:solidLine];
    
    /**
     *数据信息
     */
    UILabel *upperLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 100-13, 16)];
    UILabel *belowLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 18, 100-13, 16)];
    [dataView addSubview:upperLabel];
    [dataView addSubview:belowLabel];
    if (point.x>self.center.x) {
        upperLabel.textAlignment=NSTextAlignmentRight;
        belowLabel.textAlignment=NSTextAlignmentRight;
    }else{
        upperLabel.textAlignment=NSTextAlignmentLeft;
        belowLabel.textAlignment=NSTextAlignmentLeft;
        [upperLabel setFrame:CGRectMake(0, 0, 100-13, 16)];
        [belowLabel setFrame:CGRectMake(0, 18, 100-13, 16)];
    }
    upperLabel.font=[UIFont systemFontOfSize:10];
    belowLabel.font=[UIFont systemFontOfSize:10];
    upperLabel.textColor=UIColorFromHex(0xb2b2b2);
    belowLabel.textColor=UIColorFromHex(0xb2b2b2);
    upperLabel.text=data;
    belowLabel.text=dataType;
}

@end
