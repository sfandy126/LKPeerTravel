//
//  LKGuideListModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKGuideListItemModel;
@interface LKGuideListModel : LKBaseModel

@property (nonatomic,copy) NSArray <LKGuideListItemModel*>*list;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isLastPage;


///城市中的导游列表接口
- (void)obtainGuideListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end

@interface LKGuideListItemModel : LKBaseModel

@property (nonatomic,copy) NSString *uid;//导游编号
@property (nonatomic,copy) NSString *face;//头像
@property (nonatomic,copy) NSString *nick_name;//昵称
@property (nonatomic,copy) NSString *location;//定位地点
@property (nonatomic,assign) BOOL isVoice;///是否有语音
@property (nonatomic,copy) NSString *voiceUrl;//语音链接
@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,copy) NSAttributedString *contentAttri;//内容
@property (nonatomic,strong) NSArray<NSString *> *tags;//标签
@property (nonatomic,copy) NSString *server_num;//已服务次数
@property (nonatomic,copy) NSString *comments;//评论数
@property (nonatomic,copy) NSString *star;//星级

///热门导游cell
@property (nonatomic,strong) LKBaseFrame *cellFrame;///cellframe
@property (nonatomic,strong) LKBaseFrame *bgFrame;///背景frame
@property (nonatomic,strong) LKBaseFrame *iconFrame;///iconframe
@property (nonatomic,strong) LKBaseFrame *nameFrame;///名称frame
@property (nonatomic,strong) LKBaseFrame *contentFrame;///正文frame
@property (nonatomic,strong) LKBaseFrame *tagFrame; ///标签frame
@property (nonatomic,strong) LKBaseFrame *bottomFrame;  ///底部视图frame

@end
