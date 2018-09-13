//
//  LKTrackOrderListModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKTrackOrderListItemModel;
@interface LKTrackOrderListModel : LKBaseModel

@property (nonatomic,copy) NSArray<LKTrackOrderListItemModel*> *list;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isLastPage;

- (void)loadTrackOrderDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;


@end

@interface LKTrackOrderListItemModel : LKBaseModel

@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *guider;
@property (nonatomic,copy) NSString *travelTime;
@property (nonatomic,copy) NSString *travelCity;

@property (nonatomic,assign) BOOL isSelected;

@end
