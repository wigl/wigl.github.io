---
layout: post
title:  "NSDate NSTimeZone NSDateFormatter"
date:   2014-09-03 00:00:00
categories: UIKit
excerpt: 
---

* content
{:toc}



## NSDate
封装一个时间对象，不关乎格式、时区、本地信息等。也就是说，一个NSDate对象，它只是一个时间，不包含时区、地区等信息。


## NSTimeZone

时区，抽象类，代表一个区域的时间。给一些对象提供属性，比如：NSDateFormate、NSCalendar、UIDatePicker等

#### 系统时区

`+ systemTimeZone`系统时区，如果不能获取系统时区，将会返回GMT时区。**调用该方法获时区后，会进行缓存**，如果系统时间发生改变，再次调用该方法，不会获取到最新的系统时区，而是得到之前的时区。可以调用`+ resetSystemTimeZone`清除缓存。

#### 默认时区

`+ setDefaultTimeZone:`设置默认时区。

通过 `+ defaultTimeZone`和`+ localTimeZone`都可以获取默认时区，如果没有设置默认时区，会得到系统时区。

**两者区别：**

`NSTimeZone *defaultTimeZone = [NSTimeZone defaultTimeZone];`

`NSTimeZone * localTimeZone = [NSTimeZone localTimeZone];`

`defaultTimeZone ` 和`localTimeZone `都表示默认时区。此时如果我们更改默认时区，即调用`+ setDefaultTimeZone:`方法，`defaultTimeZone `不会发生变化，而`localTimeZone `也跟着发生变化。

#### 常见用法

````
//获取系统可以识别的时区名字
NSArray *zoneNames = [NSTimeZone knownTimeZoneNames];
//通过时区名字创建时区
NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//通过GTM时差创建时区
NSTimeZone *timeZone1 = [NSTimeZone timeZoneForSecondsFromGMT:60*60*8];
````

## NSLocale

将语言、文化、公约和标准封装起来的抽象类，比如封装十进制符号，货币符号、日期显示格式等。

**问题：**`+ systemLocale` 这个到底是啥玩意啊？

**代码：**

````
//系统可识别的地区identifier
NSArray *locales = [NSLocale availableLocaleIdentifiers];
for (NSString *identifier in locales) {
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:identifier];
    //根据NSLocale：locale 和 key：NSLocaleIdentifier 格式化value：identifier 得到格式化后的NSString
    NSLog(@"%@",[locale displayNameForKey:NSLocaleIdentifier value:identifier]);
}
//根据identifier创建,zh表示中文，Hans表示简体，CN表示中国
NSLocale *newLocale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
//获取系统语言偏好设置
NSArray *languages = [NSLocale preferredLanguages];
````



## NSDateFormatter

**系统自带的格式：**

````
//系统自带格式化字符串
typedef NS_ENUM(NSUInteger, NSDateFormatterStyle) {
    NSDateFormatterNoStyle = kCFDateFormatterNoStyle,//无输出
    NSDateFormatterShortStyle = kCFDateFormatterShortStyle,//16/4/26 上午10:49
    NSDateFormatterMediumStyle = kCFDateFormatterMediumStyle,//2016年4月26日 上午10:49:08
    NSDateFormatterLongStyle = kCFDateFormatterLongStyle, //2016年4月26日 GMT+8 上午10:48:39
    NSDateFormatterFullStyle = kCFDateFormatterFullStyle //2016年4月26日 星期二 中国标准时间 上午10:51:11
};
NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
formatter.dateStyle = kCFDateFormatterFullStyle;
formatter.timeStyle = kCFDateFormatterFullStyle;
NSDate *now = [NSDate new];
NSString* outputString = [formatter stringFromDate:now];
````

**自定义格式：**

````
NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
formatter.dateFormat = @"yyyy-MM-dd a HH:mm:ss EEEE"; //2016-04-26 上午 10:56:25 星期二
NSDate *now = [NSDate new];
NSString* outputString = [formatter stringFromDate:now];
NSLog(@"%@ --- %@",outputString,formatter.timeZone);
````


## 日期字段格式表

