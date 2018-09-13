//
//  LKTrackDetailModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKTrackInfoModel,LKTrackCommentModel;
@interface LKTrackDetailModel : LKBaseModel

@property (nonatomic,strong) LKTrackInfoModel *infoModel;

@property (nonatomic,copy) NSArray <LKTrackCommentModel *>*comments;

@property (nonatomic,assign) NSInteger page;


///上报浏览足迹详情接口
- (void)reportedTrackDetailWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///足迹基本信息接口
- (void)loadTrackInfoDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///新增足迹评论
- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取评论列表接口
- (void)loadCommentsWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;


@end


@interface LKTrackInfoModel : LKBaseModel

@property (nonatomic,copy) NSString *city_id;///城市编号
@property (nonatomic,copy) NSString *city_country;//城市所属国家
@property (nonatomic,copy) NSString *city_name;//城市名称
@property (nonatomic,copy) NSString *city_icon;//城市背景
@property (nonatomic,copy) NSArray *city_icons;//城市背景多图

@property (nonatomic,copy) NSString *uid;//导游
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,copy) NSString *face;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *looks;
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) NSString *footprintNo;///足迹编号

@property (nonatomic,copy) NSString *datTravel;///出发时间
@property (nonatomic,copy) NSString *datTravelStr;///转换后的出发时间
@property (nonatomic,copy) NSString *days;///天数
@property (nonatomic,copy) NSString *peoples;///人数
@property (nonatomic,copy) NSString *perCapital;///最低人均消费
@property (nonatomic,copy) NSString *perCapitalMax;///最高人均消费

@end

@interface LKTrackCommentModel : LKBaseModel

@property (nonatomic,copy) NSString *commentNo;///评论编号
@property (nonatomic,copy) NSString *commentContent;///评论内容
@property (nonatomic,copy) NSString *datCreate;///评论时间
@property (nonatomic,copy) NSString *commentCustomerNumber;///评论人编号
@property (nonatomic,copy) NSString *customerNm;///昵称
@property (nonatomic,copy) NSString *portraitPic;///头像
@property (nonatomic,copy) NSString *footprintNo;///足迹编号
@property (nonatomic,copy) NSString *commentStatus;///
@property (nonatomic,copy) NSArray *comments;///子集评论

@end
