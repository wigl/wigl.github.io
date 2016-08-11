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