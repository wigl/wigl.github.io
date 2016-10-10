---
layout: post
title:  "Swift 小知识点 1 "
date:   2016-04-25 00:00:00
categories: Swift
excerpt: 
---

* content
{:toc}

### 运行时

- 纯Swift类没有动态性，但在方法、属性前添加dynamic修饰可以获得动态性。

- 继承自NSObject的Swift类，其继承自父类的方法具有动态性，其他自定义方法、属性需要加dynamic修饰才可以获得动态性。

- 若方法的参数、属性类型为Swift特有、无法映射到Objective-C的类型(如Character、Tuple)，则此方法、属性无法添加dynamic修饰（会编译错误）

- Swift类在Objective-C中会有模块前缀

#### 代码示例

````
extension UIViewController {
    public override class func initialize() {
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        struct Static {
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            //交换viewWillAppear方法
            let willAppearSelector = #selector(UIViewController.viewWillAppear(_:))
            let sw_willAppearSelector = #selector(UIViewController.sw_viewWillAppear(_:))
            let willAppearMethod = class_getInstanceMethod(self, willAppearSelector)
            let sw_willAppearMethod = class_getInstanceMethod(self, sw_willAppearSelector)
            method_exchangeImplementations(willAppearMethod, sw_willAppearMethod);
    }
    func sw_viewWillAppear(animated: Bool) {
        self.sw_viewWillAppear(animated)
    }
}
````  

### 编译顺序

PCH预编译导入的文件 -> 桥接文件 -> swift文件

### 视图控制器生命周期
一个 viewController(A) 有个子视图控制器 childController(B) ：

如果 A 还没加载完，就又消失了，那么很可能 B 的viewDidLoad、viewWillAppear还没来得及调用，就直接调用了viewWillDisappear

因为 A 消失的时候，会调用viewWillDisappear，从而调用他的子视图的 viewWillDisappear。

### A




