//
//  UIViewController+LKStatusBarStyle.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIViewController+LKStatusBarStyle.h"

#import <objc/runtime.h>

static const char * LK_STATUS_BAR_LIGHT_KEY = "LK_STATUS_BAR_LIGHT_KEY";

@implementation UIViewController (LKStatusBarStyle)

- (void)setLK_lightStatusBar:(BOOL)LK_lightStatusBar {
    objc_setAssociatedObject(self, LK_STATUS_BAR_LIGHT_KEY, [NSNumber numberWithInt:LK_lightStatusBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)LK_lightStatusBar {
    return objc_getAssociatedObject(self, LK_STATUS_BAR_LIGHT_KEY) ? [objc_getAssociatedObject(self, LK_STATUS_BAR_LIGHT_KEY) boolValue] : NO;
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.LK_lightStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

@end
