---
layout: post
title:  "Markdown语法简要介绍"
date:   2016-04-05 00:00:00
categories: Markdown
excerpt: 
---

* content
{:toc}



#### 标题

````markdown
# 这是 H1
## 这是 H2
### 这是 H3
````



#### 区块引用

> > 区块内可以使用Markdown其他语法

````markdown
> ## 这是标题 H2
>
> 1.  这是第一行列表
> 2.  这是第二行列
>
>     ````
>     This is code; 
>     ````
````



#### 列表

* 无序列表使用星号、加号或是减号作为列表标记（这三个符号等价）：

  * 第二层 
     * 第三层

````markdown
*   Red
*   Green
*   Blue
````



#### 分割线

---
---

````markdown
---
***
````



#### 强调：*斜体的样子*

````
*斜体的样子*
_斜体的样子_
````



#### 版权符号

©

````markdown
&copy;
````



#### 代码

````markdown
​````markdown
code
​````
````

文字中间插入代码`this is code`

````markdown
文字中间插入代码 `this is code`
````

如果要在代码区段内插入反引号，你可以用多个反引号来开启和结束代码区段：

```
``There is a literal backtick (`) here.``
```



#### 链接

跳转至 [首页](http://wigl.github.io);

跳转至相对主机位置 [测试文章](/2016/04/02/test/)

````markdown
跳转至 [首页](htto://wigl.github.io);
跳转至相对主机位置 [测试文章](/2016/04/02/test/);
````

*参考式*的链接是在链接文字的括号后面再接上另一个方括号，而在第二个方括号里面要填入(id)用以辨识链接的标记：

````markdown
This is [an example][id] reference-style link.
````

接着，在文件的任意处，你可以把这个标记的链接内容定义出来：

````markdown
[id]: http://example.com/  "Optional Title Here"
````

*隐式链接标记*
省略指定链接标记，这种情形下，链接标记会视为等同于链接文字，要用隐式链接标记只要在链接文字后面加上一个空的方括号，如果你要让 "Google" 链接到 google.com，你可以简化成：

````markdown
[Google][]
````

然后定义链接内容：

```markdown
[Google]: http://google.com/
```



##### 图片链接

````markdown
![Alt text](/path/to/img.jpg)
![Alt text](/path/to/img.jpg "Optional title")
````

*Markdown现在还不支持指定图片大小，需要使用HTML标签*

````html
<img src="http://....jpg" width="200" height="200" />
````



##### 自动链接

<http://wigl.github.io>

<address@example.com>

````markdown
<http://wigl.github.io>
<address@example.com>
````



#### 反斜杠

Markdown 支持以下这些符号前面加上反斜杠来帮助插入普通的符号：

```markdown
\   反斜线
`   反引号
*   星号
_   底线
{}  花括号
[]  方括号
()  括弧
#   井字号
+   加号
-   减号
.   英文句点
!   惊叹号
```