//
//  LKTrackCityListModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackCityListModel.h"

@interface LKTrackCityListModel ()
@property (nonatomic,strong) NSMutableArray *templists;
@end

@implementation LKTrackCityListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page =1;
        self.templists = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)list{
    return [NSArray getArray:[self.templists copy]];
}

- (void)loadTrackCityDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/footprint/city/list" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadTrackCityData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadTrackCityData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (dataList.count>0) {
        if (self.page==1) {
            [self.templists removeAllObjects];
        }
        for (NSDictionary *dic in dataList) {
            LKTrackCityListItemModel *item = [LKTrackCityListItemModel modelWithDict:dic];
            if (item) {
                [self.templists addObject:item];
            }
        }
        self.page++;
    }
    self.isLastPage = dataList.count==0;
}


@end


@implementation LKTrackCityListItemModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKTrackCityListItemModel *item = [LKTrackCityListItemModel new];
        item.cityNo = [NSString stringValue:[dict valueForKey:@"cityNo"]];
        item.cityNm = [NSString stringValue:[dict valueForKey:@"cityNm"]];
        item.cityName = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.cityImagesUrl = [NSString stringValue:[dict valueForKey:@"cityImagesUrl"]];
        item.cityDesc = [NSString stringValue:[dict valueForKey:@"cityDesc"]];
        item.userFaces = [NSArray getArray:[dict valueForKey:@"headIconList"]];
        item.footNum = [NSString stringValue:[dict valueForKey:@"footprintCount"]];
        item.looks = [NSString stringValue:[dict valueForKey:@"pageViewCount"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"commentCount"]];

        return item;
    }
    
    return nil;
}

@end


