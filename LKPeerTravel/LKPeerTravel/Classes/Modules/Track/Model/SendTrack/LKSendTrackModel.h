//
//  LKSendTrackModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKSendTrackAddModel;
@class LKSendTrackInfoModel;
@interface LKSendTrackModel : LKBaseModel

@property (nonatomic,strong) LKSendTrackInfoModel *infoModel;

///添加的图片
@property (nonatomic,copy) NSArray<LKSendTrackAddModel *> *addItems;


///编辑、发布足迹
- (void)sendFootprintData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock;

@end


@class LKSendTrackPicModel;
@interface LKSendTrackInfoModel : LKBaseModel

@property (nonatomic,copy) NSString *footprintNo;///足迹编号（新增不传、编辑必传）
@property (nonatomic,copy) NSString *customerNumber;///用户编号
@property (nonatomic,copy) NSString *orderNo;///订单编号
@property (nonatomic,copy) NSString *footprintTitle;///标题
@property (nonatomic,copy) NSString *cityNo;///城市编码
@property (nonatomic,copy) NSString *cityName;///城市名称

@property (nonatomic,copy) NSString *datTravel;///出发时间 （格式 ‘yyyy-MM-dd’）
@property (nonatomic,assign) NSInteger days;///天数
@property (nonatomic,assign) NSInteger peoples;///人数
@property (nonatomic,copy) NSString *perCapital;///人均消费最少
@property (nonatomic,copy) NSString *perCapitalMax;///人均消费最多
@property (nonatomic,copy) NSArray *dataList;///图片

//仅用于显示
@property (nonatomic,copy) NSString *guider;///私人助理
@property (nonatomic,copy) NSString *travelTime;///出游时间
@property (nonatomic,copy) NSString *travelCity;///出游城市



@end


@interface LKSendTrackPicModel : LKBaseModel

@property (nonatomic,copy) NSString *imageUrl;///图片url
@property (nonatomic,copy) NSString *flagCover;///是否封面（y 是， n 否）
@property (nonatomic,copy) NSString *imageDesc;///描述

@end

///发布足迹，添加图片model
@interface LKSendTrackAddModel : LKBaseModel

///是否为添加的样式
@property (nonatomic,assign) BOOL is_add;
@property (nonatomic,copy) NSString *city_icon;
@property (nonatomic,copy) UIImage *city_image;
@property (nonatomic,assign) LKImageUploadProccess uploadProcess;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *contentAttri;

///图片frame
@property (nonatomic,strong) LKBaseFrame *iconFrame;
///正文frame
@property (nonatomic,strong) LKBaseFrame *contentFrame;
///整个cell的frame
@property (nonatomic,strong) LKBaseFrame *itemFrame;
///瀑布流的下表(NSIndexPath.item)
@property (nonatomic,assign) NSInteger itemIndex;

- (void)calculateLayoutViewFrame;

@end


