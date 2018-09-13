//
//  LKPresentationController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKPresentationController : UIPresentationController
@property (nonatomic, assign) CGRect presentFrame;
@property (nonatomic, assign) BOOL isEffect;
@property (nonatomic, assign) BOOL unClickDismiss;
@property (nonatomic, assign) BOOL showDismissAmination;

@end
