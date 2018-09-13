//
//  LKHomeCityListModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKHomeCityItemModel;
@interface LKHomeCityListModel : LKBaseModel

@property (nonatomic,strong) NSArray <LKHomeCityItemModel *>*datalists;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,assign) BOOL isLastPage;

- (void)obtainHomeCityListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end

@interface LKHomeCityItemModel: LKBaseModel

@property (nonatomic,copy) NSString *cityNo;///城市编号
@property (nonatomic,copy) NSString *cityNm;///城市别称
@property (nonatomic,copy) NSString *cityName;///城市名称
@property (nonatomic,copy) NSString *nationalName;///所属国家
@property (nonatomic,copy) NSString *cityDesc;///城市说明
@property (nonatomic,copy) NSString *datCreate;///时间
@property (nonatomic,copy) NSArray *cityImageList;///下属城市景点列表
@property (nonatomic,copy) NSString *imageUrl;///图片
@property (nonatomic,copy) NSString *txtImage;///图片说明
@property (nonatomic,copy) NSString *wishNum;///城市中的心愿数
@property (nonatomic,copy) NSString *guideNum;///城市中的导游
@end
