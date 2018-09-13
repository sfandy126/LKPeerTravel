//
//  LKImageBrowseServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKImageBrowseServer.h"

@implementation LKImageBrowseServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKImageBrowseModel alloc] init];
    }
    return self;
}

///新增足迹评论
- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model addCommentWithParams:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

@end
