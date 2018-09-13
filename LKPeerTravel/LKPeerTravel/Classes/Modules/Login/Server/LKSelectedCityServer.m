//
//  LKSelectedCityServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSelectedCityServer.h"

@implementation LKSelectedCityServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKSelectCityModel alloc] init];
    }
    return self;
}

- (void)loadCityListWithName:(NSString *)name successedBlock:(LKFinishedBlock)finished failedBlock:(LKFailedBlock)failed {
    
     @weakify(self);
    [self.model requestDataWithParams:@{@"cityName":[NSString stringValue:name]} forPath:@"tx/cif/city/criteria/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        NSArray *dataList = [NSArray getArray:response.data[@"dataList"]];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in dataList) {
            LKCityTagModel *model = [LKCityTagModel modelWithDictionary:dict];
            [temp addObject:model];
        }
        if ([NSString isEmptyStirng:name]) {
            self.model.tags = [NSArray arrayWithArray:temp];
        } else {
            self.model.searchResult = [NSArray arrayWithArray:temp];
        }
        finished(item,response);
    } failed:^(LKBaseModel *item, NSError *error) {
        failed(item,error);
    }];
    
}

- (void)saveSelectedCityWithParams:(NSDictionary *)params finishedBlock:(LKFinishedBlock)finishedBlock failedBlock:(LKFailedBlock)failedBlock{
    [self.model requestDataWithParams:params forPath:@"tx/cif/customer/maintenance" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(item,response);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(item,error);
    }];
}

@end
