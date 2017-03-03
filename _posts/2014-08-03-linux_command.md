---
layout: post
title:  "Linux常用命令"
date:   2014-08-05 00:00:00
categories: Linux
excerpt: 
---

* content
{:toc}


## 常用命令

注销： `logout` `exit` `ctrl+d`

关机： `shutdown -h now`

重启： `shutdown -r now` `reboot`

获取帮助：`man + 命令` `--help`

用户创建： `useradd passwd`

创建目录： `mkdir`

显示当前工作目录： `pwd`

操作历史： `history`

拷贝： `cp`  `cp etc/filename a.text` ： 将文件拷贝至当前目录并改名为a.text

删除：`rm` `-r`删除目录 `-rf`

文件列表： `ls` `-l`详细信息

d 目录 | s 套链字 |- 普通文件 | p 命名管道
----|----|---|----
b 块设备 | l 符号连接 |c 字符设备 | 

系统服务：`systemctl`

````
systemstal enable/start/restart http.service  //自动启动/启动/重启
systemstal disable/stop http.service               //关闭自动启动/关闭
systemstal status http.service  
systemstal list-units --type=service                  //显示已启动的服务
````

文件权限：

````
sudo chmod 600 ××× （只有所有者有读和写的权限）

sudo chmod 644 ××× （所有者有读和写的权限，组用户只有读的权限）

sudo chmod 700 ××× （只有所有者有读和写以及执行的权限）

sudo chmod 666 ××× （每个人都有读和写的权限）

sudo chmod 777 ××× （每个人都有读和写以及执行的权限）

sudo chown user file （修改file的所有者）
````