下表引用自[ICU User Guide](http://userguide.icu-project.org/formatparse/datetime)；详细信息可以参考[unicode](view-source:http://unicode.org/reports/tr35/tr35-dates.html#Date_Field_Symbol_Table)

<table>
<tbody>
<tr bgcolor="#99ccff">
<th bgcolor="#cccccc" colspan="4" style="text-align:center;width:630px;height:49px">
<h4><a name="TOC-Date-Field-Symbol-Table"></a>Date Field Symbol Table</h4>
</th>
</tr>
<tr bgcolor="#99ccff">
<th bgcolor="#cccccc">Symbol</th>
<th bgcolor="#cccccc">Meaning</th>
<th bgcolor="#cccccc" colspan="2">Example(s)</th>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">G</td>
<td bgcolor="#eeeeee">era designator</td>
<td bgcolor="#eeeeee">G, GG, <i>or</i> GGG<br />
GGGG<br />
GGGGG</td>
<td bgcolor="#eeeeee">AD<br />
Anno Domini<br />
A</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">y</td>
<td bgcolor="#eeeeee">year</td>
<td bgcolor="#eeeeee">yy<br />
y <i>or</i> yyyy</td>
<td bgcolor="#eeeeee">96<br />
1996</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">Y</td>
<td bgcolor="#eeeeee">year of "Week of Year"</td>
<td bgcolor="#eeeeee">Y</td>
<td bgcolor="#eeeeee">1997</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">u</td>
<td bgcolor="#eeeeee">extended year</td>
<td bgcolor="#eeeeee">u</td>
<td bgcolor="#eeeeee">4601</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">U</td>
<td bgcolor="#eeeeee">cyclic year name, as in Chinese lunar calendar</td>
<td bgcolor="#eeeeee">U</td>
<td bgcolor="#eeeeee">甲子</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">r</td>
<td bgcolor="#eeeeee">related Gregorian year</td>
<td bgcolor="#eeeeee">r</td>
<td bgcolor="#eeeeee">1996</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">Q</td>
<td bgcolor="#eeeeee">quarter</td>
<td bgcolor="#eeeeee">Q<br />QQ<br />
QQQ<br />
QQQQ<br />
QQQQQ</td>
<td bgcolor="#eeeeee">2<br />02<br />
Q2<br />
2nd quarter<br />
2</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">q</td>
<td bgcolor="#eeeeee"><b>Stand Alone</b> quarter</td>
<td bgcolor="#eeeeee">q<i><br /></i>qq<br />
qqq<br />
qqqq<br />
qqqqq</td>
<td bgcolor="#eeeeee">2<br />02<br />
Q2<br />
2nd quarter<br />
2</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">M</td>
<td bgcolor="#eeeeee">month in year</td>
<td bgcolor="#eeeeee">M<br />MM<br />
MMM<br />
MMMM<br />
MMMMM</td>
<td bgcolor="#eeeeee">9<br />09<br />
Sep<br />
September<br />
S</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">L</td>
<td bgcolor="#eeeeee">Stand Alone month in year</td>
<td bgcolor="#eeeeee">L<br />LL<br />
LLL<br />
LLLL<br />
LLLLL</td>
<td bgcolor="#eeeeee">9<br />09<br />
Sep<br />
September<br />
S</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">w</td>
<td bgcolor="#eeeeee">week of year</td>
<td bgcolor="#eeeeee">w<br />ww</td>
<td bgcolor="#eeeeee">27<br />27</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">W\</td>
<td bgcolor="#eeeeee">week of month</td>
<td bgcolor="#eeeeee">W</td>
<td bgcolor="#eeeeee">2</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">d</td>
<td bgcolor="#eeeeee">day in month</td>
<td bgcolor="#eeeeee">d<br />
dd</td>
<td bgcolor="#eeeeee">2<br />
02</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">D</td>
<td bgcolor="#eeeeee">day of year</td>
<td bgcolor="#eeeeee">D</td>
<td bgcolor="#eeeeee">189</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">F</td>
<td bgcolor="#eeeeee">day of week in month</td>
<td bgcolor="#eeeeee">F
</td>
<td bgcolor="#eeeeee">2 (2nd Wed in July)</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">g</td>
<td bgcolor="#eeeeee">modified julian day</td>
<td bgcolor="#eeeeee">g</td>
<td bgcolor="#eeeeee">2451334</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">E</td>
<td bgcolor="#eeeeee">day of week</td>
<td bgcolor="#eeeeee">E, EE, <i>or</i> EEE<br />
EEEE<br />
EEEEE<br />
EEEEEE</td>
<td bgcolor="#eeeeee">Tue<br />
Tuesday<br />
T<br />
Tu</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">e</td>
<td bgcolor="#eeeeee">local day of week<br />
 example: if Monday is 1st day, Tuesday is 2nd ) </td>
