//
//  LKOrderModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderModel.h"

@interface  LKOrderModel ()

@property (nonatomic,strong) NSMutableArray *tempAllList;
@property (nonatomic,strong) NSMutableArray *tempwaitPayList;
@property (nonatomic,strong) NSMutableArray *tempPayedList;
@property (nonatomic,strong) NSMutableArray *tempFinishedList;
@property (nonatomic,strong) NSMutableArray *tempCancelList;
@property (nonatomic,strong) NSMutableArray *tempWaitConfirmList;
@property (nonatomic,strong) NSMutableArray *tempConfirmedList;

@end

@implementation LKOrderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tempAllList = [NSMutableArray array];
        _tempwaitPayList = [NSMutableArray array];
        _tempPayedList = [NSMutableArray array];
        _tempFinishedList = [NSMutableArray array];
        _tempCancelList = [NSMutableArray array];
        _tempConfirmedList = [NSMutableArray array];
        _tempWaitConfirmList = [NSMutableArray array];
        
        _allModel = [LKOrderTypeModel new];
        _waitPayModel = [LKOrderTypeModel new];
        _payedModel = [LKOrderTypeModel new];
        _finishedModel = [LKOrderTypeModel new];
        _cancelModel = [LKOrderTypeModel new];
        _confirmedModel = [LKOrderTypeModel new];
        _waitConfirmModel = [LKOrderTypeModel new];
    }
    return self;
}


///更新订单状态接口
- (void)updateOrderStatusData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/OmsOrderMast/updateStatus" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

///获取订单列表接口
- (void)obtainOrderListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/OmsOrderMast/list" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadOrderListData:response.data params:params];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadOrderListData:(NSDictionary *)dict params:(NSDictionary *)params{
    dict = [NSDictionary getDictonary:dict];
    
    NSMutableArray *temp = [NSMutableArray array];
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    for (NSDictionary *dic in dataList) {
        LKOrderListModel *listModel = [LKOrderListModel modelWithDict:dic];
        if (listModel) {
            [temp addObject:listModel];
        }
    }
    
    NSString *status = [NSString stringValue:[params valueForKey:@"status"]];
    if ([status isEqualToString:@"0"]) {//LKOrderType_waitPay
        if (self.waitPayModel.page==1) {
            [self.tempwaitPayList removeAllObjects];
        }
        [self.tempwaitPayList addObjectsFromArray:[temp copy]];
        self.waitPayModel.listData = [NSArray getArray:[self.tempwaitPayList copy]];
        self.waitPayModel.orderType = LKOrderType_waitPay;
        self.waitPayModel.page++;
    }else if ([status isEqualToString:@"1"]){//LKOrderType_payed
        if (self.payedModel.page==1) {
            [self.tempPayedList removeAllObjects];
        }
        [self.tempPayedList addObjectsFromArray:[temp copy]];
        self.payedModel.listData = [NSArray getArray:[self.tempPayedList copy]];
        self.payedModel.orderType = LKOrderType_payed;
        self.payedModel.page++;
    }else if ([status isEqualToString:@"2"]){//LKOrderType_finished
        if (self.finishedModel.page==1) {
            [self.tempFinishedList removeAllObjects];
        }
        [self.tempFinishedList addObjectsFromArray:[temp copy]];
        self.finishedModel.listData = [NSArray getArray:[self.tempFinishedList copy]];
        self.finishedModel.orderType = LKOrderType_finished;
        self.finishedModel.page++;
    }else if ([status isEqualToString:@"-1"]){//LKOrderType_cancel
        if (self.cancelModel.page==1) {
            [self.tempCancelList removeAllObjects];
        }
        [self.tempCancelList addObjectsFromArray:[temp copy]];
        self.cancelModel.listData = [NSArray getArray:[self.tempCancelList copy]];
        self.cancelModel.orderType = LKOrderType_cancel;
        self.cancelModel.page++;
    } else if ([status isEqualToString:@"3"]) {
        if (self.waitConfirmModel.page==1) {
            [self.tempWaitConfirmList removeAllObjects];
        }
        [self.tempCancelList addObjectsFromArray:[temp copy]];
        self.waitConfirmModel.listData = [NSArray getArray:[self.tempCancelList copy]];
        self.waitConfirmModel.orderType = LKOrderType_cancel;
        self.waitConfirmModel.page++;
    } else if ([status isEqualToString:@"4"]) {
        if (self.confirmedModel.page==1) {
            [self.tempConfirmedList removeAllObjects];
        }
        [self.tempConfirmedList addObjectsFromArray:[temp copy]];
        self.confirmedModel.listData = [NSArray getArray:[self.tempCancelList copy]];
        self.confirmedModel.orderType = LKOrderType_cancel;
        self.confirmedModel.page++;
    }
    
    else{
        if (self.allModel.page==1) {
            [self.tempAllList removeAllObjects];
        }
        [self.tempAllList addObjectsFromArray:[temp copy]];
        self.allModel.listData = [NSArray getArray:[self.tempAllList copy]];
        self.allModel.orderType = LKOrderType_all;
        self.allModel.page++;
    }

}

