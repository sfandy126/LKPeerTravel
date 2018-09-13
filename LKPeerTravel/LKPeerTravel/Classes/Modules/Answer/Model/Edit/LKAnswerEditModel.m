//
//  LKAnswerEditModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerEditModel.h"

@implementation LKAnswerEditModel


///问答编辑接口
- (void)obtainAnswerEditData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cos/question/addition" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {

        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}



@end
