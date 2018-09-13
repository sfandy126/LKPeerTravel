//
//  LKOrderModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

///订单列表类型
typedef NS_ENUM(NSInteger,LKOrderType) {
    LKOrderType_all=0,          ///全部订单
    LKOrderType_waitPay=1,      ///待支付
    LKOrderType_payed=2,        ///已支付
    LKOrderType_finished=3,     ///已完成
    LKOrderType_cancel=4,       ///已取消
};

///订单按钮操作类型
typedef NS_ENUM(NSInteger,LKOrderHandleType) {
    LKOrderHandleType_none=0,       ///不做处理
    LKOrderHandleType_pay,          ///去支付
    LKOrderHandleType_cancel,       ///取消订单
    LKOrderHandleType_sure,         ///确认订单
    LKOrderHandleType_evaluate,     ///去评价
    LKOrderHandleType_reservation,  ///再次预定
    LKOrderHandleType_service,      ///开始服务
    LKOrderHandleType_kefu,         ///联系客服
    LKOrderHandleType_complete,     /// 完成
};

@class LKOrderListModel,LKOrderTypeModel;
@interface LKOrderModel : LKBaseModel

@property (nonatomic,strong) LKOrderTypeModel *allModel;
/// 待支付
@property (nonatomic,strong) LKOrderTypeModel *waitPayModel;
/// 已支付
@property (nonatomic,strong) LKOrderTypeModel *payedModel;
/// 已完成
@property (nonatomic,strong) LKOrderTypeModel *finishedModel;
/// 已取消
@property (nonatomic,strong) LKOrderTypeModel *cancelModel;
/// 待确认
@property (nonatomic,strong) LKOrderTypeModel *waitConfirmModel;
/// 已确认
@property (nonatomic,strong) LKOrderTypeModel *confirmedModel;

///获取订单列表接口
- (void)obtainOrderListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///更新订单状态接口
- (void)updateOrderStatusData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end

@interface LKOrderTypeModel : LKBaseModel

@property (nonatomic,assign) BOOL isLastPage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) LKOrderType orderType;
///订单列表
@property (nonatomic,copy) NSArray <LKOrderListModel *>*listData;

@end


@class LKOrderSingleShopModel;
@interface LKOrderListModel : LKBaseModel
///订单编号
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *order_display_id;

//出行时间
@property (nonatomic,copy) NSString *start_time;
@property (nonatomic,copy) NSString *end_time;
///订单状态
@property (nonatomic,copy) NSString *order_state;
///是否已评价
@property (nonatomic,assign) BOOL is_evaluated;
///总价
@property (nonatomic,copy) NSString *total_price;
///当前订单中所有的商品
@property (nonatomic,copy) NSArray<LKOrderSingleShopModel *> *shops;
///商品视图高度
@property (nonatomic,assign) CGFloat shopsHeight;


@property (nonatomic,assign) NSInteger commentFlag;//    int    是否已评价，0-否；1-是
@property (nonatomic,assign) NSInteger replayFlag;//    int    是否已回复，0-否；1-是
@end

@interface LKOrderSingleShopModel : LKBaseModel
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *city_icon;
@property (nonatomic,copy) NSString *city_name;

@property (nonatomic,strong) LKBaseFrame *cellFrame;
@property (nonatomic,strong) LKBaseFrame *iconFrame;
@property (nonatomic,strong) LKBaseFrame *titleFrame;


@end



