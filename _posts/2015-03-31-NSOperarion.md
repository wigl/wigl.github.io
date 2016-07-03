---
layout: post
title:  "NSOperation"
date:   2015-03-31 00:00:00
categories: 多线程
excerpt: 
---

* content
{:toc}

### NSOperation是什么

NSOperation是一套面向对象的解决并行运算的API。

### NSOperation

NSOperation是用来封装操作的，它是一个抽象类，不能直接使用，需要使用它的子类。

#### NSInvocationOperation


使用下面的方法封装操作：

````
- (nullable instancetype)initWithTarget:(id)target selector:(SEL)sel object:(nullable id)arg
````

调用`start`方法来执行操作。调用`start`后，同步执行，任务会在当前线程（调用`start`方法的线程）立即开始执行，**类似于GCD中的同步执行函数**。

#### NSBlockOperation

使用下面的方法封装操作：

````
+ (instancetype)blockOperationWithBlock:(void (^)(void))block
- (void)addExecutionBlock:(void (^)(void))block //对象方法，需要先实例化一个对象（alloc init），然后添加操作。
````

和上面介绍的`start`方法一样，调用`start`后，同步执行，任务会在当前线程（调用`start`方法的线程）立即开始执行，**类似于GCD中的同步执行函数**。

**特别的：**NSBlockOperation的第一个操作和NSInvocationOperation封装的操作一样。如果NSBlockOperation封装的任务数大于1，那么操作2以及后续任务会自动开启线程（不管当前的队列是否为并行还是串行队列，也不管当前队列的最大并发数是多少，它都会自动开启线程，根据任务的多少具体开启多少线程会由系统决定）。

#### 任务操作

1. 通过`setQueuePriority`为每个任务设置优先级。
2. 通过`- (void)addDependency:(NSOperation *)op`和`- (void)removeDependency:(NSOperation *)op`为任务添加/取消依赖，从而确定操作之间的顺序。
3. 通过调用`cancel`来取消操作。
4. 可以调用`setCompletionBlock`来监听操作的完成，并进行后续操作。

### NSOperationQueue

NSOperationQueue为操作队列，可以向队列中添加任务，从而执行任务。

向队列中添加操作：

````
- (void)addOperation:(NSOperation *)op
- (void)addOperationWithBlock:(void (^)(void))block //直接添加block操作，省略掉封装操作步骤，方便使用
````

和调用`start`方法不同，向NSOperationQueue队列中添加任务（NSOperation），执行的效果类似于GCD中的**异步执行函数**，后台开始执行任务。

这个队列是并发的，要想让队列串行，只需要调用`setMaxConcurrentOperationCount`设置他的最大并发数为1即可。

也可以用下面的方法添加操作：

````
- (void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait
````
当参数`wait`设置为`YES`后，会阻塞当前线程，队列中的所有操作完成后，该方法才会返回。设置为`NO`后，该方法和上面两种添加操作的方法一样。

#### 队列的取消、暂停和恢复

不同于GCD中的队列，NSOperationQueue队列可以取消、暂停以及恢复。这些操作只是针对还未执行的任务，一旦一个任务已经开始执行，便不能再取消、暂停和恢复。

### 自定义NSOperation

我们可以继承NSOperation自定义operation，并添加额外的功能，达到自己的需求。

#### 自定义非并发

以自定义下载图片类为例，具体代码如下：

.h文件

````
#import <UIKit/UIKit.h>

typedef void(^downloadCompletionBlock)(UIImage *image); //下载完成后的block

@interface ImageDownloadOperation : NSOperation

@property (nonatomic, copy) NSString *url; //图片下载url
@property (nonatomic, copy) downloadCompletionBlock operationCompletionBlock;

@end

````

.m文件

````
#import "ImageDownloadOperation.h"

@interface ImageDownloadOperation()
{
    BOOL _finished;
    BOOL _executing;
}

@end

@implementation ImageDownloadOperation

//重写main方法
-(void)main{
    //新建一个自动释放池，因为如果是异步执行操作，我们将无法访问主线程的自动释放池
    @autoreleasepool {
        NSData *data;
        if (!self.cancelled) {
            NSURL *url = [NSURL URLWithString:_url];
            data = [NSData dataWithContentsOfURL:url];
        }
        //KVO
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        _finished = NO;
        _executing = YES;
        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
        if (_operationCompletionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程中执行下载完成操作
                _operationCompletionBlock([UIImage imageWithData:data]);
            });
        }
    }
}

-(void)start{
    //操作已经取消
    if (self.cancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }else{
        [self willChangeValueForKey:@"isExecuting"];
        _executing = YES;
        [self performSelectorOnMainThread:@selector(main) withObject:nil waitUntilDone:NO];
        [self didChangeValueForKey:@"isExecuting"];
    }
}

-(BOOL)isFinished{
    return _finished;
}

-(BOOL)isExecuting{
    return _executing;
}

@end

````

### NSOperation和GCD的区别

> 1. GCD为C语言API；NSOperation为OC语言，且面向对象。因此GCD相比执行速度更快些。
> 2. GCD队列为FIFO，且设置任务之间的依赖比较复杂（可以使用信号量等方法）；NSOperation的队列可以设置任务的设置依赖，执行优先级等。
> 3. GCD设置最大并发数比较复杂；而NSOperation可以很方便设置。
> 4. NSOperation队列可以取消、暂停、恢复。
> 5. NSOperation支持KVO，可以监测任务是否在执行、是否结束、是否取消等。
