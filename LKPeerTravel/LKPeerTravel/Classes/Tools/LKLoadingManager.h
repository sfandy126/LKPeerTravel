//
//  LKLoadingManager.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/12.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  加载动画
 *
 *
 **/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LKLoadingAnimationType) {
    LKLoadingAnimationType_system,
    LKLoadingAnimationType_Jump,
};

@interface LKLoadingManager : NSObject

- (void)layoutInView:(UIView *)view;

- (void)showAnimation:(LKLoadingAnimationType )animationType;

- (void)hide;

@end
