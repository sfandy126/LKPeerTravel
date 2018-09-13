//
//  LKCenterServer.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterServer.h"
#import "LKOrderViewController.h"

@implementation LKCenterServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.centerModel = [[LKCenterModel alloc] initWithUserType:LKCenterModelType_upUser];
    }
    return self;
}

- (void)pushViewCtronllerWithOrderIndex:(NSInteger )index{
    LKOrderViewController *ctl = [[LKOrderViewController alloc] init];
    ctl.orderType = index;
    [LKMediator pushViewController:ctl animated:YES];
}

- (void)obtainUserDataFinished:(LKFinishedBlock)finished failed:(LKFailedBlock)failed {
    [self.centerModel obtainUserDataFinished:finished failed:failed];
}

@end
