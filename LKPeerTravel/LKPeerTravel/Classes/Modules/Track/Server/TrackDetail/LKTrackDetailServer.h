//
//  LKTrackDetailServer.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKTrackDetailModel.h"

@interface LKTrackDetailServer : NSObject

@property (nonatomic,copy) NSString *footprintNo;

@property (nonatomic,strong) LKTrackDetailModel *model;

- (void)resetParams;

///获取评论列表接口
- (void)loadCommentsFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///上报浏览足迹详情接口
- (void)reportedTrackDetail;

///新增足迹评论
- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///足迹基本信息接口
- (void)loadTrackInfoDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
