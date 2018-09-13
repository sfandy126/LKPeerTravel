//
//  LKImageBrowseServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKImageBrowseModel.h"

@interface LKImageBrowseServer : NSObject

@property (nonatomic,strong) LKImageBrowseModel *model;


///新增足迹评论
- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
