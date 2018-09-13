//
//  LKSearchModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

///搜索类型
typedef NS_ENUM(NSInteger,LKSearchType) {
    LKSearchType_all=0, ///搜索全部
    LKSearchType_guide=1,///搜索导游
    LKSearchType_track=2,///搜索足迹
    LKSearchType_answer=3,///搜索问答
};

@class LKSearchListModel;
@class LKSearchGuideModel,LKSearchTrackModel,LKSearchAnswerModel;

@interface LKSearchModel : LKBaseModel

@property (nonatomic,strong) LKSearchListModel *guideListModel;
@property (nonatomic,strong) LKSearchListModel *trackListModel;
@property (nonatomic,strong) LKSearchListModel *answerListModel;

- (void)obtainSearchListDataWithParams:(NSDictionary *)params finishedBlock:(LKFinishedBlock)finishedBlock failedBlock:(LKFailedBlock)failedBlock;

@end

@interface LKSearchListModel : LKBaseModel
@property (nonatomic,copy) NSArray *datalists;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isLastPage;
@property (nonatomic,strong) NSMutableArray *tempList;

@end

@interface LKSearchGuideModel : LKBaseModel
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

@interface LKSearchTrackModel : LKBaseModel
@property (nonatomic,copy) NSString *footprintNo;///足迹编号
@property (nonatomic,copy) NSString *footprintTitle;///足迹标题
@property (nonatomic,copy) NSString *comments;///回复数
@property (nonatomic,copy) NSString *looks;///浏览数
@property (nonatomic,copy) NSString *customerNm;///昵称
@property (nonatomic,copy) NSString *portraitPic;///头像
@property (nonatomic,copy) NSString *customerNumber;///客户编号
@property (nonatomic,copy) NSString *cityNo;///城市编号（目的地）
@property (nonatomic,copy) NSString *cityName;///城市名（目的地）
@property (nonatomic,copy) NSArray *cityImageList;///图片列表

@end

@interface LKSearchAnswerModel : LKBaseModel

@property (nonatomic,copy) NSString *questionNo;///问题编号
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,copy) NSString *face;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *contentAttri;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *looks;
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) NSString *datCreate;


//最新cell frame
@property (nonatomic,strong) LKBaseFrame *newestCellFrame;//cellframe
@property (nonatomic,strong) LKBaseFrame *newesBgFrame;//标题frame
@property (nonatomic,strong) LKBaseFrame *newesTitleFrame;//标题frame
@property (nonatomic,strong) LKBaseFrame *newestContentFrame;//正文frame
@property (nonatomic,strong) LKBaseFrame *newestUserFrame;//用户信息frame

@property (nonatomic,strong) LKBaseFrame *lookFrame;
@property (nonatomic,strong) LKBaseFrame *commentFrame;

@end

