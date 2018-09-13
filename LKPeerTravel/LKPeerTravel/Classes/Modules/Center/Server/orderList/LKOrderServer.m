//
//  LKOrderServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderServer.h"

@interface LKOrderServer ()
@property (nonatomic,strong) LKOrderModel *model;
@end

@implementation LKOrderServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKOrderModel alloc] init];
        
        self.typeModelMap = @{@"0":self.model.waitPayModel,@"1":self.model.payedModel,@"-1":self.model.cancelModel,@"2":self.model.finishedModel,@"3":self.model.waitConfirmModel,@"4":self.model.confirmedModel};
    }
    return self;
}

- (NSArray<LKOrderListModel *> *)allOrders{
    return [NSArray getArray:[self.model.allModel.listData copy]];
}

- (NSArray<LKOrderListModel *> *)waitPayOrders{
    return [NSArray getArray:[self.model.waitPayModel.listData copy]];
}

- (NSArray<LKOrderListModel *> *)payedOrders{
    return [NSArray getArray:[self.model.payedModel.listData copy]];
}

- (NSArray<LKOrderListModel *> *)finishedOrders{
    return [NSArray getArray:[self.model.finishedModel.listData copy]];
}

- (NSArray<LKOrderListModel *> *)canceledOrders{
    return [NSArray getArray:[self.model.cancelModel.listData copy]];
}

///根据订单类型获取对应列表的当前page
- (NSInteger )getPageWithOrderType:(LKOrderType )type{
    NSInteger page = 1;
    switch (type) {
        case LKOrderType_all:
            page = self.model.allModel.page;
            break;
        case LKOrderType_waitPay:
            page = self.model.waitPayModel.page;
            break;
        case LKOrderType_payed:
            page = self.model.payedModel.page;
            break;
        case LKOrderType_finished:
            page = self.model.finishedModel.page;
            break;
        case LKOrderType_cancel:
            page = self.model.cancelModel.page;
            break;
    }
    return page;
}

- (NSInteger)getPage {
    NSInteger page = 1;
    NSNumber *num = [self.orderIndexMap objectForKey:[NSString stringWithFormat:@"%zd",self.clickIndex]];
    LKOrderTypeModel *model = [self.typeModelMap objectForKey:[NSString stringWithFormat:@"%@",num]];
    if ([model isKindOfClass:[LKOrderTypeModel class]]) {
        page = model.page;
    }
    return page;
}

- (void)resetParams {
    NSNumber *num = [self.orderIndexMap objectForKey:[NSString stringWithFormat:@"%zd",self.clickIndex]];
    LKOrderTypeModel *model = [self.typeModelMap objectForKey:[NSString stringWithFormat:@"%@",num]];
    if ([model isKindOfClass:[LKOrderTypeModel class]]) {
        model.page = 1;
    }
}

///根据订单类型，重置对应的参数
- (void)resetParamsWithOrderType:(LKOrderType )type{
    
    switch (type) {
        case LKOrderType_all:
            self.model.allModel.page = 1;
            break;
        case LKOrderType_waitPay:
            self.model.waitPayModel.page=1;
            break;
        case LKOrderType_payed:
            self.model.payedModel.page=1;
            break;
        case LKOrderType_finished:
            self.model.finishedModel.page=1;
            break;
        case LKOrderType_cancel:
            self.model.cancelModel.page=1;
            break;
    }
}

///传订单类型，须与解析时类型对应
- (NSString *)getStatusWithOrderType:(LKOrderType )type{
    NSString *status = @"";
    switch (type) {
        case LKOrderType_all:
            status = @"";;
            break;
        case LKOrderType_waitPay:
            status = @"0";;
            break;
        case LKOrderType_payed:
            status = @"1";;
            break;
        case LKOrderType_finished:
            status = @"2";;
            break;
        case LKOrderType_cancel:
            status = @"-1";;
            break;
    }
    return status;
}

///获取订单列表接口
- (void)obtainOrderListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
//    NSString *status = [self getStatusWithOrderType:self.orderType];//请求的订单列表类型

    NSNumber *number = [self.orderIndexMap objectForKey:[NSString stringWithFormat:@"%ld",self.clickIndex]];
    NSInteger type = 1;
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        type = 2;
    }
    LKPageInfo *pageModel = [[LKPageInfo alloc] init];
//    pageModel.pageNum = [self getPageWithOrderType:self.orderType];
    pageModel.pageNum = [self getPage];
    [self.model obtainOrderListData:@{@"status":number,@"page":[NSDictionary getDictonary:[pageModel modelToJSONObject]],@"no":[LKUserInfoUtils getUserNumber],@"type":@(type)} finishedBlock:^(LKResult *item, BOOL isFinished) {
        finishedBlock(item,isFinished);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

///更新订单状态接口
- (void)updateOrderStatusData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model updateOrderStatusData:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

@end
