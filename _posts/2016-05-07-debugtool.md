---
layout: post
title:  "debugtool"
date:   2016-05-07 00:00:00
categories: Tools
excerpt: 
---

* content
{:toc}

#### Reveal 配置

1. 在Xcode项目中，选择“View → Navigators → Show Breakpoint Navigator”。
2. 在左边底部面板，点击"+"号按钮，然后选择“Add Symbolic Breakpoint”。
3. 在Symbol字段里面填入“UIApplicationMain”。
4. 点击“Add Action”按钮，并确认一下“Action”是设置到“Debugger Command”。
5. 在Action下的文本框中贴入如下表达式

````
expr (Class)NSClassFromString(@"IBARevealLoader") == nil ? (void *)dlopen("/Applications/Reveal.app/Contents/SharedSupport/iOS-Libraries/libReveal.dylib", 0x2) : ((void*)0)
````