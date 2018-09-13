//
//  LKAnswerServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerServer.h"

@implementation LKAnswerServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKAnswerModel alloc] init];
        [self resetParams];
    }
    return self;
}

- (void)resetParams{
    self.model.page = 1;
}

///获取问答列表接口（热门）
- (void)obtainAnswerHotListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = 1;
    [self.model obtainAnswerHotListData:@{@"questionListType":@"2",@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:finishedBlock failedBlock:failedBlock];
}

///获取问答列表接口（最新）
- (void)obtainAnswerLastestListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;
    [self.model obtainAnswerLastestListData:@{@"questionListType":@"1",@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:finishedBlock failedBlock:failedBlock];
}
@end
