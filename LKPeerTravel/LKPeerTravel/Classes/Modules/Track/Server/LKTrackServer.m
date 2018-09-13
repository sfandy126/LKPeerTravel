//
//  LKTrackServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackServer.h"
@interface LKTrackServer ()
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *tempHotCitys;
@property (nonatomic,strong) NSMutableArray *tempNewestCitys;

@end

@implementation LKTrackServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[LKTrackModel alloc] init];
        _selectedType = LKTrackSelectedType_Newest;
        self.tempHotCitys = [NSMutableArray array];
        self.tempNewestCitys = [NSMutableArray array];
        self.page = 1;
        self.refreshType = LKRefreshType_Refresh;
    }
    return self;
}

- (NSArray *)hotCitys{
    return [NSArray getArray:[self.tempHotCitys copy]];
}

- (NSArray *)newestCitys{
    return [NSArray getArray:[self.tempNewestCitys copy]];
}

- (void)setRefreshType:(LKRefreshType)refreshType{
    _refreshType = refreshType;
    if (refreshType == LKRefreshType_Refresh) {
        self.page =1;
    }
}

///获取banner
- (void)loadTrackBannerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = 1;
    [self.model loadTrackBannerDataWithParams:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"footPrintType":@"0"} finishedBlock:finishedBlock failedBlock:failedBlock];
}

- (void)loadCityClassDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = 1;
    [self.model loadCityClassDataWithParams:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        finishedBlock (item,isFinished);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}


- (void)loadTrackListDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    NSString *orderBy = self.selectedType == LKTrackSelectedType_Newest?@"1":@"2";
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.page;
    NSDictionary *params = @{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"footPrintType":orderBy};
    @weakify(self);
    [self.model loadTrackListDataWithParams:params finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        if (isFinished) {
            if (self.page ==1) {
                if ([orderBy isEqualToString:@"1"]) {
                    self.tempNewestCitys =[NSMutableArray array];
                }else{
                    self.tempHotCitys =[NSMutableArray array];
                }
            }
            if ([orderBy isEqualToString:@"1"]) {
                [self.tempNewestCitys addObjectsFromArray:self.model.newestCitys];
            }else{
                [self.tempHotCitys addObjectsFromArray:self.model.hotCitys];
            }
            self.page++;
        }
        finishedBlock (item,isFinished);
    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

@end
