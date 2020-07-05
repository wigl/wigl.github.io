---
layout: post
title:  "Objective-C 语法"
date:   2014-08-23 00:00:00
categories: 语法
excerpt: 
---

* content
{:toc}



### @class
向前声明，一般用于头文件中，只是告诉文件@class后面的字符串为一个类。使用@class不用导入头文件，可以提高编译效率；也可以解决循环包含的问题。

### ARC
ARC，ARC和垃圾回收机制不同，它是编译器特性，在编译期间，根据Objective-C对象的存活周期，在适当的位置添加retain和release代码。从概念上讲，ARC与手动引用计数内存管理遵循同样的内存管理规则，ARC也无法防止循环强引用。

### 空
- NULL是宏，是对于C语言指针而使用的，表示空指针
- nil是宏，是对于Objective-C中的对象而使用的，表示对象为空
- Nil是宏，是对于Objective-C中的类而使用的，表示类指向空
- NSNull是类类型，是用于表示空的占位对象，在数组、字典中用于填充

### 结构体和对象

#### 结构体

````
//定义一个Person类型的结构体
struct Person{
    int age;
    double height;
};
struct Person p;
//结构体可以通过点语法来取出成员变量
p.age = 18;
p.height = 180;
//pp为结构体p的指针
struct Person *pp = &p;
//结构体指针可以通过->语法来取出成员变量
pp->age = 17;
pp->height = 170;
````

**注意：**

> 1. 结构体变量是在定义的时候即进行初始化的。
> 2. 结构体赋值是拷贝过程。比如`CGRect x = view.frame`是将view的frame值拷贝一份给x。
> 3. 所以view中的结构体不能直接修改。因为`CGRect x = view.frame`和`CGRect y = view.frame`中`x`和`y`不是一个值（地址不一样），实际上都是从`view.frame`拷贝过来的，是新值。

#### 对象

> OC中的对象本质为结构体，对象中的成员变量为结构体的成员变量
> 
> 所以和结构体类似，可以通过对象的地址和->语法访问对象的成员变量
> 
> 而通过对象的点语法访问成员变量，是通过setter和getter方法访问成员变量的。
>

### typedef

**结构体：**

````
//定义一个Person结构体类型
struct Person{
    int age;
    double height;
};
//定义一个变量，需要先写struct+结构体类型
struct Person p;

//使用typedef声明。以后定义结构体变量就不用先写struct+name了，直接写接头提类型即可
typedef struct{
    int x;
    int y;
}OneStructType;
OneStructType firstStruct;

//直接定义一个结构体变量
struct{
    int x;
    int y;
}secondStruct;
````

**枚举：**

````
//枚举类型基本写法
enum OneEnum {
    OneEnum1,
    OneEnum2,
};
enum OneEnum x = OneEnum1;

//使用typedef
typedef enum{
    SecondEnum1,
    SecondEnum2,
}SecondEnum;
SecondEnum y = SecondEnum1;

//直接定义一个one的枚举变量
enum {
    One1,
    One2,
}one;
````

### category

用处：

1. 不修改类扩充方法
2. 一个庞大的类可以分模块开发

````
@interface ClassName(CategoryName)
@end
@implementation ClassName(CategoryName)
@end
````

注意：

1. 分类不能添加成员变量。
2. @property 只会生成setter/getter方法的声明，不会生成实现和私有成员变量。（可以通过runtime添加方法的实现）
3. 分类中可以访问原有类中的.h的成员变量。
4. 分类中的方法和原类方法名重合后，覆盖原有方法。

### 类扩展

类扩展，Class Extension，又叫匿名分类，可以为某个类扩充私有成员变量。

````
@interface ClassName()
@end
````

#### 两者区别

1. 是否有名字
2. 是否可以添加成员变量
3. 添加的方法是否需要实现：类扩展添加的方法如果不实现的话，编译器会报警告；而分类不强制要求实现。

#### Readonly

将对象属性尽量设置为不可变，在`.h`文件中见属性封装为readonly；有时候又希望在对象内部使用该属性的setter方法，那么可以借助类扩展，在`.m`中将对象重新封装成readwrite。

比如：

````
// .h文件
@interface Person : NSObject
@property (nonatomic, copy, readonly) NSString *firstName;
@end
// .m文件
@property (nonatomic, copy, readwrite) NSString *firstName;
@end

````

### block

**定义：**

> 1. block是iOS中比较特殊的**数据类型**
> 2. 它可以用于保存一段代码，同时保存和代码相关的数据，以便后续使用

**基本使用：**

