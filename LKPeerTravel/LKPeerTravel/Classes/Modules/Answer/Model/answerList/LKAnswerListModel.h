//
//  LKAnswerListModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/17.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"
#import "LKAnswerModel.h"

@interface LKAnswerListModel : LKBaseModel

@property (nonatomic,strong) NSArray *datalist;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL isLastPage;


///获取问答列表接口
- (void)obtainAnswerListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///我的问答列表接口
- (void)obtainMineAnswerListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
