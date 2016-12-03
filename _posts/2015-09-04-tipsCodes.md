---
layout: post
title:  "TipsCodes"
date:   2015-09-04 00:00:00
categories: Foundation
excerpt: 
---

* content
{:toc}


### 渐变模糊视图

````
- (void)addGradientView
{
    UIView *view = [[UIView alloc]init];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
    gradientLayer.colors     = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1, 0);
}
````

### 取消CALayer动画

````
[CATransaction begin];
[CATransaction setDisableActions:YES];
//code
[CATransaction commit];
````

### 获取状态栏视图

````
- (UIView *)getStatusBarView
{
    //     NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72}length:9] encoding:NSASCIIStringEncoding];
    NSString *key = @"statusBar";
    id object = [UIApplication sharedApplication];
    UIView *statusBar;
    if ([object respondsToSelector:NSSelectorFromString(key)]) {
        statusBar = [object valueForKey:key];
    }
    return statusBar;
}
````

### 获取View层级结构

````
- (NSString *)digView:(UIView *)view
{
    if ([view isKindOfClass:[UITableViewCell class]]) return @"";
    // 1.初始化
    NSMutableString *xml = [NSMutableString string];
    // 2.标签开头
    [xml appendFormat:@"<%@ frame=\"%@\"", view.class, NSStringFromCGRect(view.frame)];
    if (!CGPointEqualToPoint(view.bounds.origin, CGPointZero)) {
        [xml appendFormat:@" bounds=\"%@\"", NSStringFromCGRect(view.bounds)];
    }
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)view;
        if (!UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, scroll.contentInset)) {
            [xml appendFormat:@" contentInset=\"%@\"", NSStringFromUIEdgeInsets(scroll.contentInset)];
        }
    }
    // 3.判断是否要结束
    if (view.subviews.count == 0) {
        [xml appendString:@" />"];
        return xml;
    } else {
        [xml appendString:@">"];
    }
    // 4.遍历所有的子控件
    for (UIView *child in view.subviews) {
        NSString *childXml = [self digView:child];
        [xml appendString:childXml];
    }
    // 5.标签结尾
    [xml appendFormat:@"</%@>", view.class];
    return xml;
}
````

### 分割图片

````
//按照像素进行分割的
public func CGImageCreateWithImageInRect(image: CGImage?, _ rect: CGRect) -> CGImage?
````

### Quartz2D

````
// 调用一次该方法就会拷贝一个上下文到栈中
CGContextSaveGState(CGContextRef __nullable c)
// 获取拷贝的图形上下文
CGContextRestoreGState(CGContextRef __nullable c)
//  清空部分上下文
CGContextClearRect(CGContextRef __nullable c, CGRect rect)
//  剪裁
CGContextClip(CGContextRef __nullable c)
//  刷帧动画
CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updataImage)];
[display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//  图片上下文
UIGraphicsBeginImageContext(CGSize size);
CGContextRef ctx = UIGraphicsGetCurrentContext();
//  平铺图片背景
UIColor  + (UIColor *)colorWithPatternImage:(UIImage *)image;
//  截屏
CALayer  - (void)renderInContext:(CGContextRef)ctx
````

###  给本地文件发送一个请求

````
NSURL *fileurl = [[NSBundle mainBundle] URLForResource:@"itcast.txt" withExtension:nil];
NSURLRequest *request = [NSURLRequest requestWithURL:fileurl];
NSURLResponse *repsonse = nil;
//得到data
NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&repsonse error:nil];
// 得到mimeType
NSLog(@"%@", repsonse.MIMEType);
````