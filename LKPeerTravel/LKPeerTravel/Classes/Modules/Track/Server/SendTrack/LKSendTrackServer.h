//
//  LKSendTrackServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKSendTrackModel.h"

@interface LKSendTrackServer : NSObject

@property (nonatomic,strong) LKSendTrackModel *model;

///编辑、发布足迹
- (void)sendFootprintDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock;

@end
