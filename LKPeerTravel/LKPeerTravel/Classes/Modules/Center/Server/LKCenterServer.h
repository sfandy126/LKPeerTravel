//
//  LKCenterServer.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"

#import "LKCenterModel.h"

@interface LKCenterServer : LKBaseServer

@property (nonatomic, strong) LKCenterModel *centerModel;

///根据所选订单跳转界面
- (void)pushViewCtronllerWithOrderIndex:(NSInteger )index;

- (void)obtainUserDataFinished:(LKFinishedBlock)finished failed:(LKFailedBlock)failed;

@end