````
//定义一个block类型
typedef NSString *(^blockTypeName)(int x, int y);
//block赋值
blockTypeName oneBlock = ^(int x, int y){
    return @"return string";
};
//使用block
NSString *st = oneBlock(1,2);
//定义block
NSString *(^blockName)(int x, int y)=^(int x, int y){ return @"retun string"; };
````

**注意：**

> 1. block可以访问外界变量
> 2. **基本数据类型：**默认情况为值传递，block不能修改；加上__block后是地址传递，可以修改
> 3. **对象类型：**默认情况下为对象指针传递，block不能修改，但是对象的内部属性还是可以修改；加上__block后是**指针的地址传递**，从而更换原地址的对象。 
> 

**block和方法：**

**方法：**

> 1. 基本数据类型为值传递，方法内参数为新的局域变量。
> 2. 对象类型为指针传递，方法内部参数为一个新的局域变量，保存对象的地址，可以通过地址修改原来的对象。

**block：**

> 1. 对象和基本数据类型都是值传递，对象是指针的值传递。实际上都是copy出来的一个新的值，不过block内部看上去是旧值，所以不能修改。但是通过对象的指针可以修改对象内部属性。
> 2. 加上__block后，基本数据类型传递变为基本数据类型的指针传递，从而可以在block内部修改外部变量。对象类型为指针的地址传递，从而可以修改指针。

**指针函数：**

函数：`void functionName(){}`

函数指针：`void (*oneFuncP)()`

赋值：oneFuncP = functionName

### protocol

协议：将多个方法的声明抽取出来，从而让不同的类遵守这些协议。一般用于**类型限定**和**代理设计模式**。

````
//声明
@protocol protocolName<NSObject>
@required
//必须实现的方法
@optional
//可选的方法
@end
//遵守
@interface ClassName:FatherClassName<protocolName,protocolName1>
@end
````
**注意：**

> 1. 当前协议属于谁，我们就将协议定在谁的头文件中。
> 2. 协议名称以属于某个类的类名开头，后面跟上delegate
> 3. 协议中的方法名称一般以协议的名称delegate之前的即属于某个类的类名作为开头
> 4. 一般情况下协议的方法会将触发协议的对象传递出去
> 5. 一般类中的代理属性名称叫做delegate
> 6. 某个类遵循某个协议，不要直接导入包含那个协议的类，而是使用**@protocol + 协议名**
>

### copy

copy的根本需求是：拷贝出的对象不能影响拷贝以前的对象。修改之前的或者修改之后的对象，不能影响另一个。

### NSValue

````
//NSValue转换自定义结构体
+ (NSValue *)valueWithBytes:(const void *)value objCType:(const char *)type
````

参数`value`：传入结构体的地址

参数`type`：传入结构体的类型，一般用`@encode(）`函数获取结构体类型

````
//从NSVale获取自定义结构体
- (void)getValue:(void *)value
````

参数`value`:待获取的结构体的地址

### 静态变量
声明一个abc的静态变量：

````
extern NSString const  *abc;
````
extern：该对象存在，但会在另一个文件中定义

const：静态，该指针不会变化

### static extern const
- static修饰**局部变量/常量**，只会初始化一次，且在程序退出的时候才会销毁。
- static修饰**全局变量/常量**，只能在本文件中使用，其他文件不能使用。
  - static 一般写在 .m 文件中，也就是是编译单元（即实现文件，translation-unit）内，那该变量/常量只在本文件中可见。
  - static int i; 如果写在 .h 文件中，然后这个 .h 文件被其他文件导入了，那么，其他文件相当于重新声明了一个变量/常量。
  - 不能在两个 .m 文件中声明相同的全局变量/常量/c函数（即不加 static 关键词），编译器会为它创建一个“外部符号”（external symbol），这样会导致编译报错。
- extern 用以定义全局变量/常量。
  - 变量/常量可以进行多次声明，但是只能定义一次。
  - 通常在 .h 文件中声明。如：`extern NSString * const abc;`
  - 在 .m 文件中定义，即： `NSString * const abc = @"123"`
  - 上述常量存在全局符号表中“global symbol table”
- const 用以定义常量； const 右边的总不能被修改

### KVO
KVO是基于runtime机制实现的。

当某个类的对象第一次被观察时，系统会动态地为该类创建一个派生类（派生类名在元类名前面加上`NSKVONotifying_`），派生了重写了setter方法，从而可以监控属性发生改变。

这个中间类，继承自原本的那个类。不仅如此，Apple 还重写了 -class 方法，企图欺骗我们这个类没有变，就是原本那个类。

被观察对象的 isa 指针会指向一个中间类，而不是原来真正的类。