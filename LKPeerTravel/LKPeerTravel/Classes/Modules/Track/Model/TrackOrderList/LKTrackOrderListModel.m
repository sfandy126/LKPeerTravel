//
//  LKTrackOrderListModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/8/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackOrderListModel.h"

@interface LKTrackOrderListModel ()
@property (nonatomic,strong) NSMutableArray *tempList;
@end

@implementation LKTrackOrderListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempList = [NSMutableArray array];
        self.page = 1;
    }
    return self;
}

- (NSArray<LKTrackOrderListItemModel *> *)list{
    return [NSArray getArray:[self.tempList copy]];
}

- (void)loadTrackOrderDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/OmsOrderMast/list" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadTrackOrderData:response.data];
        }
        finishedBlock(response,response.success);
        
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadTrackOrderData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (datalist.count>0) {
        if (self.page ==1) {
            [self.tempList removeAllObjects];
        }
        for (NSDictionary *dic in datalist) {
            LKTrackOrderListItemModel *item = [LKTrackOrderListItemModel modelWithDict:dic];
            if (item) {
                [self.tempList addObject:item];
            }
        }
        self.page++;
    }
    self.isLastPage = datalist.count==0;
}

@end

@implementation  LKTrackOrderListItemModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKTrackOrderListItemModel *item = [LKTrackOrderListItemModel new];
        item.orderNo = [NSString stringValue:[dict valueForKey:@"codOrderNo"]];
        item.guider = [NSString stringValue:[dict valueForKey:@"guideName"]];
        NSString *startTime = [NSString stringValue:[dict valueForKey:@"dateStart"]];
        NSString *endTime = [NSString stringValue:[dict valueForKey:@"dateEnd"]];

        item.travelTime = [NSString stringWithFormat:@"%@ 至 %@",startTime,endTime];

        NSString *string = @"";
        NSArray *attractions = [NSArray getArray:[dict valueForKey:@"attractions"]];
        NSInteger index = 0;
        for (NSDictionary *dic in attractions) {
            NSString *pointName = [NSString stringValue:[dic valueForKey:@"codDestinationPointName"]];
            if (index==0) {
                string = pointName;
            }else{
                string = [NSString stringWithFormat:@"%@ , %@",string,pointName];
            }
            index++;
        }
        item.travelCity = [string copy];
        return item;
    }
    return nil;
}

@end

