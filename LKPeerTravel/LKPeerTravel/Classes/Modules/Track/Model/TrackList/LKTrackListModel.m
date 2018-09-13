//
//  LKTrackListModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackListModel.h"

@interface LKTrackListModel ()
@property (nonatomic,strong) NSMutableArray *tempDatalist;
@end

@implementation LKTrackListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempDatalist = [NSMutableArray array];
        self.page = 1;
    }
    return self;
}

- (NSArray<LKTrackCityModel *> *)datalist{
    return [NSArray getArray:[self.tempDatalist copy]];
}

- (void)loadTrackListDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/customer/footprint/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadTrackListData:response.data];
        }
        finishedBlock(response,response.success);

    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadTrackListData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (dataList.count>0) {
        if (self.page==1) {
            [self.tempDatalist removeAllObjects];
        }
        for (NSDictionary *dic in dataList) {
            LKTrackCityModel *item = [LKTrackCityModel modelWithDict:dic];
            if (item) {
                [item calculateLayoutViewFrame];
                [self.tempDatalist addObject:item];
            }
        }
        self.page++;
    }
    self.isLastPage = dataList.count==0;
}

@end


