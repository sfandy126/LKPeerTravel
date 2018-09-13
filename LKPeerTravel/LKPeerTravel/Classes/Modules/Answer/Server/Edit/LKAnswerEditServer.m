//
//  LKAnswerEditServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerEditServer.h"

@implementation LKAnswerEditServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKAnswerEditModel alloc] init];
    }
    return self;
}


///问答编辑接口
- (void)obtainAnswerEditDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    NSDictionary *params = @{@"customerNumber":[LKUserInfoUtils getUserNumber],
                             @"questionTitle":[NSString stringValue:self.model.title],
                             @"questionContent":[NSString stringValue:self.model.content],
                             @"codCityNo":[NSString stringValue:self.model.city_id],
                             @"codIsHiden":(self.model.isAnonymity?@"1":@"2"),
                             };
    [self.model obtainAnswerEditData:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

@end
