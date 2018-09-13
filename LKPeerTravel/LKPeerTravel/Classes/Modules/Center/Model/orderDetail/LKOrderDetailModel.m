//
//  LKOrderDetailModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailModel.h"

@implementation LKOrderDetailModel

///获取订单详情接口
- (void)obtainOrderDetailData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/OmsOrderMast/get" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadOrderDetailData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadOrderDetailData:(NSDictionary *)dict{
    NSDictionary *data = [NSDictionary getDictonary:[dict valueForKey:@"data"]];
    self.orderNo = [NSString stringValue:[data valueForKey:@"orderNo"]];
    self.dateStart = [NSString stringValue:[data valueForKey:@"dateStart"]];
    self.dateEnd = [NSString stringValue:[data valueForKey:@"dateEnd"]];
    self.point = [NSString stringValue:[data valueForKey:@"point"]];
    self.dNum = [NSString stringValue:[data valueForKey:@"dNum"]];
    self.pNum = [NSString stringValue:[data valueForKey:@"pNum"]];
    self.discount = [NSString stringValue:[data valueForKey:@"discount"]];
    self.flagCar = [[NSString stringValue:[data valueForKey:@"flagCar"]] boolValue];
    self.flagPlane = [[NSString stringValue:[data valueForKey:@"flagPlane"]] boolValue];
    self.amtOrderCharge = [NSString stringValue:[data valueForKey:@"amtOrderCharge"]];
    self.codOrderStatus = [NSString stringValue:[data valueForKey:@"codOrderStatus"]];
    self.datEffective = [NSString stringValue:[data valueForKey:@"datEffective"]];
    self.datCreate = [NSString stringValue:[data valueForKey:@"datCreate"]];
    self.userName = [NSString stringValue:[data valueForKey:@"userName"]];
    self.guideName = [NSString stringValue:[data valueForKey:@"guideName"]];
    self.commentFlag = [[NSString stringValue:[data valueForKey:@"commentFlag"]] integerValue];
    self.replayFlag = [[NSString stringValue:[data valueForKey:@"replayFlag"]] integerValue];

    self.phone = [NSString stringValue:[data valueForKey:@"phone"]];
    self.cityName = [NSString stringValue:[data valueForKey:@"cityName"]];
    self.amtOrderProcess = [NSString stringValue:[data valueForKey:@"amtOrderProcess"]];
    
    
    ///语言
    NSArray *laus = [NSArray getArray:[data valueForKey:@"jobs"]];
    NSMutableString *lauStr = [NSMutableString string];
    NSInteger index=0;
    for (NSDictionary *dic in laus) {
        NSString *name = [NSString stringValue:[dic valueForKey:@"labelName"]];
        if (name.length>0) {
            if (index==0) {
                [lauStr appendString:name];
            }else{
                [lauStr appendString:@"  "];
                [lauStr appendString:name];
            }
        }
        index++;
    }
    self.jobs = [NSString stringValue:[lauStr copy]];
    
    
    ///用户选定的服务
    NSMutableArray *temp = [NSMutableArray array];
    NSArray *attractions = [NSArray getArray:[data valueForKey:@"attractions"]];
    for (NSDictionary *dic in attractions) {
        LKOrderSingleShopModel *item = [LKOrderSingleShopModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    NSArray *foods = [NSArray getArray:[data valueForKey:@"foods"]];
    for (NSDictionary *dic in foods) {
        LKOrderSingleShopModel *item = [LKOrderSingleShopModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    NSArray *shopps = [NSArray getArray:[data valueForKey:@"shopps"]];
    for (NSDictionary *dic in shopps) {
        LKOrderSingleShopModel *item = [LKOrderSingleShopModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    self.selectedServe = [NSArray getArray:[temp copy]];
//    NSInteger row =(self.selectedServe.count/4) +(self.selectedServe.count%4==0?0:1);
//    CGFloat shopHeight = (92*kWidthRadio)*row+10*row;
    
    NSInteger row =(temp.count/4) +(temp.count%4==0?0:1);
    CGFloat shopHeight = (92*kWidthRadio)*row+10*row;
    self.serveHeight = shopHeight;

}

@end

