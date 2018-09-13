//
//  LKOrderDetailModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"
#import "LKOrderModel.h"

@class LKOrderDetailShopModel;
@interface LKOrderDetailModel : LKBaseModel

@property (nonatomic,copy) NSString *orderNo;///订单编号
@property (nonatomic,copy) NSString *dateStart;///开始时间
@property (nonatomic,copy) NSString *dateEnd;///结束时间
@property (nonatomic,copy) NSString *point;///价格
@property (nonatomic,copy) NSString *dNum;///天数
@property (nonatomic,copy) NSString *pNum;///人数
@property (nonatomic,copy) NSString *discount;///折扣
@property (nonatomic,assign) BOOL flagCar;///是否要车, 1-是;0-否
@property (nonatomic,assign) BOOL flagPlane;///是否安排接机, 1-是;0-否
@property (nonatomic,copy) NSString *amtOrderCharge;///支付金额
@property (nonatomic,copy) NSString *codOrderStatus;///订单状态
@property (nonatomic,copy) NSString *datEffective;///截止时间
@property (nonatomic,copy) NSString *datCreate;///下单时间
@property (nonatomic,copy) NSString *userName;///用户名称
@property (nonatomic,copy) NSString *guideName;///用户名称

@property (nonatomic,copy) NSString *phone;///手机号码
@property (nonatomic,copy) NSString *cityName;///城市名称
@property (nonatomic,copy) NSString *jobs;///语言
@property (nonatomic,copy) NSString *amtOrderProcess;///总价

@property (nonatomic,copy) NSArray <LKOrderSingleShopModel *>*selectedServe;///用户选定的服务
@property (nonatomic,assign) CGFloat serveHeight;///用户选定服务的高度

@property (nonatomic,assign) NSInteger commentFlag;//    int    是否已评价，0-否；1-是
@property (nonatomic,assign) NSInteger replayFlag;//    int    是否已回复，0-否；1-是

@property (nonatomic, strong) NSDictionary *commentDict;

///获取订单详情接口
- (void)obtainOrderDetailData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end


