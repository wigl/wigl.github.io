//
//  CustomView.m
//  MyDemo
//
//  Created by cardvalue on 16/1/7.
//  Copyright © 2016年 niels.jin. All rights reserved.
//
// view.isHidden
// view.isOpaque
// view.alpha
// 区别
#import "CustomView.h"

@interface CustomView ()
//填充颜色
@property (nonatomic, strong) UIColor *FillColor;
//画笔颜色
@property (nonatomic, strong) UIColor *StrokeColor;
//画笔线宽
@property (nonatomic, assign) CGFloat LineWidth;
//绘画模式
@property (nonatomic, assign) CGPathDrawingMode mode;
//绘制类型
@property (nonatomic) TypeView typeView;

@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame withTypeView:(TypeView)typeView FillColor:(UIColor *)FillColor StorkColor:(UIColor *)StrokeColor LineWidth:(CGFloat)LineWidth  mode:(CGPathDrawingMode)mode
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.typeView = typeView;
        self.FillColor = FillColor;
        self.LineWidth = LineWidth;
        self.StrokeColor = StrokeColor;
        self.mode = mode;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.FillColor.CGColor);
    CGContextSetLineWidth(context, self.LineWidth);
    CGContextSetStrokeColorWithColor(context, self.StrokeColor.CGColor);
    if (self.typeView == TypeViewCircle) {
        /*画圆*/
        CGFloat min = self.bounds.size.height > self.bounds.size.width ? self.bounds.size.width : self.bounds.size.height;
        CGContextAddArc(context, self.bounds.size.width / 2, self.bounds.size.height / 2, min/2 - self.LineWidth/2 , 0, 2 * M_PI, 0);
        CGContextDrawPath(context, self.mode);
    }else if (self.typeView == TypeViewCross){
        /*十字线*/
        CGPoint aPoints[2];
        aPoints[0] = CGPointMake(0, self.bounds.size.height/2);
        aPoints[1] = CGPointMake(self.bounds.size.width, self.bounds.size.height/2);
        CGContextAddLines(context, aPoints, 2);
        CGContextDrawPath(context, self.mode);
        CGPoint bPoints[2];
        bPoints[0] = CGPointMake(self.bounds.size.width/2, 0);
        bPoints[1] = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
        CGContextAddLines(context, bPoints, 2);
        CGContextDrawPath(context, self.mode);
    }else if (self.typeView == TypeViewRect){
        /*矩形*/
        CGContextAddRect(context, self.bounds);
        CGContextDrawPath(context, self.mode);
    }else if (self.typeView == TypeViewRectWithRadus){
        /*矩形*/
        CGFloat radus = self.bounds.size.width/8;
        CGFloat w = self.bounds.size.width - self.LineWidth;
        CGFloat h = self.bounds.size.height - self.LineWidth;
        CGContextMoveToPoint(context, w, h - radus);
        CGContextAddArcToPoint(context, w, h, w - radus, h, radus );
        CGContextAddArcToPoint(context, self.LineWidth, h, self.LineWidth, h - radus, radus);
        CGContextAddArcToPoint(context, self.LineWidth, self.LineWidth, radus, self.LineWidth, radus);
        CGContextAddArcToPoint(context, w, self.LineWidth, w, h - radus, radus);
        CGContextClosePath(context);
        CGContextDrawPath(context, self.mode);
    }
}
@end
