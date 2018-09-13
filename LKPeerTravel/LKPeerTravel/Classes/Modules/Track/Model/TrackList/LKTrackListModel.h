//
//  LKTrackListModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"
#import "LKTrackModel.h"

@interface LKTrackListModel : LKBaseModel

@property (nonatomic,copy) NSArray <LKTrackCityModel *>*datalist;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) NSInteger isLastPage;

- (void)loadTrackListDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end


