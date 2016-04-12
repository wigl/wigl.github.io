---
layout: post
title:  "iOS后台机制"
date:   2016-04-12 00:00:00
categories: iOS后台
excerpt: 
---

* content
{:toc}

## 1. App的运行状态简介
App的运行状态包括5种，分别为：

* Not running（未运行）
* Inacctive（无效） 
* Active（前台运行） 
* Background（后台运行） 
* Suspended（休眠）

关于APP的运行状态详细过程，请查阅苹果的官方文档：[App Programming Guide for iOS](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Introduction/Introduction.html)中的 [The App Life Cycle](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/TheAppLifeCycle/TheAppLifeCycle.html#//apple_ref/doc/uid/TP40007072-CH2-SW1)

> **注意：**
> 
> 1. 以下内容均是介绍App在**Background**的运行机制，即iOS后台运行机制。
>
> 2. 如果你想要了解App在**Not running**时候如何让系统从后台启动App，比如当用户强制退出程序（双击Home键，上滑关闭程序）或者系统因为内存警告关闭程序依然可以**持续定位**，请参考这篇文章：[iOS后台定位](/2016/04/14/ios_location_introduction/)

## 2. iOS后台模式

苹果提供了下面几种后台模式，如下图，参见[App Programming Guide for iOS](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Introduction/Introduction.html)中的 [Declaring Your App’s Supported Background Tasks](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html#//apple_ref/doc/uid/TP40007072-CH4-SW1)

![后台模式](/image/ios_background_introduction/background_modes.png)

下面，我们详细介绍这几种模式

### Background fetch

#### 简介

iOS 7后新增，也称为后台获取、自动调度后台；能够处理不是很有时效性的信息获取。系统会根据应用的启动频率、时间、当前网络和电量等状况智能分配每个应用后台获取频率和启动时长。例如用于新闻、天气等App的数据定时刷新。
  
  另外，由于该接口数据的后台刷新是由操作系统统一调度的，因此系统可以在一个进程里面获得多个应用的数据，类似统一的推送机制，这样就能够最大限度地省电。不过这个方式也有一个缺点，那便是开发者不能设定数据具体什么时候更新。
  
  根据[苹果官方文档](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/index.html?hl=ar#//apple_ref/occ/intfm/UIApplicationDelegate/application:performFetchWithCompletionHandler:)，通过该方法后台获取数据，我们有**30秒**的时间执行代码，如果30秒内任务没有进行完，应用将会被强制退出 `If you do not call the completion handler in time, your app is terminated `。

#### 具体实现

**第一步：**在info plist文件中对UIBackgroundModes键指定特定的值，可以在 Xcode 的 project editor 中的 Capabilities 标签页中设置，这个标签页包含了后台模式部分，可以方便配置多任务选项。如下图：

![图片](/image/ios_background_introduction/background_fetch_set.png)

也可以手动编辑这个值

````
<key>UIBackgroundModes</key>
	<array>
		<string>fetch</string>
	</array>
````

**第二步：**告诉App多久获取一次数据，在`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`中做如下配置：

````
- (BOOL)application:(UIApplication *)application 
- didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}
````
iOS默认不进行后台获取，所以需要设置一个时间间隔，否则应用程序永远不能被后台唤醒。UIApplicationBackgroundFetchIntervalMinimum 表示希望系统尽可能频繁地唤醒应用进行后台刷新，也可以自定也设置时间，如果不需要后台进行刷新，应该把值设置为UIApplicationBackgroundFetchIntervalNever。

**第三步：**设置代理，在应用程序委托实现下面的方法

````
-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [[NSURL alloc] initWithString:@"http://yourserver.com/data.json"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                //如果获取数据失败，传入UIBackgroundFetchResultFailed
                completionHandler(UIBackgroundFetchResultFailed);
                return;
            }
            // 解析响应/数据以决定新内容是否可用
            BOOL hasNewData = ...
            if (hasNewData) {
                //如果有新数据，传入UIBackgroundFetchResultNewData
                completionHandler(UIBackgroundFetchResultNewData);
            } else {
                //如果没有新数据，传入UIBackgroundFetchResultNoData
                completionHandler(UIBackgroundFetchResultNoData);
            }
        }];
    // 开始任务
    [task resume];
}
````
当系统唤醒应用程序后，将会执行这个委托方法，特别注意的是，这个委托方法最多只能执行30秒，否则应用将会被系统强制终止。当执行完请求后，应该执行回调。

完成回调的执行有两个目的。首先，系统会估量你的进程消耗的电量，并根据你传递的 UIBackgroundFetchResult 参数记录新数据是否可用。其次，当你调用完成的处理代码时，应用的界面缩略图会被采用，并更新应用程序切换器。当用户在应用间切换时，用户将会看到新内容。

*至此，我们将完成了应用程序后台刷新的代码。*

