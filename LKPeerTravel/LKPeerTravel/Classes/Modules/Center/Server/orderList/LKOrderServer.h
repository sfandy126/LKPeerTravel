//
//  LKOrderServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKOrderModel.h"

@interface LKOrderServer : LKBaseServer
///订单类型
@property (nonatomic,assign) LKOrderType orderType;
///所有订单
@property (nonatomic,strong) NSArray <LKOrderListModel *>*allOrders;
///待支付订单
@property (nonatomic,strong) NSArray <LKOrderListModel *>*waitPayOrders;
///已支付订单
@property (nonatomic,strong) NSArray <LKOrderListModel *>*payedOrders;
///已完成订单
@property (nonatomic,strong) NSArray <LKOrderListModel *>*finishedOrders;
///已取消订单
@property (nonatomic,strong) NSArray <LKOrderListModel *>*canceledOrders;

/// 0-待支付 1-已支付 -1-已取消 2-已完成 3-待确认 4-已确认 不传则查询所有 订单
@property (nonatomic, assign) NSInteger staus;

@property (nonatomic, assign) NSInteger clickIndex;
/// 订单状态和点击位置的对照表
@property (nonatomic, strong) NSDictionary *orderIndexMap;
/// 
@property (nonatomic,strong) NSDictionary *typeModelMap;

///根据订单类型，重置对应的参数
- (void)resetParamsWithOrderType:(LKOrderType )type;

- (void)resetParams;

///获取订单列表接口
- (void)obtainOrderListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///更新订单状态接口
- (void)updateOrderStatusData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
