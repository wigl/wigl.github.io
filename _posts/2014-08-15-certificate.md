---
layout: post
title:  "iOS开发证书"
date:   2014-08-15 00:00:00
categories: Tools
excerpt: 
---

* content
{:toc}

### iOS证书

#### 证书请求文件

创建  Certificate Signing Request (CSR) 的时候会创建私钥和公钥。同时 CSR 也包含了公钥信息。

#### 生成证书

将 CSR 上传给证书 CA 机构 (Certificate Authority)，这里是 AppleWWDRCA（Apple Root CA）。

CA 会根据自己的私钥对 CSR 中的public key和一些身份信息进行加密签名生成数字证书 (Certificates)，这时候证书中包含加密后的公钥、名称和证书授权中心的数字签名等。

#### 安装证书

将 CA 生成的证书下载下来，双击即可安装。

这时候系统会使用 WWDRCA 对证书进行校验：

- 若用 WWDRCA 公钥能成功解密出证书并得到公钥（Public Key）和内容摘要（Signature），证明此证书确乃AppleWWDRCA发布，即证书来源可信；
- 再对证书本身使用哈希算法计算摘要，若与上一步得到的摘要一致，则证明此证书未被篡改过，即证书完整。

校验成功后：

- 在KeychainAccess->Keys中展开创建CSR时生成的Key Pair中的私钥前面的箭头，可以查看到包含其对应公钥的证书（Your requested certificate will be the public half of the key pair.）
- 在Keychain Access->Certificates中展开安装的证书（ios_development.cer）前面的箭头，可以看到其对应的私钥。

也就是私钥和证书是一对一的。

#### 供应配置文件

Provisioning Profiles 文件包含了上述的所有内容：证书、App ID和设备。

一个Provisioning Profile对应一个Explicit App ID或Wildcard App ID（一组相同Prefix/Seed的App IDs）。

在网站上手动创建一个Provisioning Profile时，需要依次指定App ID（单选）、证书（Certificates，可多选）和设备（Devices，可多选）。用户可在网站上删除（Delete）已注册的Provisioning Profiles。
Provisioning Profile决定Xcode用哪个证书（公钥）/私钥组合（Key Pair/Signing Identity）来签署应用程序（Signing Product）,将在应用程序打包时嵌入到.ipa包里。**安装应用程序时，Provisioning Profile文件被拷贝到iOS设备中**，运行该iOS App的设备也通过它来认证安装的程序。

示例：

![Provisioning Profiles](/image/certificate/pp.jpg)

#### 签名

签名之前，我们先看一张图，表明现在Mac系统中签名所需的资源：
 
![codesign](/image/certificate/codesign.jpg)

每个证书（其实是公钥）对应Key Pair中的私钥会被用来对内容（executable code，resources such as images and nib files aren’t signed）进行数字签名（CodeSign）——使用哈希算法生成内容摘要（digest）。

在Xcode进行真机打包的时候，会进行下列验证：

- 对配置的 bundle ID、certificate 、Device ID与Provisioning Profile进行匹配校验

![codesign](/image/certificate/verify.jpg)

- Mac上的ios_development.cer被AppleWWDRCA.cer中的 public key解密校验合法后，获取每个开发证书中可信任的公钥对App的可靠性和完整性进行校验。
  - 若用证书公钥能成功解密出App（executable code）的内容摘要（Signature），证明此App确乃认证开发者发布，即来源可信；
  - 再对App（executable code）本身使用哈希算法计算摘要，若与上一步得到的摘要一致，则证明此App（executable code）未被篡改过，即内容完整。

以上验证通过后，就进行打包操作。

当真机上App运行的时候，也会进行上述验证判断APP合法性，验证成功才会运行APP。

### 公钥认证的原理

所谓的公钥认证，实际上是使用一对加密字符串，一个称为公钥(public key)，任何人都可以看到其内容，用于加密；另一个称为密钥(private key)，只有拥有者才能看到，用于解密。通过公钥加密过的密文使用密钥可以轻松解密，但根据公钥来猜测密钥却十分困难。

ssh 的公钥认证就是使用了这一特性。服务器和客户端都各自拥有自己的公钥和密钥。为了说明方便，以下将使用这些符号。

- Ac	客户端公钥
- Bc	客户端密钥
- As	服务器公钥
- Bs	服务器密钥

在认证之前，客户端需要通过某种方法将公钥 Ac 登录到服务器上。

认证过程分为两个步骤。

1. 会话密钥(session key)生成
  - 客户端请求连接服务器，服务器将 As 发送给客户端。
  - 服务器生成会话ID(session id)，设为 p，发送给客户端。
  - 客户端生成会话密钥(session key)，设为 q，并计算 r = p xor q。
  - 客户端将 r 用 As 进行加密，结果发送给服务器。
  - 服务器用 Bs 进行解密，获得 r。
  - 服务器进行 r xor p 的运算，获得 q。
  - 至此服务器和客户端都知道了会话密钥q，以后的传输都将被 q 加密。

2. 认证
  - 服务器生成随机数 x，并用 Ac 加密后生成结果 S(x)，发送给客户端
  - 客户端使用 Bc 解密 S(x) 得到 x
  - 客户端计算 q + x 的 md5 值 n(q+x)，q为上一步得到的会话密钥
  - 服务器计算 q + x 的 md5 值 m(q+x)
  - 客户端将 n(q+x) 发送给服务器
  - 服务器比较 m(q+x) 和 n(q+x)，两者相同则认证成功

  
  *注：本文参考了 [iOS Provisioning Profile(Certificate)与Code Signing详解](http://blog.csdn.net/phunxm/article/details/42685597)*   