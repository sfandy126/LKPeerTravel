//
//  LKAnswerEditModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@interface LKAnswerEditModel : LKBaseModel

///标题
@property (nonatomic,copy) NSString *title;
///内容
@property (nonatomic,copy) NSString *content;
///城市编号
@property (nonatomic,copy) NSString *city_id;
///是否匿名
@property (nonatomic,assign) BOOL isAnonymity;


///问答编辑接口
- (void)obtainAnswerEditData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
