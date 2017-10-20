---
layout: post
title:  "Some command"
date:   2016-05-20 00:00:00
categories: Tools
excerpt: 
---

* content
{:toc}


#### jekyll

````
gem install jekyll
-n /usr/local/bin
jekyll serve --detach --host=0.0.0.0
pkill -f jekyll
````

#### jenkins

````
brew services start/stop/restart jenkins
````

#### 终端下使用代理

````
export ALL_PROXY=socks5://127.0.0.1:1080
curl ip.cn //查看ip地址
unset ALL_PROXY
````

#### 安装任何来源软件

````
sudo spctl --master-disable
// 删除Mac所有描述文件
sudo profiles -D
````

#### mac开机启动程序

为某个用户添加：

````
touch ~/Library/LaunchAgents/LoginScripts.Test.plist
// 在终端上执行
launchctl load ~/Library/LaunchAgents/LoginScripts.Test.plist
// 取消启动运行 -w 参数会使得该程序不能以任何方式启动。如果想要重新启动，请使用 launchctl load -w 命令
launchctl unload -w ~/Library/LaunchAgents/LoginScripts.Test.plist
````

为所用用户添加:

````
sudo touch /Library/LaunchAgents/LoginScripts.Test.plist
//在终端上执行
sudo chown root /Library/LaunchAgents/LoginScripts.Test.plist
sudo launchctl load /Library/LaunchAgents/LoginScripts.Test.plist
````

附`LoginScripts.Test.plist`文件模板：

````
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
      <!-- YOUR SELF-CHOSEN *UNIQUE* LABEL (TASK ID) HERE -->
    <string>LoginScripts.Test.sh</string>
    <key>ProgramArguments</key>
    <array>
          <!-- YOUR *FULL, LITERAL* SCRIPT PATH HERE -->
        <string>/Users/Shared/Test.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
````

参考文章[Launch shell script on login in Mac OS (OS X)](https://stackoverflow.com/questions/22842016/launch-shell-script-on-login-in-mac-os-os-x?noredirect=1)

#### Shell

##### 命令失效问题

解决开机或者Automator运行脚本部分命令失效的问题，报如类似错误：`jekyll: command not found`。

解决方法，在脚本前添加如下内容：

````
if [ -x /usr/libexec/path_helper ]; then
    eval `/usr/libexec/path_helper -s`
fi
if  [ -f "$HOME"/.profile ]; then
    source "$HOME"/.profile
elif [ -f "$HOME"/.bash_profile ]; then
    source "$HOME"/.bash_profile
elif [ -f "$HOME"/.bashrc ]; then
    source "$HOME"/.bashrc
fi
// 这个bug的原因是，Automator默认环境搜索路径不包括`/usr/local/bin`，所以也可以在脚本前添加如下命令解决该问题
export PATH=/usr/local/bin:$PATH
// Mac系统的环境变量，加载顺序为：
/etc/profile /etc/paths ~/.bash_profile ~/.bash_login ~/.profile ~/.bashrc
// PATH 语法
export PATH=$PATH:<PATH 1>:<PATH 2>:<PATH 3>:<PATH N>
export PATH=<PATH 1>:<PATH 2>:<PATH 3>:<PATH N>:$PATH
````

参考文章[stackexchange](https://apple.stackexchange.com/a/192645)

##### 删除keychain中密码

````
security delete-generic-password -l "password name"
````


##### 忽略错误继续执行

````
# 在命令后面加上
|| true
````

#### svn

##### svnserve

````
svnserve -d -r /svnDic
````

##### 判断svn服务器是否有最新代码

````
svn status -u | grep -E -c "^\s+[^\?]"
如果输出为 0， 则代表本地为最新代码，否则说明服务器上有新代码。
````

#### SSH秘钥生成

````
$ cd ~/.ssh
$ ssh-keygen -t rsa -C "text@text.com" -f my.key //key名字为my.key
````

#### Gem

````
$ gem sources --remove https://rubygems.org/
$ gem sources -a https://ruby.taobao.org/
# 请确保下列命令的输出只有 ruby.taobao.org
$ gem sources -l
*** CURRENT SOURCES ***
https://ruby.taobao.org
````

### CocoaPods

- 安装

````
$ sudo gem install cocoapods 
$ pod setup 
````

- 使用

````
pod install --verbose --no-repo-update
//更新本地仓库
pod repo update
````
