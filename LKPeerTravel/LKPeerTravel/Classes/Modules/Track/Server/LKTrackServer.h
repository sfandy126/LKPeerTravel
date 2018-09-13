//
//  LKTrackServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKTrackModel.h"

typedef NS_ENUM(NSInteger,LKTrackSelectedType) {
    LKTrackSelectedType_Hot = 1,    //热门
    LKTrackSelectedType_Newest=2,   //最新
};

@interface LKTrackServer : LKBaseServer

@property (nonatomic,strong) LKTrackModel *model;

@property (nonatomic,assign) LKTrackSelectedType selectedType;
///热门城市
@property (nonatomic,copy) NSArray *hotCitys;

///最新城市
@property (nonatomic,copy) NSArray *newestCitys;

///当前刷新类型
@property (nonatomic,assign) LKRefreshType refreshType;


///获取banner
- (void)loadTrackBannerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取城市分类列表数据
- (void)loadCityClassDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取足迹列表接口数据
- (void)loadTrackListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
