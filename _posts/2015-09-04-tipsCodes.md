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

### 数字键盘左下角添加按钮

````
#pragma mark 添加数字键盘左下角按钮
+ (void)addDoneBtnForNumberKeyboardWithNotification
{
    //注册键盘显示、隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
// 键盘出现处理事件
+ (void)handleKeyboardWillShow:(NSNotification *)notification
{
    NSArray *ary = [[UIApplication sharedApplication]windows];
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:(ary.count -1)];
    UIView *view = [tempWindow viewWithTag:10216];
    [view removeFromSuperview];
    NSDictionary *userInfop = [notification userInfo];
    CGFloat center = [([userInfop valueForKey:@"UIKeyboardBoundsUserInfoKey"]) CGRectValue].size.height;
    if (center != 216.00000) return;
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, screenHeight + 4 * 53, (screenWidth-6)/3, 53)];
    doneBtn.tag = 10216;
    [doneBtn setTitle:@"—" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(btnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [doneBtn addTarget:self action:@selector(btnNormal:) forControlEvents:UIControlEventTouchCancel];
    [doneBtn addTarget:self action:@selector(btnNormal:) forControlEvents:UIControlEventTouchUpOutside];
    
    [tempWindow addSubview: doneBtn];
    doneBtn.frame = CGRectMake(0, screenHeight - 53, (screenWidth-6)/3 - 1, 53);
}
// 键盘消失处理事件
+ (void)handleKeyboardWillHide:(NSNotification *)notification
{
    NSArray *ary = [[UIApplication sharedApplication]windows];
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:(ary.count -1)];
    UIView *view = [tempWindow viewWithTag:10216];
    view.frame = CGRectMake(0, screenHeight + 4 * 53, (screenWidth - 6)/3, 53);
}
//点击左下角按钮
+ (void)btnTouchUpInside:(UIButton *)btn
{
    btn.backgroundColor = [UIColor clearColor];
    UIView *firstResponderView = [self getCurrentResponder];
    if (![firstResponderView isKindOfClass:[UITextField class]]) return;
    UITextField *textFielf = (UITextField *)firstResponderView;
    NSMutableString *muSt = [textFielf.text mutableCopy];
    //添加“-”
    NSInteger startOffset = [textFielf offsetFromPosition:textFielf.beginningOfDocument toPosition:textFielf.selectedTextRange.start];
    NSInteger endOffset = [textFielf offsetFromPosition:textFielf.beginningOfDocument toPosition:textFielf.selectedTextRange.end];
    [muSt deleteCharactersInRange:NSMakeRange(startOffset, endOffset-startOffset)];
    [muSt insertString:@"-" atIndex:startOffset];
    textFielf.text = muSt;
    //光标移至之前位置
    UITextPosition* beginning = textFielf.beginningOfDocument;
    UITextPosition* startPosition = [textFielf positionFromPosition:beginning offset:startOffset +1];
    UITextPosition* endPosition = [textFielf positionFromPosition:beginning offset:startOffset +1];
    UITextRange* selectionRange = [textFielf textRangeFromPosition:startPosition toPosition:endPosition];
    [textFielf setSelectedTextRange:selectionRange];
}
+ (void)btnTouchDown:(UIButton *)btn{
    btn.backgroundColor = [UIColor whiteColor];
}
+ (void)btnNormal:(UIButton *)btn{
    btn.backgroundColor = [UIColor clearColor];
}
//取消通知
+ (void)removeDoneBtnForNumberKeyboardWithNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
````

### AttributedString 删除空白行

````
extension NSMutableAttributedString {
    
     static func attributeString(HTML str: String, style: String, isRemoveEmpty: Bool = true) -> NSMutableAttributedString? {
        guard let data = str.appending(style).data(using: .unicode) else {
            return nil
        }
        guard let mutAttribute = try? NSMutableAttributedString.init(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else {
            return nil
        }
        if isRemoveEmpty {
            mutAttribute.removeEmpty()
        }
        return mutAttribute
    }
    
    func removeEmpty() {
        var ranges: [NSRange] = []
        let predicate = NSPredicate(format: "SELF MATCHES %@", "[\\s]*$")
        self.enumerateAttributes(in: NSRange.init(location: 0, length: self.length), options: [], using: { (dic, r, _) in
            let st = self.attributedSubstring(from: r).string
            if predicate.evaluate(with: st){
                ranges.append(r)
            }else{
                if r.location == 0 {
                    if st.hasPrefix("\n\n") {
                        let range = NSRange.init(location: r.location, length: 2)
                        ranges.append(range)
                    }else if st.hasPrefix("\n"){
                        let range = NSRange.init(location: r.location, length: 1)
                        ranges.append(range)
                    }
                }
                if st.hasSuffix("\n\n"){
                    let range = NSRange.init(location: r.location + r.length - 1, length: 1)
                    ranges.append(range)
                }else if st.hasSuffix("\n") && (r.location + r.length) == self.length{
                    let range = NSRange.init(location: r.location + r.length - 1, length: 1)
                    ranges.append(range)
                }
            }
            if let paragraphStyle = dic[NSParagraphStyleAttributeName] as? NSParagraphStyle,
                "\(paragraphStyle)".contains("NSTextTableBlock"){
                if let lastRage = ranges.last,
                    (lastRage.location + lastRage.length) == r.location{
                    ranges.removeLast()
                }
            }
        })
        var removeLength = 0
        for r in ranges {
            self.deleteCharacters(in: NSRange.init(location: r.location - removeLength, length: r.length))
            removeLength = removeLength + r.length
        }
    }
}
````

