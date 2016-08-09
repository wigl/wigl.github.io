---
layout: post
title:  "shadowsocks"
date:   2014-08-02 00:00:00
categories: Linux
excerpt: 
---

* content
{:toc}



## 安装

````
yum install python-setuptools && easy_install pip
pip install shadowsocks
````

## 多用户配置

`vi /etc/shadowsocks.json `

````
{
    "server": "128.199.75.190",
    "port_password": {
        "port1": "pwd1",
        "port2": "pwd2"
    },
    "timeout": 300,
    "method": "aes-256-cfb"
}
````

## 启动
````
ssserver -p 443 -k password -m aes-256-cfb
sudo ssserver -p 443 -k password -m aes-256-cfb --user nobody -d start
ssserver -c /etc/shadowsocks.json -d start
ssserver -c /etc/shadowsocks.json -d stop
````

## 开机启动脚本

`cd etc/init.d/`

`vi shadowsocksstart`

````
#!/bin/sh
ulimit -n 51200
sysctl --system
ssserver -c /etc/shadowsocks.json -d start
sysctl --system
````

`chmod +x   shadowsocksstart`

`chkconfig --add shadowsocksstart （--list 查看）`

## log

`/var/log/shadowsocks.log`

## 直接建立SSH隧道

`ssh -D8000 -p22 -N -v username@address`

## 优化

- `vi /etc/security/limits.conf`

````
* soft nofile 51200
* hard nofile 51200
````

`ulimit -n 51200`

- `vi /etc/sysctl.d/local.conf`

````
# max open files
fs.file-max = 51200
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096

# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000

      
      
      
      
      
      
      
      
      
      
# turn on TCP Fast Open on both client and server side
net.ipv4.tcp_fastopen = 3
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

# for high-latency network
net.ipv4.tcp_congestion_control = hybla

# for low-latency network, use cubic instead

      
      
      
      
      
      
      
      
      
      
# net.ipv4.tcp_congestion_control = cubic
````

`sysctl --system`


