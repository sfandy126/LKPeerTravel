//
//  UIView+LKGesture.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer);


@interface UIView (LKGesture)

- (void)g_addTapWithTarget:(id)target action:(SEL)action;

- (void)addTarget:(id)target action:(SEL)action;

- (void)addControl_target:(id)target action:(SEL)action;

- (void)removeAllTarget;

- (void)lk_addTapGestureRecognizerWithBlock:(tapGestureRecognizerBlock)block;

@end
