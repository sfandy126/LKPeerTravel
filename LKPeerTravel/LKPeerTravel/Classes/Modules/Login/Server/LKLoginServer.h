//
//  LKLoginServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  管理所有地方的登录相关处理
 *
 *
 **/

#import "LKBaseServer.h"
#import "LKLoginModel.h"

@interface LKLoginServer : LKBaseServer
@property (nonatomic,strong) LKLoginModel *model;

+ (LKLoginServer *)manager;

- (void)getCodeModelWithParams:(NSDictionary *)params successedBlock:(LKFinishedBlock)finished failedBlock:(LKFailedBlock)failed;

- (void)loginWithParams:(NSDictionary *)parmas finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock;


@end