@end

@implementation LKOrderTypeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        
    }
    return self;
}

@end


@implementation LKOrderListModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKOrderListModel *item = [LKOrderListModel new];
        item.order_id = [NSString stringValue:[dict valueForKey:@"codOrderNo"]];
        item.order_display_id = [NSString stringValue:[dict valueForKey:@"orderNo"]];

        item.start_time = [NSString stringValue:[dict valueForKey:@"dateStart"]];
        item.end_time = [NSString stringValue:[dict valueForKey:@"dateEnd"]];
        item.order_state = [NSString stringValue:[dict valueForKey:@"codOrderStatus"]];
        item.is_evaluated = [[NSString stringValue:[dict valueForKey:@"is_evaluated"]] boolValue];

        item.total_price = [NSString stringValue:[dict valueForKey:@"amtOrderCharge"]];
        
        item.commentFlag = [[dict valueForKey:@"commentFlag"] integerValue];
        item.replayFlag = [[dict valueForKey:@"replayFlag"] integerValue];

        NSMutableArray *temp = [NSMutableArray array];
        NSArray *attractions = [NSArray getArray:[dict valueForKey:@"attractions"]];
        for (NSDictionary *dic in attractions) {
            LKOrderSingleShopModel *item = [LKOrderSingleShopModel modelWithDict:dic];
            if (item) {
                [temp addObject:item];
            }
        }
        NSArray *foods = [NSArray getArray:[dict valueForKey:@"foods"]];
        for (NSDictionary *dic in foods) {
            LKOrderSingleShopModel *item = [LKOrderSingleShopModel modelWithDict:dic];
            if (item) {
                [temp addObject:item];
            }
        }
        NSArray *shopps = [NSArray getArray:[dict valueForKey:@"shopps"]];
        for (NSDictionary *dic in shopps) {
            LKOrderSingleShopModel *item = [LKOrderSingleShopModel modelWithDict:dic];
            if (item) {
                [temp addObject:item];
            }
        }
        item.shops = [NSArray getArray:[temp copy]];
        
        NSArray *shops = [NSArray getArray:item.shops];
        NSInteger row =(shops.count/4) +(shops.count%4==0?0:1);
        CGFloat shopHeight = (92*kWidthRadio)*row+10*row;
        item.shopsHeight = shopHeight;
        return item;
    }
    return nil;
}


@end

@implementation LKOrderSingleShopModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKOrderSingleShopModel *item = [LKOrderSingleShopModel new];
        item.city_id = [NSString stringValue:[dict valueForKey:@"codDestinationPointNo"]];
        item.city_name = [NSString stringValue:[dict valueForKey:@"codDestinationPointName"]];
        item.city_icon = [NSString stringValue:[dict valueForKey:@"codDestinationPointLogo"]];
        return item;
    }
    return nil;
}

@end


