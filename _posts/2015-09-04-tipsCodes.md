---
layout: post
title:  "TipsCodes"
date:   2015-09-04 00:00:00
categories: App
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


### 获取当前第一响应者

````
fileprivate weak var tempCurrentResponder: UIResponder?
extension UIResponder {
    static var currentResponder: UIResponder? {
        tempCurrentResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        return tempCurrentResponder
    }
    @objc private func findFirstResponder() {
        tempCurrentResponder = self
    }
}
````

### 获取已经安装的App

````
//消除警告用
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
+ (NSArray *)getDeviceAppList
{
    /*获取设备已安装App列表已经App信息
     方法一：利用URL scheme，看对于某一应用特有的url scheme，有没有响应。如果有响应，就说明安装了这个特定的app。
     [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:i]]
     方法二：利用一些方法获得当前正在运行的进程信息，从进程信息中获得安装的app信息。
     方法三：私有API。
     */
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *allLSApplicationProxy = [workspace performSelector:@selector(allApplications)];
    NSMutableArray *appInfo = [[NSMutableArray alloc]init];
    //获取应用名，图标等
    [allLSApplicationProxy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSDictionary *boundIconsDictionary = [obj performSelector:@selector(boundIconsDictionary)];
         NSString *iconPath = [NSString stringWithFormat:@"%@/%@.png", [[obj performSelector:@selector(resourcesDirectoryURL)] path], [[[boundIconsDictionary objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"]lastObject]];
         UIImage *image = [[UIImage alloc]initWithContentsOfFile:iconPath];
         if (image)
         {
             
             //             [appInfo addObject:image];
             [appInfo addObject:[obj performSelector:@selector(localizedName)]];
         }
     }];
    return [appInfo copy];
}
#pragma clang diagnostic pop
````


