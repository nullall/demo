//
//  HistogramView.m
//  Text_Circle
//
//  Created by Da.W on 2017/7/20.
//  Copyright © 2017年 daw. All rights reserved.
//

#import "HistogramView.h"
#import "Define.h"

@interface HistogramView (){
    CGFloat barMaxHeight;    //柱状图最大高度
    CGFloat barSpacing;     //柱状图间距
}

@end

@implementation HistogramView

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
    self.chartWidth=286;
    self.chartHeight=155;
    self.barWidth=30;
    self.dataFontSize=14;
    self.dataTypeFontSize=12;
    self.defaultColor=[UIColor orangeColor];
    [self drawChart];
}

-(void)reloadView{
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    [self drawChart];
}

-(void)drawChart{
    barMaxHeight=_chartHeight-40;
    barSpacing=(_chartWidth-_barWidth*_dataArray.count)/(_dataArray.count+1);
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-_chartWidth)/2, _chartHeight, _chartWidth, 1)];
    line.backgroundColor=UIColorFromHex(0x999999);
    [self addSubview:line];
    
    CGFloat max=1;
    for (NSString *count in _dataArray) {
        max=max>[count floatValue]?max:[count floatValue];
    }
    for (int i=0; i<_dataArray.count; i++) {
        NSString *count=_dataArray[i];
        CGRect frame = CGRectMake(0, 0, _barWidth, 0);
        if (i<=(_dataArray.count-1)/2.0) {
            frame.origin.x=self.center.x-(barSpacing+_barWidth)*((_dataArray.count-1)/2.0-i)-_barWidth*0.5;
        }else{
            frame.origin.x=self.center.x+(barSpacing+_barWidth)*(i-(_dataArray.count-1)/2.0)-_barWidth*0.5;
        }
        frame.size.height=[count floatValue]/max*barMaxHeight;
        frame.origin.y=_chartHeight-frame.size.height;
        UIView *barView=[[UIView alloc]initWithFrame:frame];
//        if (i<_colorArray.count) {
//            barView.backgroundColor=_colorArray[i];
//        }else{
//            barView.backgroundColor=self.defaultColor;
//        }
        [self addSubview:barView];
        
        CAShapeLayer *layer=[CAShapeLayer layer];
        UIBezierPath *bp=[UIBezierPath bezierPathWithRect:barView.bounds];
        layer.path=bp.CGPath;
        if (i<_colorArray.count) {
            layer.strokeColor=_colorArray[i].CGColor;
            layer.fillColor=_colorArray[i].CGColor;
        }else{
            layer.strokeColor=self.defaultColor.CGColor;
            layer.fillColor=self.defaultColor.CGColor;
        }
        [barView.layer addSublayer:layer];
        //动画效果
        CGRect fromframe=barView.bounds;
        fromframe.origin.y=barView.bounds.size.height;
        fromframe.size.height=0;
        CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        fillAnimation.duration = 0.3;
        fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        fillAnimation.fillMode = kCAFillModeForwards;
        fillAnimation.removedOnCompletion = NO;
        fillAnimation.fromValue = (__bridge id)([UIBezierPath bezierPathWithRect:fromframe].CGPath);
        fillAnimation.toValue = (__bridge id)([UIBezierPath bezierPathWithRect:barView.bounds].CGPath);
        [layer addAnimation:fillAnimation forKey:nil];

        
        /**个数label*/
        CGRect countLabelFrame;
        countLabelFrame.origin.y=frame.origin.y-17;
        countLabelFrame.origin.x=frame.origin.x-15;
        countLabelFrame.size=CGSizeMake(_barWidth+30, 15);
        UILabel *countLabel=[[UILabel alloc]initWithFrame:countLabelFrame];
        countLabel.textAlignment=NSTextAlignmentCenter;
        if (i<_colorArray.count) {
            countLabel.textColor=_colorArray[i];
        }else{
            countLabel.textColor=[UIColor orangeColor];
        }
        countLabel.font=[UIFont systemFontOfSize:_dataFontSize];
        countLabel.text=[NSString stringWithFormat:@"%@个",count];
        [self addSubview:countLabel];
        //显示动画
        countLabel.alpha=0;
        [UIView animateWithDuration:0.3 animations:^{
            countLabel.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
        
        /**数据类型标题*/
        CGRect typeLabelFrame;
        typeLabelFrame.origin.y=_chartHeight+7;
        typeLabelFrame.origin.x=frame.origin.x-30;
        typeLabelFrame.size=CGSizeMake(_barWidth+60, 13);
        UILabel *typeLabel=[[UILabel alloc]initWithFrame:typeLabelFrame];
        typeLabel.textAlignment=NSTextAlignmentCenter;
        typeLabel.textColor=UIColorFromHex(0x7c7c7c);
        typeLabel.font=[UIFont systemFontOfSize:_dataTypeFontSize];
        if (i<_dataTypeArray.count) {
            typeLabel.text=_dataTypeArray[i];
        }else{
            typeLabel.text=@"---";
        }
        [self addSubview:typeLabel];
    }
}


@end
