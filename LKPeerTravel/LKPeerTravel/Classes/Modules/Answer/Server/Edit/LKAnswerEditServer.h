//
//  LKAnswerEditServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAnswerEditModel.h"

@interface LKAnswerEditServer : NSObject

@property (nonatomic,strong) LKAnswerEditModel *model;

///问答编辑接口
- (void)obtainAnswerEditDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
