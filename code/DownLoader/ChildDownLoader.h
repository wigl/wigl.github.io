//
//  ChildDownLoader.h
//  MyDemo
//
//  Created by cardvalue on 16/2/14.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChildDownloader : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) long long begin;
@property (nonatomic, assign) long long end;
@property (nonatomic, assign) long long  currentLength;

- (void)start;
- (void)pause;

@end