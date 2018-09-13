//
//  UIResponder+firstResponder.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIResponder+firstResponder.h"

static __weak id wty_currentFirstResponder;

@implementation UIResponder (firstResponder)
+ (id)lk_currentFirstResponder {
    wty_currentFirstResponder = nil;
    // 通过将target设置为nil，让系统自动遍历响应链
    // 从而响应链当前第一响应者响应我们自定义的方法
    [[UIApplication sharedApplication] sendAction:@selector(lk_findFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return wty_currentFirstResponder;
}
- (void)lk_findFirstResponder:(id)sender {
    // 第一响应者会响应这个方法，并且将静态变量wty_currentFirstResponder设置为自己
    wty_currentFirstResponder = self;
}
@end