>  注意：
>  
>   1. 当我们对应用程序设置 Background fetch 后，在iPhone的 设置->通用->后台应用程序刷新 界面中将会出现我们的应用程序，<font color="green"> 特别注意，如果我们在这里关闭应用程序刷新，那么系统将不会进行后台刷新</font>如下图：![image](/image/ios_background_introduction/iphone_background_refresh.png)
>   
>   2. <font color="green">第二点特别注意的是：如果应用被用户强制退出（双击Home键，通过多任务处理，上滑退出应用）或者被系统因为内存紧张等原因强制退出，那我们的App将不会再进行后台刷新，除非用户重新启动应用。</font>

#### 测试后台获取

测试后台获取有3中方法：

1. 从Xcode运行你的应用，当应用运行时，在 Xcode 的 Debug 菜单选择 Simulate Background Fetch.
2. 使用 scheme 更改 Xcode 运行程序的方式。在 Xcode 菜单的 Product 选项，选择 Scheme 然后选择 Manage Schemes。在这里，你可以编辑或者添加一个新的 scheme，然后选中 Launch due to a background fetch event 如下图：
![image](/image/ios_background_introduction/launch_frome_background.png)
3. 在真机上运行应用，长时间等待直到系统后台刷新了应用。

### Remote Notifications

#### 简介
iOS 7后新增，远程推送后台刷新，当我们发送一条带有 content-available 标志的远程推送通知的时候，无论应用程序在前台还是在后台，都会执行应用程序委托中的代理方法，从而实现数据刷新。这种方法非常灵活，程序可控，可以指定应用程序什么时候刷新，对于需要个性化用户后台刷新应用非常方便。

另外，无论是不是静默推送，只要带有 content-available 标志，应用程序都会进行后台刷新，所以，当我们需要刷新应用数据而不想提醒用户的时候，我们可以采用静默推送。

#### 具体实现：

**第一步：**在info plist文件中对UIBackgroundModes键指定特定的值，可以在 Xcode 的 project editor 中的 Capabilities 标签页中设置，这个标签页包含了后台模式部分，可以方便配置多任务选项。如下图：
![图片](/image/ios_background_introduction/remote_notifications_set.png)
也可以手动编辑这个值

````
<key>UIBackgroundModes</key>
	<array>
		<string>remote-notification</string>
	</array>
````
**第二步：**在应用中实现可以进行远程推送的相关代码；并设置代理，在应用程序委托实现下面的方法：

````
- (void)application:(UIApplication *)application 
  didReceiveRemoteNotification:(NSDictionary *)userInfo 
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 这里执行下载任务，和上面的后台刷新类似，请参照上面的代码
    completionHandler(UIBackgroundFetchResultNewData);
}
````

**第三步：** 进行远程推送，我采用[极光推送](https://www.jpush.cn/)的服务器进行操作。
推送的内容大致如下：

````
{
    "aps" : {
        "content-available" : 1
         "body": ... 
    }
}
````
***特别注意：`aps` 中一定要有 `content-available`字段，否则程序在后台的时候不会执行后台刷新。***
和后台抓取一样，应用程序进入后台启动，也有 30 秒的时间去获取新内容并更新界面，最后调用完成的处理代码。我们可以像后台获取那样，执行快速的网络请求。

至此，我们将完成了应用程序后台刷新的代码。

>  注意：
>  
>   1. <font color="green"> 当我们对应用程序添加远程推送刷新后后，在iPhone的 设置->通用->后台应用程序刷新界面中并不会出现我们的应用程序 </font>
>   2. <font color="green"> 即使用户在iPhone的 设置->通知 中关闭了我们应用的通知，商编的应用程序委托代理会继续调用，我们依然可以进行后台数据刷新。 </font>
>   3. <font color="green"> 最后一点特别注意的是，如果应用被用户强制退出（双击Home键，通过多任务处理，上滑退出应用）或者被系统因为内存紧张等原因强制退出，那即使推送带有content-available字段的通知，我们的App不会再进行后台刷新，除非用户重新启动应用。这点和上面的 Background fetch 一样 </font>

### Location updates
关于定位，我在[iOS后台定位](/2016/04/14/ios_location_introduction/)博客中有详细说明。


### 其他后台程序刷新
由于其他后台程序刷新功能我暂时没有用到，现在并没有细致研究。

### 延长后台持续时间
最后顺带说下这个方法，`beginBackgroundTaskWithExpirationHandler`这个API是iOS 4后加入的，当程序进入后台后，可以调用该方法向系统申请后台运行，最多10min，之后应用程序进入休眠状态。在iOS 7 之前，无论手机是否关闭屏幕，程序都会一直在后台运行，直到运行10min；iOS7又做了改变，当用户关闭屏幕，App也会同时进入休眠状态，重新唤醒时，系统重新运行剩下的时间；总的来说还是10min。

*注：本文参考了objc中国中的 [iOS 7 的多任务](http://objccn.io/issue-5-5/)*   
   
   
   
   
   