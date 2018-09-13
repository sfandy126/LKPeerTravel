//
//  LKLoginServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKLoginServer.h"

@implementation LKLoginServer

+ (LKLoginServer *)manager{
    static LKLoginServer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LKLoginServer alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[LKLoginModel alloc] init];
    }
    return self;
}

- (void)getCodeModelWithParams:(NSDictionary *)params successedBlock:(LKFinishedBlock)finished failedBlock:(LKFailedBlock)failed{
    [self.model requestDataWithParams:params forPath:@"tx/cos/send/verificationCode" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finished(self.model,response);
    } failed:^(LKBaseModel *item, NSError *error) {
        failed(item,error);
    }];    
}

- (void)loginWithParams:(NSDictionary *)parmas finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock{
    [self.model loginWithParams:parmas finishedBlock:finishedBlock failedBlock:failedBlock];
}


@end
