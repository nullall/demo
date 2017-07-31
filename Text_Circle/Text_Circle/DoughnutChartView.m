//
//  DoughnutChartView.m
//  Text_Circle
//
//  Created by Da.W on 2017/7/19.
//  Copyright © 2017年 daw. All rights reserved.
//

#import "DoughnutChartView.h"
#import "Define.h"

@interface DoughnutChartView (){
    NSMutableArray<NSNumber*> *scaleArray;  //每个数据所占比例
    NSMutableArray<NSNumber*> *angleArray;  //累加占比
    CGFloat amount;     //总的个数
}
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

-(void)setDataArray:(NSArray<NSString *> *)dataArray{
    _dataArray=dataArray;
    scaleArray=[[NSMutableArray alloc]init];
    angleArray=[[NSMutableArray alloc]init];
    amount=0;
    for (NSString *count in _dataArray) {
        amount+=[count floatValue];
    }
    if (amount>0) {
        for (NSString *count in _dataArray) {
            [scaleArray addObject:[NSNumber numberWithFloat:([count floatValue]/amount)]];
        }
    }
    [angleArray addObject:[NSNumber numberWithFloat:0]];
    for (int i=0; i<_dataArray.count; i++) {
        CGFloat num=0;
        for (int j=0; j<=i; j++){
            num+=[_dataArray[j] floatValue];
        }
        [angleArray addObject:[NSNumber numberWithFloat:num/amount]];
    }
    
}


-(void)initViews{
    self.chartView=[[UIView alloc]initWithFrame:CGRectMake((screenWidth-self.chartDiameter)/2, 25, self.chartDiameter, self.chartDiameter)];
    [self addSubview:_chartView];
//    [self drawChart];
    [self drawChart];
    [self addOtherView];
}

-(void)reloadView{
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    [self initViews];
}

