//
//  LKTrackDetailServer.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailServer.h"

@implementation LKTrackDetailServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKTrackDetailModel alloc] init];
        [self resetParams];
    }
    return self;
}

- (void)resetParams{
    self.model.page = 1;
}

///获取评论列表接口
- (void)loadCommentsFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;
    [self.model loadCommentsWithParams:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"footprintNo":[NSString stringValue:self.footprintNo]} finishedBlock:finishedBlock failedBlock:failedBlock];
}

///足迹基本信息接口
- (void)loadTrackInfoDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = 1;
    [self.model loadTrackInfoDataWithParams:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"footprintNo":[NSString stringValue:self.footprintNo]} finishedBlock:finishedBlock failedBlock:failedBlock];
}

///新增足迹评论
- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model addCommentWithParams:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

///上报浏览足迹详情接口
- (void)reportedTrackDetail{
    [self.model reportedTrackDetailWithParams:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"bussType":@"1",@"bussNumber":[NSString stringValue:self.footprintNo]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        
    } failedBlock:^(NSError *error) {
        
    }];
}

@end
