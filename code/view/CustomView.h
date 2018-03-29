//
//  CustomView.h
//  MyDemo
//
//  Created by cardvalue on 16/1/7.
//  Copyright © 2016年 niels.jin. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TypeView) {
    TypeViewCircle,
    TypeViewCross,
    TypeViewRect,
    TypeViewRectWithRadus
};

@interface CustomView : UIView
- (instancetype)initWithFrame:(CGRect)frame withTypeView:(TypeView)typeView FillColor:(UIColor *)FillColor StorkColor:(UIColor *)StrokeColor LineWidth:(CGFloat)LineWidth  mode:(CGPathDrawingMode)mode;

@end
