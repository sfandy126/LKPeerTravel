//
//  LKTrackCityListModel.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKTrackCityListItemModel;
@interface LKTrackCityListModel : LKBaseModel

@property (nonatomic,copy) NSArray *list;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isLastPage;


///有足迹的城市列表接口
- (void)loadTrackCityDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end


@class LKTrackCityListUserModel;
@interface LKTrackCityListItemModel : LKBaseModel

@property (nonatomic,copy) NSString *cityNo;///城市id
@property (nonatomic,copy) NSString *cityNm;///城市名称
@property (nonatomic,copy) NSString *cityName;///城市别名
@property (nonatomic,copy) NSString *cityDesc;///城市描述
@property (nonatomic,copy) NSString *cityImagesUrl;///城市图片

@property (nonatomic,copy) NSArray <NSString*>*userFaces;///用户头像
@property (nonatomic,copy) NSString *footNum;///足迹数量
@property (nonatomic,copy) NSString *looks;///查看数量
@property (nonatomic,copy) NSString *comments;///回复数量


@end
