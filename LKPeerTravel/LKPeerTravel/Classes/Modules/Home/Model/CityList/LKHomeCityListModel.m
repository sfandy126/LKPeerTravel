//
//  LKHomeCityListModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeCityListModel.h"

@interface LKHomeCityListModel ()
@property (nonatomic,strong) NSMutableArray *tempDataList;
@end

@implementation LKHomeCityListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempDataList = [NSMutableArray array];
        self.page = 1;
    }
    return self;
}

- (NSArray<LKHomeCityItemModel *> *)datalists{
    return [NSArray getArray:[self.tempDataList copy]];
}

- (void)obtainHomeCityListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/city/list" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadCityListData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadCityListData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (dataList.count>0) {
        if (self.page==1) {
            [self.tempDataList removeAllObjects];
        }
        for (NSDictionary *dic in dataList) {
            LKHomeCityItemModel *item = [LKHomeCityItemModel modelWithDict:dic];
            if (item) {
                [self.tempDataList addObject:item];
            }
        }
        self.page++;
    }
    
    self.isLastPage = self.tempDataList.count==0;
}



@end


@implementation LKHomeCityItemModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKHomeCityItemModel *item = [[LKHomeCityItemModel alloc] init];
        item.cityNo = [NSString stringValue:[dict valueForKey:@"cityNo"]];
        item.cityNm = [NSString stringValue:[dict valueForKey:@"cityNm"]];
        item.cityName = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.nationalName = [NSString stringValue:[dict valueForKey:@"nationalName"]];
        item.cityDesc = [NSString stringValue:[dict valueForKey:@"cityDesc"]];
        item.datCreate = [NSString stringValue:[dict valueForKey:@"datCreate"]];
        item.cityImageList = [NSArray getArray:[dict valueForKey:@"cityImageList"]];
        item.imageUrl = [NSString stringValue:[dict valueForKey:@"imageUrl"]];
        if (item.imageUrl.length==0) {
            NSDictionary *dic = [NSDictionary getDictonary:[item.cityImageList firstObject]];
            item.imageUrl = [NSString stringValue:[dic valueForKey:@"imageUrl"]];
        }
        item.txtImage = [NSString stringValue:[dict valueForKey:@"txtImage"]];
        item.wishNum = [NSString stringValue:[dict valueForKey:@"wishNum"]];
        item.guideNum = [NSString stringValue:[dict valueForKey:@"guideNum"]];
        return item;
    }
    return nil;
}

@end
