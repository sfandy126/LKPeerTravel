//
//  LKAnswerDetailModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKAnswerCommentModel;
@interface LKAnswerDetailModel : LKBaseModel

@property (nonatomic,copy) NSArray <LKAnswerCommentModel *>*comments;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL isLastPage;

///上报浏览详情接口
- (void)reportedAnswerDetailWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///上传评论
- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取评论列表接口
- (void)loadCommentsWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end

@interface LKAnswerCommentModel : LKBaseModel

@property (nonatomic,copy) NSString *answerNo;///问题编号
@property (nonatomic,copy) NSString *questionNo;///答案编号
@property (nonatomic,copy) NSString *answerContent;///评论内容
@property (nonatomic,copy) NSString *datCreate;///评论时间
@property (nonatomic,copy) NSString *customerNumber;///评论人编号
@property (nonatomic,copy) NSString *customerNm;///昵称
@property (nonatomic,copy) NSString *portraitPic;///头像
@property (nonatomic,copy) NSString *commentStatus;///
@property (nonatomic,copy) NSArray *comments;///子集评论

@end
