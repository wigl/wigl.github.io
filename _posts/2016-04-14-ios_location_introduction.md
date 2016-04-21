---
layout: post
title:  "iOS后台定位"
date:   2016-04-14 00:00:00
categories: iOS后台
excerpt: 
---

* content
{:toc}


本文介绍iOS定位的三种情况：

1. iOS前台定位以及不同版本（iOS 7、8、9）之间定位的基本使用和异同点
2. iOS后台（Background）的持续定位
3. APP未运行（Not running）被用户or系统强行退出后，系统依然可以自动启动应用，进行关键位置定位`startMonitoringSignificantLocationChanges`

本文的Demo可以在[这里](https://github.com/wigl/BackgroundLocationDemo)下载查看。

## 1. iOS前台定位

**iOS定位使用步骤**

#### 1. 请求授权

从iOS 6 开始，苹果加强了对用户隐私的保护，要使用定位服务，必须先在系统配置文件`Info.plist`定义Key，用以提醒用户为何使用定位服务，从而提高用户允许定位的概率。添加了`key`和对应的`string`后，当应用需要使用定位的时候，会弹出警告框，警告框下面详细的内容就是我们`key`对应的`string`。具体的Key参照 [CocoaKeys](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html)如下：

**iOS 6 - 8** 

> 
> Key 为 `NSLocationUsageDescription`，无论`Info.plist`中是否有添加`NSLocationUsageDescription`，系统都会自动弹出警告框，让用户选择是否可以使用定位。
> 
> 具体在`Info.plist`添加如下内容：
> 
> ````
> <key>NSLocationUsageDescription</key>
	<string>这里使用定位服务的原因，提醒用户，提高用户允许定位概率</string>
> ````

 **iOS 8之后**

> 苹果修改了Key，`NSLocationUsageDescription`被废弃，改用`NSLocationWhenInUseUsageDescription`和`NSLocationAlwaysUsageDescription`。
> 
> **特别注意的是：**改动之后，系统不会自动弹出使用定位服务警告框，必须在`Info.plist`中添加Key才会弹出。
> 
> 根据自己的需求，选用不同的key，在`Info.plist`添加如下内容：
> 
> ````
> <key>NSLocationAlwaysUsageDescription</key>
	   <string>这里使用定位服务的原因，提醒用户，提高用户允许定位概率</string>
> ````
> 
> 或者
> 
> ````
> <key>NSLocationAlwaysUsageDescription</key>
	   <string>这里使用定位服务的原因，提醒用户，提高用户允许定位概率</string>
> ````
> 
> > 这两个key的异同点：
> > 
> > **相同点：**都支持后台定位
> > 
> > **不同点：**
> > 
> > * 虽然两者都支持后台定位，但是当程序进入后台，进行后台定位时候，使用`NSLocationWhenInUseUsageDescription`会导致手机上面会有个蓝色状态栏，而`NSLocationAlwaysUsageDescription`不会有这样的提示。详细信息请看本文第二部分的[iOS后台定位](#ios-1)。
> > 
> > * `NSLocationAlwaysUsageDescription` 支持区域监控(`monitor regions`)和关键位置改变定位服务(`significant location change service`)，而`NSLocationWhenInUseUsageDescription`不支持。
> > 
> > * 因为`NSLocationWhenInUseUsageDescription`不支持关键位置定位服务，所以当应用被强制关闭后，系统不会再自动唤醒程序进行定位。具体请查看看本文第三部分的[iOS应用未启动时进行定位](#ios-2)。
>  

**iOS 9 之后**

> iOS 9后，要想使用后台定位，还必须将`allowsBackgroundLocationUpdates`设置为`YES`。详细信息请看本文第二部分的[iOS后台定位](#ios-1)。
> 

#### 2. 导入头文件
定位服务基于`Core Location framework`框架，所以必须先导入头文件`#import <CoreLocation/CoreLocation.h>`。

#### 3. 创建定位管理者
创建位置管理者`CLLocationManager`,并且添加为`AppDelegate`的属性（其他类的属性亦可），目的是让位置管理`CLLocationManager`的对象被强引用，否则会被系统销毁，无法进行定位。

然后设置位置管理对象的基本属性如多远定位一次、定位精度等等。

#### 4. 请求定位
如果系统为iOS 8以上，需要定位服务，根据不同的`Info.plist`中的`key`需要调用不同的方法`requestWhenInUseAuthorization` 或者 `requestAlwaysAuthorization`。

#### 5. 设置代理，实现代理方法
设置管理对象的代理、遵守的协议以及实现响应的代理方法。

#### 6. 开始定位
`[manager startUpdatingLocation]`

#### 具体代码如下

````
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CLLocationManager *manager = [[CLLocationManager alloc]init];
    _manager = manager;
    manager.delegate = self;
    [manager setDistanceFilter:kCLLocationAccuracyBest]; //设置定位精度
    //如果是iOS8，需要进行请求定位，并根据Key判断调用哪个方法
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //下面是伪代码，根据Info.plist里面的Key判断调用哪个方法
        if (Key == NSLocationWhenInUseUsageDescription) {
            [manager requestWhenInUseAuthorization];
        }else if (Key == NSLocationAlwaysUsageDescription){
            [manager requestAlwaysAuthorization];
        }
    }
    //如果需要后台定位，key建议为NSLocationAlwaysUsageDescription，如果key值为requestWhenInUseAuthorization，那么当程序进入后台后，系统会在上面显示用户APP正在使用定位
    if (需要后台定位) {
        //iOS9特殊处理
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            [manager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    if ([CLLocationManager locationServicesEnabled]) { //是否开启了定位权限
        [manager startUpdatingLocation];//开始定位
    }
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = locations[0];
    NSLog(@"位置更新 -- %@",loc);
    NSString *locSt = [NSString stringWithFormat:@"经度%f  纬度%f 速度 %.1f",loc.coordinate.longitude,loc.coordinate.latitude,loc.speed];
}
@end
````

## 2. iOS后台定位

**iOS后台定位使用步骤**

#### 1. 开启后台定位模式
在info plist文件中对UIBackgroundModes键指定特定的值，可以在 Xcode 的 project editor 中的 Capabilities 标签页中设置，这个标签页包含了后台模式部分，可以方便配置多任务选项。如下图：
![图片](/image/ios_location_introduction/background_location_set.png)

也可以手动编辑这个值

````
<key>UIBackgroundModes</key>
	<array>
		<string>location</string>
	</array>
````

#### 2. 执行上面iOS定位的6步

#### 3. 适配iOS 9

如果系统为iOS 9，还必须必须将`allowsBackgroundLocationUpdates`设置为`YES`，否则不能进行后台定位。

至此，完成了iOS后台定位的功能。

> **注意：**
> 
> key的选择：建议为`NSLocationAlwaysUsageDescription`，如果key值为`NSLocationWhenInUseUsageDescription `，那么当程序进入后台后，系统会在上面显示用户APP正在使用定位，如下图所示：
> ![图片](/image/ios_location_introduction/iphone_location_alert.png)
> 
> 

## 3. iOS应用未启动时进行定位

这里介绍应用没有启动（被用户或者系统强制退出）或者应用在休眠状态下，依然可以进行定位。

> 据我现在的知识，应用被用户或者系统强制退出后，要想让系统后台再自动启动程序，有2种方法：
> 
> 1. 使用关键位置定位`startMonitoringSignificantLocationChanges`
> 
> 2. 使用区域检测`Region Monitoring` 
> 
> 参见：[Location and Maps Programming Guide](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/RegionMonitoring/RegionMonitoring.html#//apple_ref/doc/uid/TP40009497-CH9)
> 
> 当然，肯定不止这两种方法，我还会继续研究。当然，如果你知道有什么好的方法，可以在[这里](https://github.com/wigl/BackgroundLocationDemo/issues)告诉我，非常感谢。
> 

**iOS关键位置定位使用步骤**

#### 1.和iOS后台定位步骤一样

#### <font color="red">2.取消后台定位模式</font>
**<font color="red">特别注意：</font>**使用关键位置定位，不需要开始后台定位模式，即不需要执行[iOS后台定位中的第一步](#ios-1)。也就是说，不需要在`info.plist`文件中添加：

````
<key>UIBackgroundModes</key>
	<array>
		<string>location</string>
	</array>
````

如果开启了后台定位模式，却没有实现相应的后台定位功能，上架的时候很可能会被苹果拒绝。

PS：苹果会根据`info.plist`的key值判断是否开始了后台定位模式。

#### 3.其他注意以及需要修改的地方

> 1. key一定要选择`NSLocationAlwaysUsageDescription`。上面介绍过，`NSLocationWhenInUseUsageDescription `不支持关键位置定位。
> 
> 2. 使用关键位置定位：`[manager startMonitoringSignificantLocationChanges]`，而不是`[manager startUpdatingLocation]`。
> 

#### 4.回调时间
应用未运行的时候，如果位置发生重大改变，系统会在后台自动启动程序，并进行回调`locationManager:didUpdateLocations:`,根据苹果文档[Location and Maps Programming Guide](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/RegionMonitoring/RegionMonitoring.html#//apple_ref/doc/uid/TP40009497-CH9)，回调时间只有**10s**：

> In iOS, regions associated with your app are tracked at all times, including when the app isn’t running. If a region boundary is crossed while an app isn’t running, that app is relaunched into the background to handle the event. Similarly, if the app is suspended when the event occurs, it’s woken up and given a short amount of time **(around 10 seconds)** to handle the event. When necessary, an app can request more background execution time using the beginBackgroundTaskWithExpirationHandler: method of the UIApplication class.

所以，如果我们这时候需要执行耗时操作，比如向服务器上传位置信息，需要调用`beginBackgroundTaskWithExpirationHandler `方法，如下：
> 
> ````
> //如果你需要上传位置信息，且程序处于后台，需要调用beginBackgroundTaskWithExpirationHandler来执行网络请求操作
if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
    UIApplication *application = [UIApplication sharedApplication];
    //申请开台时间
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //上传地理位置信息..
//            NSURLSession *session = ...
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}
> ````
> 
> 具体代码可以在[这里](https://github.com/wigl/BackgroundLocationDemo)下载查看。
> 

#### 5.程序运行效果

程序运行效果如下图：
![图片](/image/ios_location_introduction/noruning_location.png)

## 4. 其他

这里我们介绍下`startUpdatingLocation`和`startMonitoringSignificantLocationChanges`的一些区别

#### 定位方式

定位方式有多种，包括GPS/基站/WIFI/蓝牙等等。

1.`startUpdatingLocation`定位具体使用哪一种由`CoreLocation`框架决定。前几天Google了，也查看了苹果的一些文档，得出如下结论：

当我们使用`startUpdatingLocation`，无法知道设备正在使用哪种方式定位，只能根据定位信息中的定位精度`horizontalAccuracy`和 `verticalAccuracy`间接判断使用哪种方式，这种方法得到的结论是正确与否不得而知。

2.`startMonitoringSignificantLocationChanges`使用的是基站定位，如果设备没有电话模块或者没有SIM卡，该功能无法使用。

#### 定位频率

1.`startUpdatingLocation`不管位置有没有发生变化，都会进行定位，定位频率比较高。当程序在后台运行的时候，也会因为资源紧张被系统挂起（suspend）或终止（terminate），从而停止定位更新。

2.`startMonitoringSignificantLocationChanges`根据基站定位，所以，只有设备更换基站的时候调用。
但是苹果文档中[Reduce Location Accuracy and Duration](https://developer.apple.com/library/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/LocationBestPractices.html)这样说：

> Significant-change location updates wake the system and your app once every 15 minutes, at minimum, even if no location changes have occurred.
> 

可是经过我测试，发现并不是15分钟启动一次系统，关于这个问题，还有待研究。

如果需要交流或者发现本文有什么错误，请在[这里](https://github.com/wigl/BackgroundLocationDemo/issues)给我留言，非常感谢！