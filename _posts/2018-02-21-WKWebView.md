---
layout: post
title:  "WKWebView"
date:   2018-02-21 00:00:00
categories: App
excerpt: 
---

* content
{:toc}


### WebKit

[WKWebView 那些坑](https://mp.weixin.qq.com/s?__biz=MzA3NTYzODYzMg==&mid=2653578513&idx=1&sn=961bf5394eecde40a43060550b81b0bb&chksm=84b3b716b3c43e00ee39de8cf12ff3f8d475096ffaa05de9c00ff65df62cd73aa1cff606057d&mpshare=1&scene=1&srcid=0214nkrYxApaVTQcGw3U9Ryp)

## 拦截请求

### 1. 使用URLProtocol

**首先定义协议**

````
import Foundation
import WebKit

private let session = URLSession.init(configuration: .default)

class WKURLProtocol: URLProtocol {
    
    internal var dataTask: URLSessionDataTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = self.request.url,
            let fileURL = Bundle.main.url(forResource: "static\(url.path)", withExtension: nil),
            FileManager.default.fileExists(atPath: fileURL.path) {
            let task = session.dataTask(with: fileURL) { [weak self] (data, response, error) in
                guard let `self` = self else { return }
                if let da = data, let rep = response {
                    self.client?.urlProtocol(self, didReceive: rep, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                    self.client?.urlProtocol(self, didLoad: da)
                    self.client?.urlProtocolDidFinishLoading(self)
                } else if let err = error {
                    self.client?.urlProtocol(self, didFailWithError: err)
                } else {
                    self.client?.urlProtocolDidFinishLoading(self)
                }
            }
            self.dataTask = task
            task.resume()
        } else {
            let task = session.dataTask(with: self.request) { [weak self] (data, response, error) in
                guard let `self` = self else { return }
                if let da = data, let rep = response {
                    self.client?.urlProtocol(self, didReceive: rep, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                    self.client?.urlProtocol(self, didLoad: da)
                    self.client?.urlProtocolDidFinishLoading(self)
                } else if let err = error {
                    self.client?.urlProtocol(self, didFailWithError: err)
                } else {
                    self.client?.urlProtocolDidFinishLoading(self)
                }
            }
            self.dataTask = task
            task.resume()
        }
    }
    
    override func stopLoading() {
        dataTask?.cancel()
    }
    
}


// MARK: - register

extension String {
    fileprivate func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

private let browsingContextControllerClass: AnyClass = {
    // browsingContextController
    if let str = "YnJvd3NpbmdDb250ZXh0Q29udHJvbGxlcg==".fromBase64(),
        let obj = WKWebView.init().value(forKey: str),
        let c = type(of: obj) as? AnyClass {
        // WKBrowsingContextController
        return c
    } else  {
        return NSObject.self
    }
}()

private let registerSelector: Selector = {
    // registerSchemeForCustomProtocol:
    let str = "cmVnaXN0ZXJTY2hlbWVGb3JDdXN0b21Qcm90b2NvbDo=".fromBase64() ?? ""
    let sel = Selector.init((str))
    return sel
}()

private let unregisterSelector: Selector = {
    // unregisterSchemeForCustomProtocol:
    let str = "dW5yZWdpc3RlclNjaGVtZUZvckN1c3RvbVByb3RvY29sOg==".fromBase64() ?? ""
    let sel = Selector.init((str))
    return sel
}()

extension WKURLProtocol {
    
    @discardableResult
    static func register(scheme: String) -> Bool {
        if browsingContextControllerClass.responds(to: registerSelector) {
            browsingContextControllerClass.performSelector(onMainThread: registerSelector, with: scheme, waitUntilDone: false)
            return true
        } else  {
            return false
        }
    }
    
    @discardableResult
    static func unregister(scheme: String) -> Bool {
        if browsingContextControllerClass.responds(to: registerSelector) {
            browsingContextControllerClass.performSelector(onMainThread: unregisterSelector, with: scheme, waitUntilDone: false)
            return true
        } else  {
            return false
        }
    }
    
}

````

**再进行注册**

````
URLProtocol.registerClass(WKURLProtocol.self)
WKURLProtocol.register(scheme: "https")
````

参考：
 
[WKWebViewWithURLProtocol](https://github.com/WildDylan/WKWebViewWithURLProtocol)

[wkwebview-and-nsurlprotocol-not-working](https://stackoverflow.com/questions/24208229/wkwebview-and-nsurlprotocol-not-working) 


### 2. 使用WKURLSchemeHandler




