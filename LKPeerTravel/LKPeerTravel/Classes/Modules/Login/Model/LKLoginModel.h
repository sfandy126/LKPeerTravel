//
//  LKLoginModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@interface LKLoginModel : LKBaseModel


- (void)loginWithParams:(NSDictionary *)parmas finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock;

@end
