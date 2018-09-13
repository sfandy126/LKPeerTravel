//
//  LKAlertPresentDelegate.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKAlertPresentationController.h"


@interface LKAlertPresentDelegate : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresent;
@end
