---
layout: post
title:  "Command"
date:   2016-05-20 00:00:00
categories: Tools
excerpt: 
---

* content
{:toc}


##### jekyll

````
gem install jekyll
-n /usr/local/bin
jekyll serve --detach
````

##### jenkins

````
brew services start/stop/restart jenkins
````

##### 终端下使用代理

````
export ALL_PROXY=socks5://127.0.0.1:1080
curl ip.cn //查看ip地址
unset ALL_PROXY
````

##### 安装任何来源软件

````
sudo spctl --master-disable
````

##### svnserve

````
svnserve -d -r /svnDic
````
