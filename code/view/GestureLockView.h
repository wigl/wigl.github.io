//
//  GestureLockView.h
//  MyDemo
//
//  Created by cardvalue on 16/2/23.
//  Copyright © 2016年 niels.jin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GestureLockView;

@protocol GestureLockViewDelegate <NSObject>

- (void)lockViewDidClick:(GestureLockView *)gestureLockView passWord:(NSString *)password;

@end

@interface GestureLockView : UIView
@property (nonatomic, weak) id<GestureLockViewDelegate> delegate;

@end