-(void)drawChart{
    if (scaleArray.count==0) {
        return ;
    }

    CGPoint circleCenter;//中心坐标
    CGFloat diam=_chartDiameter;//直径
    CGFloat radius;//内环半径
    //中心点的位置
    circleCenter.x=_chartView.bounds.size.width/2;
    circleCenter.y=_chartView.bounds.size.height/2;
    radius=(diam-_progressStrokeWidth)/2.f;
    for (int i=0; i<scaleArray.count; i++) {
        CAShapeLayer *layer=[CAShapeLayer layer];
        layer.fillColor=nil;
        layer.frame=_chartView.bounds;
        layer.lineWidth=_progressStrokeWidth;
        layer.strokeColor=_colorArray[i].CGColor;
        [_chartView.layer addSublayer:layer];
        UIBezierPath *bezierPath;
        bezierPath=[UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:(2*M_PI)*[angleArray[i] floatValue]-M_PI_4 endAngle:(2*M_PI)*[angleArray[i+1] floatValue]-M_PI_4 clockwise:YES];
        layer.path=bezierPath.CGPath;
        //动画效果
        CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        endAni.fromValue=[NSNumber numberWithDouble:0];
        endAni.toValue=[NSNumber numberWithDouble:1];
        //    endAni.duration=1.5;
        [layer addAnimation:endAni forKey:nil];
        NSLog(@"==>%f",(_chartDiameter/2+5)*sinf(M_PI*[angleArray[i+1] floatValue]-M_PI_4));
        //+5是为了不完全贴合
        CGFloat x=_chartView.center.x+(_chartDiameter/2+5)*cosf(2*M_PI*[angleArray[i] floatValue]+M_PI*[scaleArray[i] floatValue]-M_PI_4);
        CGFloat y=_chartView.center.y+(_chartDiameter/2+5)*sinf(2*M_PI*[angleArray[i] floatValue]+M_PI*[scaleArray[i] floatValue]-M_PI_4);
        [self setData:[NSString stringWithFormat:@"%@个 %.2f%%",_dataArray[i],[scaleArray[i] floatValue]*100] dataType:_dataTypeArray[i] color:_colorArray[i] origin:CGPointMake(x, y)];
    }
    
}
/*
-(void)drawChart{
    CAShapeLayer *layer1;
    CAShapeLayer *layer2;
    UIBezierPath *bezierPath1;
    UIBezierPath *bezierPath2;
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
    layer1.strokeColor=_color1.CGColor;
    layer2=[CAShapeLayer layer];
    layer2.fillColor=nil;
    layer2.frame=_chartView.bounds;
    layer2.lineWidth=_progressStrokeWidth;
    layer2.strokeColor=_color2.CGColor;
    
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
    
//    CGFloat x1,y1;
//    if (cosf(M_PI*scale1-M_PI_4/2)>0) {
//        x1=_chartView.center.x+(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
//    }else{
//        x1=_chartView.center.x+(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
//    }
//    if (sinf(M_PI*scale1-M_PI_4/2)>0) {
//        y1=_chartView.center.y+(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
//    }else{
//        y1=_chartView.center.y+(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
//    }
    CGFloat x1=_chartView.center.x+(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
    CGFloat y1=_chartView.center.y+(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
    [self setData:[NSString stringWithFormat:@"%.0f个 %.2f%%",_count1,scale1*100] dataType:_type1 color:_color1 origin:CGPointMake(x1, y1)];
    
//    CGFloat x2,y2;
//    if (cosf(M_PI*scale1-M_PI_4/2)>0) {
//        x2=_chartView.center.x-(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
//    }else{
//        x2=_chartView.center.x-(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
//    }
//    if (sinf(M_PI*scale1-M_PI_4/2)>0) {
//        y2=_chartView.center.y-(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
//    }else{
//        y2=_chartView.center.y-(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
//    }
    CGFloat x2=_chartView.center.x-(_chartDiameter/2+5)*cosf(M_PI*scale1-M_PI_4);
    CGFloat y2=_chartView.center.y-(_chartDiameter/2+5)*sinf(M_PI*scale1-M_PI_4);
    [self setData:[NSString stringWithFormat:@"%.0f个 %.2f%%",_count2,scale2*100] dataType:_type2 color:_color2 origin:CGPointMake(x2, y2)];

}
*/

/**
 *  数据类型提示
 *
 *  @param data     数据
 *  @param dataType 数据类型
 *  @param color    实心圆的颜色
 *  @param point    位置
 */
