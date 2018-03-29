//
//  FileSingleDownLoader.m
//  MyDemo
//
//  Created by cardvalue on 16/2/14.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import "FileSingleDownLoader.h"

@interface FileSingleDownLoader()<NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSFileHandle *writeHandle;
@property (nonatomic, assign) long long  totalLength;
@property (nonatomic, assign) long long  currentLength;

@end

@implementation FileSingleDownLoader

- (void)start
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    //设置请求头信息
    NSString *value = @"";
    value = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [urlRequest setValue:value forHTTPHeaderField:@"Range"];
    self.conn = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    _downloading = YES;
}

- (void)pause
{
    [self.conn cancel];
    self.conn = nil;
    _downloading = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.totalLength) return;
    // 1.创建一个空的文件到沙盒中
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createFileAtPath:self.filePath contents:nil attributes:nil];
    // 2.创建写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    // 3.获得完整文件的长度
    self.totalLength = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.writeHandle seekToEndOfFile];
    // 从当前移动的位置(文件尾部)开始写入数据
    [self.writeHandle writeData:data];
    // 累加长度
    self.currentLength += data.length;
    double progress = (double)self.currentLength / self.totalLength;
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.writeHandle closeFile];
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failureBlock) {
        self.failureBlock(error);
    }
}

@end
