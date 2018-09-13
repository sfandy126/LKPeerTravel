//
//  UIView+LKViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LKViewController)

/// 当前视图最近一级的UIViewController
@property (nonatomic, strong, readonly) UIViewController *lk_viewController;

@end
