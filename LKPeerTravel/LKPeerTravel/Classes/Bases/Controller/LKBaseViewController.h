//
//  LKBaseViewController.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKNavigationViewController.h"

@interface LKBaseViewController : UIViewController

///显示加载动画
- (void)showLoadingView;

///隐藏加载动画
- (void)hideLoadingView;

@end
