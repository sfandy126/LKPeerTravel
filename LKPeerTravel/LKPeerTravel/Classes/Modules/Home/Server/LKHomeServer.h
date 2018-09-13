//
//  LKHomeServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKHomeModel.h"

@interface LKHomeServer : LKBaseServer
@property (nonatomic,strong)LKHomeModel *model;
@property (nonatomic,assign) BOOL isLoadMore;
@property (nonatomic,strong) NSArray *hotGuides;
@property (nonatomic,assign) NSInteger page;

///选择的城市Id
@property (nonatomic,strong)NSString *selected_city_id;

@property (nonatomic,strong)NSString *selected_city_name;

//获取cell类型
- (LKHomeCellType )getHomeCellType:(NSInteger )section;

///首页banner接口
- (void)obtainHomeBanerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///热门城市接口
- (void)obtainHomeHotCityDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///私人导游接口
- (void)obtainHomePrivateGuiderDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///热门导游接口
- (void)obtainHomeHotGuiderDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
