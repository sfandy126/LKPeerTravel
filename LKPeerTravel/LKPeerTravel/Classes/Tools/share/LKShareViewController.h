//
//  LKShareViewController.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"


@interface LKShareViewController : LKBaseViewController

@property (nonatomic,copy) void (^finishedBlock)(LKShareType shreType);

@end
