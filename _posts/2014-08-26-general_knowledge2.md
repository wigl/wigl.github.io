---
layout: post
title:  "小知识点 2 "
date:   2014-08-25 00:00:00
categories: Foundation
excerpt: 
---

* content
{:toc}

### static extern const

- static修饰**局部变量**，只会初始化一次，且在程序退出的时候才会销毁。
- static修饰**全局变量**，只能在本文件中使用，其他文件不能使用。
  - static int i; 如果写在 .h 文件中，然后这个 .h 文件被其他文件导入了，那么，其他文件相当于重新声明了一个变量。
  - 变量可以进行多次声明，但是只能定义一次。
- extern 用以定义全局变量。
- const 用以定义常量； const 右边的总不能被修改

### KVO

KVO是基于runtime机制实现的。当某个类的对象第一次被观察时，系统会动态地为该类创建一个派生类（派生类名在元类名前面加上`NSKVONotifying_`），派生了重写了setter方法，从而可以监控属性发生改变。

### 缓存池满的问题

如果使用了`reuseIdentifier`，那么系统会将创建过的cell加入到缓存中待用；所以，如果后续的cell没有复用已经创建过的cell，那么如果tableView的行数很多，缓存中将会存在大量的cell，导致内存过高甚至溢出。解决方法就是，循环使用or不适用缓存机制。

### App启动过程

main函数->UIApplicationMain(创建UIApplication和UIApplication的delegate对象)->调用didFinishLaunchingWithOption方法->创建windows->设置windows的rootViewController->显示windows

### preshent

viewController A preshent B 后，b的`presentingViewController`是： 如果A没有父Controller，那么就是A，否则就是A的父Controller

### 计算文字高度

````
// 注意1： iOS 9 和 iOS 10 系统字体不一样，所以，NSAttributedString 如果使用了系统字体，在iOS 10 和 iOS 9情况下，计算的rect 不一样，高度不一样。
//注意2： UITextView 有上下左右边距，所以使用下面函数计算的高度不能直接使用。
func boundingRect(with size: CGSize, options: NSStringDrawingOptions = [], context: NSStringDrawingContext?) -> CGRect
````

### 试图控制生命周期

**init** -view为懒加载-> **loadView** -加载完成之后-> **viewDidLoad** -将要显示，此时view还没有superview-> **viewWillAppear** -在这个过程中，view添加的superview上-> **viewDidAppear**(view已经添加到superview上)
