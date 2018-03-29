//
//  DrawingboardView.m
//  MyDemo
//
//  Created by cardvalue on 16/2/22.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import "DrawingboardView.h"

@interface DrawingboardView()
@property (nonatomic, strong) NSMutableArray *pathDics;

@end

@implementation DrawingboardView


- (NSMutableArray *)pathDics
{
    if (!_pathDics) {
        _pathDics = [[NSMutableArray alloc]init];
    }
    return _pathDics;
}

- (void)drawRect:(CGRect)rect
{
    [self.pathDics enumerateObjectsUsingBlock:^(NSDictionary *pathDic, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBezierPath *path = [pathDic valueForKey:@"path"];
        [path stroke];
        NSDictionary *dic = [pathDic valueForKey:@"attribute"];
        path.lineWidth = [[dic valueForKey:@"lineWidth"] floatValue];
        UIColor *color =[UIColor colorWithRed:[[dic valueForKey:@"R"] floatValue] green:[[dic valueForKey:@"G"] floatValue] blue:[[dic valueForKey:@"B"] floatValue] alpha:[[dic valueForKey:@"alpha"] floatValue]];
        [color setStroke];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    CGPoint beginPoint = [[touches anyObject] locationInView:self];
    [path moveToPoint:beginPoint];
    //随机产生颜色值，字宽
    CGFloat R = arc4random()%255/255.0;
    CGFloat G = arc4random()%255/255.0;
    CGFloat B = arc4random()%255/255.0;
    CGFloat alpha = 1;
    CGFloat lineWidth = arc4random()%5+1;
    NSDictionary *dic = @{@"R":@(R),@"G":@(G),@"B":@(B),@"alpha":@(alpha),@"lineWidth":@(lineWidth)};
    NSDictionary *pathDic = @{@"path":path,@"attribute":dic};
    [self.pathDics addObject:pathDic];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIBezierPath *currentPath = [[self.pathDics lastObject] valueForKey:@"path"];
    [currentPath addLineToPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

@end
