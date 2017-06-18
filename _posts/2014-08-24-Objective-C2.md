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

**约定：**如果`isEqual:`或者`==`判断两对象相等，那么hash必须返回相同的值。但是两个对象的hash值相同，那么`isEqual:`或者`==`未必会认为两者相等。