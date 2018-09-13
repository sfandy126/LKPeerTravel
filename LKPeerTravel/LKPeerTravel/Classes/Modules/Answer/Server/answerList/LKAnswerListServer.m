//
//  LKAnswerListServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/17.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerListServer.h"

@interface LKAnswerListServer ()

@end

@implementation LKAnswerListServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKAnswerListModel alloc] init];
        self.questionListType = @"1";
        [self resetParams];
    }
    return self;
}

- (void)resetParams{
    self.model.page = 1;
}

///获取问答列表接口
- (void)obtainAnswerListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    if ([self.questionListType isEqualToString:@"isMine"]) {
        pageInfo.pageNum = 1;
        [self.model obtainMineAnswerListData:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:finishedBlock failedBlock:failedBlock];
    }else{
        pageInfo.pageNum = self.model.page;
        [self.model obtainAnswerListData:@{@"questionListType":self.questionListType,@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:finishedBlock failedBlock:failedBlock];
    }

}

@end
