//
//  LKHomeModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"
#import "LKBannerModel.h"

typedef NS_ENUM(NSInteger,LKHomeCellType) {
    LKHomeCellType_default = 0,
    LKHomeCellType_helper=2,    //私人助手
    LKHomeCellType_hotCity=3,   //热门城市
    LKHomeCellType_hotGuide=4,  //热门导游
};

@class LKHomeGuideModel,LKHomeHotCityModel;
@interface LKHomeModel : LKBaseModel

//头部背景
@property (nonatomic,copy) NSArray<LKBannerPicModel *> *banners;

//私人助手
@property (nonatomic,strong) NSArray <LKHomeGuideModel*>*helpers;

//热门导游
@property (nonatomic,strong) NSArray <LKHomeGuideModel*>*hotGuides;

//热门城市
@property (nonatomic,strong) NSArray <LKHomeHotCityModel*>*hotCitys;


///首页banner接口
- (void)obtainHomeBanerData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///热门城市接口
- (void)obtainHomeHotCityData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///私人导游接口
- (void)obtainHomePrivateGuiderData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///热门导游接口
- (void)obtainHomeHotGuiderData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end

//导游model
@interface LKHomeGuideModel : LKBaseModel
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
@property (nonatomic,assign) BOOL isHideFooter;///是否隐藏cell底部间隙
@property (nonatomic,strong) LKBaseFrame *cellFrame;///cellframe
@property (nonatomic,strong) LKBaseFrame *bgFrame;///背景frame
@property (nonatomic,strong) LKBaseFrame *iconFrame;///iconframe
@property (nonatomic,strong) LKBaseFrame *nameFrame;///名称frame
@property (nonatomic,strong) LKBaseFrame *contentFrame;///正文frame
@property (nonatomic,strong) LKBaseFrame *tagFrame; ///标签frame
@property (nonatomic,strong) LKBaseFrame *bottomFrame;  ///底部视图frame


@end

//热门城市model
@interface LKHomeHotCityModel : LKBaseModel
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *city_icon;
@property (nonatomic,copy) NSString *city_name;
@property (nonatomic,copy) NSString *likes;

@end


