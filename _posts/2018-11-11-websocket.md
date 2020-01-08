---
layout: post
title:  "Websocket"
date:   2018-11-11 00:00:00
categories: Systems
excerpt: 
---

* content
{:toc}


### Sec-WebSocket-Key/Accept的作用

- 避免服务端收到非法的websocket连接（比如http客户端不小心请求连接websocket服务，此时服务端可以直接拒绝连接）
- 确保服务端理解websocket连接。因为ws握手阶段采用的是http协议，因此可能ws连接是被一个http服务器处理并返回的，此时客户端可以通过Sec-WebSocket-Key来确保服务端认识ws协议。
- 用浏览器里发起HTTP请求的时候Sec-WebSocket-Key以及其他相关的header是被禁止的，避免意外请求升级
- 可以防止反向代理（不理解ws协议）返回错误的数据。比如反向代理前后收到两次ws连接的升级请求，反向代理把第一次请求的返回给cache住，然后第二次请求到来时直接把cache住的请求给返回（无意义的返回）。


### 掩码的作用

防止代理缓存污染。

因为有一些代理会以为websocket是个普通的http请求，在对请求数据转发的时候会解释请求。如果发现类似HTTP 请求头的时候就会转发相应的请求到服务器，如果请求数据是故意伪造的，那么有些代理就会向目标地址发起请求。这个可以用来攻击目标服务或者故意污染代理服务，导致其他用户会访问伪造的数据而被攻击

需要注意的是，这里只是限制了浏览器对数据载荷进行掩码处理，但是坏人完全可以实现自己的WebSocket客户端、服务端，不按规则来，攻击可以照常进行。

尽管掩码提供了保护，但不符合规定的HTTP代理服务器仍是那些“不使用掩码的客户端-服务器”攻击对象！


参考资料：
[WebSocket协议](https://www.cnblogs.com/chyingp/p/websocket-deep-in.html)