-(void)setData:(NSString *)data dataType:(NSString *)dataType color:(UIColor *)color origin:(CGPoint)point{
    CGFloat width=100;
    CGFloat height=35;
    if (point.x<self.center.x) {
        point.x=point.x-width;
    }
    if (point.y<self.chartView.center.y) {
        point.y=point.y-height;
    }
    UIView *dataView=[[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, width, height)];
    [self addSubview:dataView];
    
    /*
     *画实线
     */
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[UIColorFromHex(0xEEF3F7) CGColor]];
    solidShapeLayer.lineWidth = 1.0f ;
    if (point.x>self.center.x) {
        if (point.y<_chartView.center.y) {
            CGPathMoveToPoint(solidShapePath, NULL, 0, height);
        }else{
            CGPathMoveToPoint(solidShapePath, NULL, 0, 0);
        }
        CGPathAddLineToPoint(solidShapePath, NULL, 13,17);
        CGPathAddLineToPoint(solidShapePath, NULL, 100,17);
    }else{
        if (point.y<_chartView.center.y) {
            CGPathMoveToPoint(solidShapePath, NULL, 100, height);
        }else{
            CGPathMoveToPoint(solidShapePath, NULL, 100, 0);
        }
        CGPathAddLineToPoint(solidShapePath, NULL, 100-13,17);
        CGPathAddLineToPoint(solidShapePath, NULL, 0,17);
    }
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [dataView.layer addSublayer:solidShapeLayer];
    
    /*
     *画实心圆
     */
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 1.0f ;
    solidLine.strokeColor = color.CGColor;
    solidLine.fillColor = color.CGColor;
    if (point.x>self.center.x) {
        if (point.y<_chartView.center.y) {
            CGPathAddEllipseInRect(solidPath, nil, CGRectMake(0, height-3, 3, 3));
        }else{
            CGPathAddEllipseInRect(solidPath, nil, CGRectMake(0, 0, 3, 3));
        }
        
    }else{
        if (point.y<_chartView.center.y) {
            CGPathAddEllipseInRect(solidPath, nil, CGRectMake(100-3, height-3, 3, 3));
        }else{
            CGPathAddEllipseInRect(solidPath, nil, CGRectMake(100-3, 0, 3, 3));
        }
    }
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [dataView.layer addSublayer:solidLine];
    
    /**
     *数据信息
     */
    UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 100-13, 16)];
    UILabel *dataTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 18, 100-13, 16)];
    [dataView addSubview:dataLabel];
    [dataView addSubview:dataTypeLabel];
    if (point.x>self.center.x) {
        dataLabel.textAlignment=NSTextAlignmentRight;
        dataTypeLabel.textAlignment=NSTextAlignmentRight;
    }else{
        dataLabel.textAlignment=NSTextAlignmentLeft;
        dataTypeLabel.textAlignment=NSTextAlignmentLeft;
        [dataLabel setFrame:CGRectMake(0, 0, 100-13, 16)];
        [dataTypeLabel setFrame:CGRectMake(0, 18, 100-13, 16)];
    }
    dataLabel.font=[UIFont systemFontOfSize:10];
    dataTypeLabel.font=[UIFont systemFontOfSize:10];
    dataLabel.textColor=UIColorFromHex(0x7C7C7C);
    dataTypeLabel.textColor=UIColorFromHex(0xb2b2b2);
    dataLabel.text=data;
    dataTypeLabel.text=dataType;
    
    //动画效果
    CABasicAnimation *endAni=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAni.fromValue=[NSNumber numberWithDouble:0];
    endAni.toValue=[NSNumber numberWithDouble:1];
    endAni.duration=0.25;
    [solidShapeLayer addAnimation:endAni forKey:nil];
    
    dataLabel.alpha=0;
    dataTypeLabel.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        dataLabel.alpha=1;
        dataTypeLabel.alpha=1;
    }];
    
}

//其他的一些View
-(void)addOtherView{
    //提示总的数量
    UILabel *amountLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, (_chartDiameter-15)/2, _chartDiameter, 15)];
    amountLabel.textColor=UIColorFromHex(0x575757);
    amountLabel.textAlignment=NSTextAlignmentCenter;
    amountLabel.font=[UIFont systemFontOfSize:13];
    amountLabel.text=[NSString stringWithFormat:@"共%.0f个",amount];
    [self.chartView addSubview:amountLabel];
    amountLabel.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        amountLabel.alpha=1;
    }];
    
    
    //标注颜色提示
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, self.chartView.frame.origin.y+_chartDiameter+50, self.bounds.size.width, 15)];
//    [self addSubview:view];
//    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(self.center.x-67, 0, 15, 15)];
//    view1.backgroundColor=_color1;
//    [view addSubview:view1];
//    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(self.center.x+23, 0, 15, 15)];
//    view2.backgroundColor=_color2;
//    [view addSubview:view2];
//    
//    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(view1.frame.origin.x+21, 0, 45, 15)];
//    label1.text=_type1;
//    label1.font=[UIFont systemFontOfSize:12];
//    label1.textColor=UIColorFromHex(0x7C7C7C);
//    [view addSubview:label1];
//    
//    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(view2.frame.origin.x+21, 0, 45, 15)];
//    label2.text=_type2;
//    label2.font=[UIFont systemFontOfSize:12];
//    label2.textColor=UIColorFromHex(0x7C7C7C);
//    [view addSubview:label2];
    
}
@end
