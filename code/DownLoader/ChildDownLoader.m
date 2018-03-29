//
//  ChildDownLoader.m
//  MyDemo
//
//  Created by cardvalue on 16/2/14.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import "ChildDownloader.h"

@interface ChildDownloader()<NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSFileHandle *writeHandle;

@end

@implementation ChildDownloader

- (void)start
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    NSString *value = @"";
    value = [NSString stringWithFormat:@"bytes=%lld-%lld",self.begin + self.currentLength, self.end];
    [urlRequest setValue:value forHTTPHeaderField:@"Range"];
    self.conn = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
}

- (void)pause
{
    [self.conn cancel];
    self.conn = nil;
}

- (NSFileHandle *)writeHandle
{
    if (!_writeHandle) {
        _writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    }
    return _writeHandle;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.writeHandle seekToFileOffset:self.begin + self.currentLength];
    [self.writeHandle writeData:data];
    self.currentLength += data.length;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.writeHandle closeFile];
}

@end

