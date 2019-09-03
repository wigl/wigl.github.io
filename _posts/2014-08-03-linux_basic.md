---
layout: post
title:  "Linux Basic"
date:   2014-08-15 00:00:00
categories: Linux
excerpt: 
---

* content
{:toc}

## CPU 架构

算数逻辑单元和控制单元
**精简指令集** (Reduced Instruction Set Computer, RISC): 使用在处理数据较为单一的设备，如导航系统、网络设备等。

**复杂指令集** (Complex Instruction Set Computer, CISC): AMD、Inter 的x86架构CPU，被大量用于个人电脑。

## 软件包管理系统

**dpkg:** Ubuntu

**RPM:** red Hat, centOS

## 常用命令

- tab 各种提示
- Ctrl-c 中断
- Ctrl-u 删除一行命令
- man == manual: 指令手册
- `wc`: 计算字数，显示行、单词数、字符数。
- `paste`: 将文件一行接一行连接起来。 `-d`选项：指定分隔符。
- ``echo Hello time is `date` ``，会执行`date`命令。
- 管道错操作符`|`，允许一个命令的标准输出作为另一个命令的标准输入
- `tee`将标准输出分离输出至文件。如：`ls | tee out.md`
- `chmod`修改文件权限。


**VI编辑器**

- `:/` 正向搜索
- `:?` 反向搜索
- Ctrl-d/f 向下翻页
- Ctrl-u/b 向上翻页
- 100G 直接到100行
- 注意：`vi`和输出重定向`> >>`都是会修改文件。并不是重新创建文件并覆盖原文件。

**后台执行**

`(nohup sleep 10;nohup date;nohup sleep 10;nohup date) > ouput.md 2>&1 &`

1. `nohup` == `no hang up`，不挂起，用户退出后继续执行。
2. `&`后台执行，但是关掉控制台（退出用户）会终止进程。
3. 故`nohup command &`表示：后台执行并且退出用户仍然会继续执行。所有输出都被重定向到一个名为`nohup.out`的文件中。
4. `2>&1`是将标准出错重定向到标准输出。

> `ls 2>error.md`: ls命令出错，则将错误输出到文件error.md;
> 
> `ls xxx 2>error.md`：没有xxx这个文件的错误输出到了文件error.md中；
> 
> `ls xxx 2>&1`：错误重定向到标准输出，在控制台上输出。
> 
> `ls xxx >out.txt 2>&1` 即 `ls xxx 1>out.txt 2>&1`：错误和输出都传到out.txt。
> 
> **为何2>&1要写在后面？**
> 
> `command > file 2>&1`:
> 
> 首先是command > file将标准输出重定向到file中， 2>&1 是标准错误拷贝了标准输出的行为，也就是同样被重定向到file中，最终结果就是标准输出和错误都被重定向到file中。
> 
> `command 2>&1 >file`: 
> 
> 2>&1标准错误拷贝了标准输出的行为，但此时标准输出还是在终端。>file 后输出才被重定向到file，但标准错误仍然保持在终端。
>


## Licenses

![后台模式](/image/developer_basic/free_software_licenses.png)