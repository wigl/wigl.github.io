---
layout: post
title:  "Command"
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
jekyll serve --detach
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
````

#### svnserve

````
svnserve -d -r /svnDic
````

#### mac启动运行程序

为某个用户添加：

````
touch ~/Library/LaunchAgents/LoginScripts.Test.plist
// 在终端上执行
launchctl load ~/Library/LaunchAgents/LoginScripts.Test.plist
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
