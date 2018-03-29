//
//  FileMultiDownLoader.m
//  MyDemo
//
//  Created by cardvalue on 16/2/14.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import "FileMultiDownLoader.h"
#import "ChildDownloader.h"

@interface FileMultiDownLoader ()
@property (nonatomic, strong) NSMutableArray *childDownLoaders;
@property (nonatomic, assign) long long totalLength;

@end

@implementation FileMultiDownLoader

- (void)getFileSize
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    request.HTTPMethod = @"HEAD";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //文件长度
        self.totalLength = response.expectedContentLength;
        //下载器数量
        if (self.DownLoadNumber == 0) self.DownLoadNumber = 4;
        //子下载器数组
        _childDownLoaders = [[NSMutableArray alloc]init];
        //计算每个下载器的需要下载的位置长度
        long long size = 0;
        if (self.totalLength % self.DownLoadNumber == 0) {
            size = self.totalLength / self.DownLoadNumber;
        }else{
            size = self.totalLength / self.DownLoadNumber + 1;
        }
        for (int i = 0 ;  i < self.DownLoadNumber; i++) {
            ChildDownloader *singleDownLoader = [[ChildDownloader alloc]init];
            singleDownLoader.url = self.url;
            singleDownLoader.filePath = self.filePath;
            singleDownLoader.begin = i * size;
            singleDownLoader.end = singleDownLoader.begin + size -1;
            [_childDownLoaders addObject:singleDownLoader];
        }
        // 创建一个跟服务器文件等大小的临时文件
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createFileAtPath:self.filePath contents:nil attributes:nil];
        
        // 让self.destPath文件的长度是self.totalLengt
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
        [handle truncateFileAtOffset:self.totalLength];
        //开始下载
        [self.childDownLoaders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj start];
        }];
    }];
    
}
- (void)start
{
    if (self.totalLength > 1) {
        [self.childDownLoaders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj start];
        }];
    }else{
        [self getFileSize];
    }
}

- (void)pause
{
    [self.childDownLoaders makeObjectsPerformSelector:@selector(pause)];
}

@end
