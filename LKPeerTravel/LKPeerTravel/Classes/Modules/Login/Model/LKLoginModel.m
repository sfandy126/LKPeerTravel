//
//  LKLoginModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKLoginModel.h"

@implementation LKLoginModel

- (void)loginWithParams:(NSDictionary *)parmas finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock{
    [self requestDataWithParams:parmas forPath:@"tx/cif/customer/login" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            finishedBlock(response,YES);
        }else{
            finishedBlock(response,NO);
        }
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}



@end
