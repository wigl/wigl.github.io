//
//  FileSingleDownLoader.h
//  MyDemo
//
//  Created by cardvalue on 16/2/14.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSingleDownLoader : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, readonly, assign, getter=isDownloading) BOOL downloading;
@property (nonatomic, copy) void (^progressBlock)(double progress);
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, copy) void (^failureBlock)(NSError *error);

- (void)start;
- (void)pause;

@end
