//
//  LKActionSheetDelegate.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKActionSheetDelegate : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect presentFrame;          ///< 视图尺寸
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL isEffect;                ///< 是否显示背景
@property (nonatomic, assign) BOOL unClickDismiss;          ///< 点击背景不隐藏
@property (nonatomic, assign) BOOL showDismissAmination;    ///< 是否显示消失动画
@property (nonatomic, assign) CGFloat animationDuration;
@end