<td bgcolor="#eeeeee">e <i>or </i>ee<br />
eee<br />
eeee<br />
eeeee<br />
eeeeee</td>
<td bgcolor="#eeeeee">2<br />
Tue<br />
Tuesday<br />
T<br />
Tu</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">c</td>
<td bgcolor="#eeeeee">Stand Alone local day of week</td>
<td bgcolor="#eeeeee">c <i>or </i>cc<br />
ccc<br />
cccc<br />
ccccc<br />
cccccc</td>
<td bgcolor="#eeeeee">2<br />
Tue<br />
Tuesday<br />
T<br />
Tu</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">a</td>
<td bgcolor="#eeeeee">am/pm marker</td>
<td bgcolor="#eeeeee">a</td>
<td bgcolor="#eeeeee">pm</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">h</td>
<td bgcolor="#eeeeee">hour in am/pm (1~12)</td>
<td bgcolor="#eeeeee">h<br />
hh</td>
<td bgcolor="#eeeeee">7<br />
07</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">H</td>
<td bgcolor="#eeeeee">hour in day (0~23)</td>
<td bgcolor="#eeeeee">H<br />
HH</td>
<td bgcolor="#eeeeee">0<br />
00</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">k</td>
<td bgcolor="#eeeeee">hour in day (1~24)</td>
<td bgcolor="#eeeeee">k<br />
kk</td>
<td bgcolor="#eeeeee">24<br />
24</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">K</td>
<td bgcolor="#eeeeee">hour in am/pm (0~11)</td>
<td bgcolor="#eeeeee">K<br />
KK</td>
<td bgcolor="#eeeeee">0<br />
00</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">m</td>
<td bgcolor="#eeeeee">minute in hour</td>
<td bgcolor="#eeeeee">m<br />
mm</td>
<td bgcolor="#eeeeee">4<br />
04</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">s</td>
<td bgcolor="#eeeeee">second in minute</td>
<td bgcolor="#eeeeee">s<br />
ss</td>
<td bgcolor="#eeeeee">5<br />
05</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">S</td>
<td bgcolor="#eeeeee">fractional second - truncates (like other time fields) <br />to the count of letters when formatting. Appends <br />zeros if more than 3 letters specified. Truncates at <br />three significant digits when parsing. </td>
<td bgcolor="#eeeeee">S<br />
SS<br />
SSS<br />
SSSS</td>
<td bgcolor="#eeeeee">2<br />
23<br />
235<br />
2350</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">A</td>
<td bgcolor="#eeeeee">milliseconds in day</td>
<td bgcolor="#eeeeee">A</td>
<td bgcolor="#eeeeee">61201235</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">z</td>
<td bgcolor="#eeeeee">Time Zone: specific non-location</td>
<td bgcolor="#eeeeee">z, zz, <i>or</i> zzz<br />
zzzz</td>
<td bgcolor="#eeeeee">PDT<br />
Pacific Daylight Time</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">Z</td>
<td bgcolor="#eeeeee">Time Zone: ISO8601 basic hms? / RFC 822<br />
Time Zone: long localized GMT (=OOOO)<br />
TIme Zone: ISO8601 extended hms? (=XXXXX)</td>
<td bgcolor="#eeeeee">Z, ZZ, <i>or</i> ZZZ<br />
ZZZZ<br />
ZZZZZ</td>
<td bgcolor="#eeeeee">-0800<br />
GMT-08:00<br />
-08:00, -07:52:58, Z</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">O</td>
<td bgcolor="#eeeeee">Time Zone: short localized GMT<br />
Time Zone: long localized GMT (=ZZZZ)</td>
<td bgcolor="#eeeeee">O<br />
OOOO</td>
<td bgcolor="#eeeeee">GMT-8<br />
GMT-08:00</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">v</td>
<td bgcolor="#eeeeee">Time Zone: generic non-location<br />
(falls back first to VVVV)</td>
<td bgcolor="#eeeeee">v<br />
vvvv</td>
<td bgcolor="#eeeeee">PT<br />
Pacific Time <i>or</i> Los Angeles Time</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">V</td>
<td bgcolor="#eeeeee">Time Zone: short time zone ID<br />
Time Zone: long time zone ID<br />
Time Zone: time zone exemplar city<br />
Time Zone: generic location (falls back to OOOO)</td>
<td bgcolor="#eeeeee">V<br />
VV<br />
VVV<br />
VVVV</td>
<td bgcolor="#eeeeee">uslax<br />
America/Los_Angeles<br />
Los Angeles<br />
Los Angeles Time</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">X</td>
<td bgcolor="#eeeeee">Time Zone: ISO8601 basic hm?, with Z for 0<br />
Time Zone: ISO8601 basic hm, with Z<br />
Time Zone: ISO8601 extended hm, with Z<br />
Time Zone: ISO8601 basic hms?, with Z<br />
Time Zone: ISO8601 extended hms?, with Z</td>
<td bgcolor="#eeeeee">X<br />
XX<br />
XXX<br />
XXXX<br />
XXXXX</td>
<td bgcolor="#eeeeee">-08, +0530, Z<br />
-0800, Z<br />
-08:00, Z<br />
-0800, -075258, Z<br />
-08:00, -07:52:58, Z
</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">x</td>
<td bgcolor="#eeeeee">Time Zone: ISO8601 basic hm?, without Z for 0<br />
Time Zone: ISO8601 basic hm, without Z<br />
Time Zone: ISO8601 extended hm, without Z<br />
Time Zone: ISO8601 basic hms?, without Z<br />
Time Zone: ISO8601 extended hms?, without Z</td>
<td bgcolor="#eeeeee">x<br />
xx<br />
xxx<br />
xxxx<br />
xxxxx</td>
<td bgcolor="#eeeeee">-08, +0530<br />
-0800<br />
-08:00<br />
-0800, -075258<br />
-08:00, -07:52:58</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">'</td>
<td bgcolor="#eeeeee">escape for text</td>
<td bgcolor="#eeeeee">'</td>
<td bgcolor="#eeeeee">(nothing)</td>
</tr>
<tr bgcolor="#99ccff">
<td bgcolor="#eeeeee">' '</td>
<td bgcolor="#eeeeee">two single quotes produce one</td>
<td bgcolor="#eeeeee">' '</td>
<td bgcolor="#eeeeee">'</td>
</tr>
</tbody>
</table>
