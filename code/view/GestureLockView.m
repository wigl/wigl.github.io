//
//  GestureLockView.m
//  MyDemo
//
//  Created by cardvalue on 16/2/23.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import "GestureLockView.h"

@interface GestureLockView ()
@property (nonatomic, strong) NSMutableArray *buttons; //按钮数组
@property (nonatomic, strong) NSMutableArray *selectedButtons; //被选中的按钮
@property (nonatomic, assign) CGPoint currentPoint; //当前触摸点
@property (nonatomic, copy) NSString *tempResult;

@end

@implementation GestureLockView

- (void)layoutSubviews
{
    [super layoutSubviews];
    //添加按钮
    [self addButtons];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //清空上下文
    CGContextClearRect(context, rect);
    for (int i = 0 ;  i < self.selectedButtons.count; i++) {
        UIButton *btn = self.selectedButtons[i];
        if (i == 0) {
            CGContextMoveToPoint(context, btn.center.x, btn.center.y);
        }else{
            CGContextAddLineToPoint(context, btn.center.x, btn.center.y);
        }
    }
    if (self.selectedButtons.count != 0) {
        CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
    }
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.389 green:0.8893 blue:0.4846 alpha:1.0].CGColor);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    UIButton *btn = [self getCurrentBtnWithPoint:point];
    if (btn) {
        btn.selected = YES;
        [self.selectedButtons addObject:btn];
    }
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentPoint = [[touches anyObject] locationInView:self];
    self.currentPoint = currentPoint;
    UIButton *btn = [self getCurrentBtnWithPoint:currentPoint];
    if (btn && btn.selected != YES) {
        btn.selected = YES;
        [self.selectedButtons addObject:btn];
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //取出绘制的手势
    NSMutableString *result = [[NSMutableString alloc]init];
    [self.selectedButtons enumerateObjectsUsingBlock:^(UIButton *  btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendFormat:@"%ld",(long)btn.tag];
    }];
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.selected = NO;
    }];
    [self.selectedButtons removeAllObjects];
    [self setNeedsDisplay];
    
    if ([self.delegate respondsToSelector:@selector(lockViewDidClick:passWord:)]) {
        [self.delegate lockViewDidClick:self passWord:[result copy]];
    }
}

- (UIButton *)getCurrentBtnWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.buttons) {
        //点是否在frame内
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

- (void)addButtons
{
    if (_buttons != nil) {
        return;
    }
    
    NSMutableArray *mutAr = [[NSMutableArray alloc]init];
    UIImage *normalImage;
    UIImage *highilightedImage;
    double P = 1.8;
    CGFloat margin = self.frame.size.width/(4 + 3 * P);
    CGFloat btnWH = P * margin;
    for (int i = 0 ;  i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:highilightedImage forState:UIControlStateSelected];
        int col = i % 3; // 列号
        int row = i / 3; // 行号
        btn.frame = CGRectMake(margin + col * (margin + btnWH), margin + row * (margin + btnWH), btnWH, btnWH);
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        btn.tag = 1000 + i;
        [mutAr addObject:btn];
    }
    _buttons = mutAr;
    _selectedButtons = [[NSMutableArray alloc]init];
}
    
@end
