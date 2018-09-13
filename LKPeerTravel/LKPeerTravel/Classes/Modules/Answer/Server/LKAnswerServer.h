//
//  LKAnswerServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKAnswerModel.h"

@interface LKAnswerServer : LKBaseServer

@property (nonatomic,strong) LKAnswerModel *model;

- (void)resetParams;

///获取问答列表接口（热门）
- (void)obtainAnswerHotListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取问答列表接口（最新）
- (void)obtainAnswerLastestListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
