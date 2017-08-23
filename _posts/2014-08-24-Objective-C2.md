---
layout: post
title:  "Objective-C 语法 2"
date:   2014-08-24 00:00:00
categories: 语法
excerpt: 
---

* content
{:toc}


### C语言，字符串与字符串地址

````
char a = 'a'; // 字符变量
char str[] = "string"; // 字符数组，即字符串
char *strAddress = str; // 使用指针（地址）表示一个字符串， char *st = "one string"
// 注意：strAddress 和 str[] 均表示字符串"string"，是字符串的不同表示方式。
// 本质：下面两个和strAddress指向同一地址，是字符串的第一个字符的地址
char *address1 = &str;
void *address2 = &str;
// 注意：无法直接从 strAddress 获取字符串的值，因为 strAddress 表示的是字符串的第一个字符的地址。必须通过循环，并判断字符串结尾是否为'\0'来得到字符串值。
// 获取到字符串的第一个字符
char firstChar = *strAddress; //'s'
````

### 对象等同性

**约定：**如果`isEqual:`或者`==`判断两对象相等，那么hash必须返回相同的值。但是两个对象的hash值相同，那么`isEqual:`或者`==`未必会认为两者相等


### 类

`+load` 程序启动即调用所有类的load方法

`+initialize` 当类第一次使用的时候调用（第一次被实例化的时候）

> **根元类对象：**包含new方法，isa指向自己，任何类的根元类对象都是NSObject元类对象
> 
> **元类对象：**包含**类方法**
> 
> **类对象：**类第一次使用的时候创建，isa指针指向元类对象，元类对象保存**属性和对象方法**。
> 
> **实例对象：**通过类对象创建，isa指针指向类对象
> 

### SEL

通过`@selector`函数可以找到方法的地址。

`- (BOOL)respondsToSelector:(SEL)aSelector`

`- (id)performSelector:(SEL)aSelector;`

### 循环

**C语言循环**

````
for (int i = 0; i < num; i++) {
}
````

**OC 1.0 中的枚举器`NSEnumerator`**

OC中的collection都提供了响应的方法，获取相应的枚举器，从而通过枚举器的`nextObject()`获取下一个遍历的对象。

**快速遍历**

OC 2.0 后，collection都遵从了`NSFastEnumeration`协议，从而可以使用`for` `in`进行快速遍历。

Swift的collection都遵从`Sequence`协议，也可以使用快速遍历。

**block/closure**

````
//OC
- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))block
//Swift
func forEach(_ body: (Element) throws -> Void) rethrows
````

**遍历collection是否可以修改**

````
// Swift
在Swift中，for-in和forEach遍历的时候，可以修改原collection，实际上遍历的是collection的copy。
// OC
OC中，for-in循环不能修改、添加、插入。
而c与语言循环、块枚举可以修改，添加、插入等操作可能造成遍历一直进行。
总之，不应该在遍历的时候修改collection。
````

### Timer 弱引用

````
extension Timer {
    class func scheduledTimer(timeInterval interval: TimeInterval, repeats: Bool, closure: ()->Void) -> Timer{
        return self.scheduledTimer(timeInterval: interval, target: self, selector: #selector(closureMethond(timer:)), userInfo: closure, repeats: repeats)
    }
    @objc private class func closureMethond(timer: Timer) {
        if let closure = timer.userInfo as? ()->Void {
            closure()
        }
    }
}
````





