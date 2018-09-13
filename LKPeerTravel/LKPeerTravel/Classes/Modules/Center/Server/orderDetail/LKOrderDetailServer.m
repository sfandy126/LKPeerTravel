//
//  LKOrderDetailServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailServer.h"

@interface LKOrderDetailServer ()

@end

@implementation LKOrderDetailServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKOrderDetailModel alloc] init];
    }
    return self;
}

///获取订单详情接口
- (void)obtainOrderDetailDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model obtainOrderDetailData:@{@"no":[NSString stringValue:self.order_id]} finishedBlock:finishedBlock failedBlock:failedBlock];
}

@end
