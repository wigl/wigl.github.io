---
layout: post
title:  "OC 成员变量和Property"
date:   2014-08-21 00:00:00
categories: 语法
excerpt: 
---

* content
{:toc}


## 成员变量

成员变量：Member variable。

### 成员变量的声明

#### 在哪声明

成员变量既可以在@interface中声明，也可以在@implementation中声明；可以在.h文件中申明，也可以在.m文件中声明。

#### 如何声明

成员变量写在大括号中，并且习惯性以'_'开头。比如，我们声明一个名字（age）和（name）的成员变量:

````
{
    @public
    int _age;
    @private
    NSString *_name;
}
````

#### 成员变量的修饰符

- **@private:**默认修饰符，表示成员变量为私有的，只能在自己的类中使用，不能子类以及其他类中使用。
- **@protect:**受保护的，可以在自己的类以及子类中使用，其他类中无法使用。
- **@public:**公开的成员变量，可以任何类中使用。
- **@package:**在自己的包中，效果类似于@public，在包外，效果类似于@private.

> **注意：**私有成员变量依然可以通过KVC去访问和修改，iOS中没有真正的私有成员变量。

#### .h和.m中声明的区别

成员量在.h和.m中声明的区别是：是否对外暴露。在.h中声明，其他类可以“看到”该成员变量，在.m中申明，其他类无法“看到”该成员变量。

在@interface中声明，也可以在@implementation中声明，区别和上面的类似。

### 成员变量的访问

1. 通过`->`语法来访问成员变量，类似于访问结构体中的成员变量。比如访问上面个声明的`_age`：`obj->_age`即可。
2. 通过setter和getter方法。声明和实现成员变量的setter和getter方法，调用方法或者使用点语法即可访问成员变量。

## @property

### 介绍
@property是编译器特性，用来声明属性。

当我们写`@property type name`，编译器会帮我们做如下操作：

1. 自动以'_'开头生成成员变量。**在.m文件中生成的，并且成员变量是私有的！！**
2. 自动申明和实现的setter和getter方法。
3. 如果自己重写了其中一个setter或者getter方法，property会自动生成另一个方法。
4. 如果setter和getter方法都重写了，那么编译器**不会自动生成成员变量**。

### 修饰词

- **readwrite：**，默认修饰词，同时生成get方法和set方法的声明和实现- **readonly：**只生成get方法的声明和实现
- **getter = ... ，setter = ...：** 用于修改setter和getter方法的名字- **assign：**set方法的实现是直接赋值，用于基本数据类型- **retain,strong：**默认修饰词，set方法的实现是release旧值，retain新值，用于OC对象类型- **copy：**set方法的实现是release旧值，copy新值，用于NSString、block等类型
- **weak：**不做release和retain操作，用于OC对象类型。
- **unsafe_unretained:**早起的weak，当对象释放后，不会讲对象置为nil。- **nonatomic：**非原子性，set方法的实现不加锁（比atomic性能高，默认为atomic修饰词）

> **注意：**assign和weak都可以用于需要弱引用的OC对象，不同的是，被weak修饰的对象当被销毁的时候会被置为nil，而assign不会置为nil，这样可能导致野指针错误。

那weak是如何实现自动置nil？实际上是通过runtime机制实现的：

>runtime 对注册的类， 会进行布局，对于 weak 对象会放入一个 hash 表中。 用 weak 指向的对象内存地址作为 key，当此对象的引用计数为0的时候会 dealloc，假如 weak 指向的对象内存地址是a，那么就会以a为键， 在这个 weak 表中搜索，找到所有以a为键的 weak 对象，从而设置为 nil。

## @synthesize 

Xcode4.4之前，@property和@synthesize独立工作。@property负责声明setter、getter方法。@synthesize负责生成成员变量和实现setter和getter方法。

比如：`@synthesize name = _name;`,编译器就会自动生成_name的成员变量，同时生成name的setter和getter方法。

如果没有告诉系统将传入的值赋值给谁，系统工会默认给和@synthesize后面写的**名称相同的成员变量**，比如：`@synthesize name; //等同于 @synthesize name = name;`

> **注意：**如果没有声明成员变量，比如我们setter和getter方法都重写了，那么@synthesizet同时也会生成成员变量。

那什么情况下需要我们手动写@synthesize呢？引用[stackoverflow](http://stackoverflow.com/questions/19784454/when-should-i-use-synthesize-explicitly)上的一段话：

>Thank to autosynthesis you don't need to explicitly synthesize the property as it will be automatically synthesized by the compiler as
>
>`@synthesize propertyName = _propertyName`
>
>However, a few exceptions exist:
>
> - readwrite property with custom getter and setter
> 
>	 when providing both a getter and setter custom implementation, the property won't be automatically synthesized
> 
> - readonly property with custom getter
> 
> 	when providing a custom getter implementation for a readonly property, this won't be automatically synthesized
> 
> - **@dynamic**
> 
> 	when using `@dynamic propertyName`, the property won't be automatically synthesized (pretty obvious, since `@dynamic` and `@synthesize` are mutually exclusive)
> 
> - properties declared in a @protocol
> 
>	 when conforming to a protocol, any property the protocol defines won't be automatically synthesized
> 
> - properties declared in a category
> 
> 	this is a case in which the @synthesize directive is not automatically inserted by the compiler, but this properties cannot be manually synthesized either. While categories can declare properties, they cannot be synthesized at all, since categories cannot create ivars. For the sake of completeness, I'll add that's it's still possible [to fake the property synthesis using the Objective-C runtime](http://stackoverflow.com/questions/8733104/objective-c-property-instance-variable-in-category).
> 
> - overridden properties
> 
> 	when you override a property of a superclass, you must explicitly synthesize it


## @dynamic 

just tells the compiler that the getter and setter methods are implemented not by the class itself but somewhere else (like the superclass or will be provided at runtime).

## 局部变量的修饰词

局部变量的修饰词和@property修饰词类似，包括：__strong、__weak、__unsafeunretained、__autoreleasing(参数传递)等。作用效果和上述类似。