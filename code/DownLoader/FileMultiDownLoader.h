//
//  FileMultiDownLoader.h
//  MyDemo
//
//  Created by cardvalue on 16/2/14.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileMultiDownLoader : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) int DownLoadNumber;

- (void)start;
- (void)pause;

@end
