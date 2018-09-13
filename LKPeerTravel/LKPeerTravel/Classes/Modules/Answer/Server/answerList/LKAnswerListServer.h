//
//  LKAnswerListServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/17.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAnswerListModel.h"

@interface LKAnswerListServer : NSObject

@property (nonatomic,strong) LKAnswerListModel *model;

///问题列表类型 （1-最新;2-热门,3-没回答的,isMine-我的）
@property (nonatomic,strong) NSString *questionListType;


- (void)resetParams;

///获取问答列表接口
- (void)obtainAnswerListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
