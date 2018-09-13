//
//  LKHomeServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeServer.h"

@interface LKHomeServer ()

@property (nonatomic,strong) NSMutableArray *tempHotGuides;
@end

@implementation LKHomeServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[LKHomeModel alloc] init];
        _tempHotGuides = [NSMutableArray array];
    }
    return self;
}

- (LKHomeCellType )getHomeCellType:(NSInteger )section{
    if (section==0) {
        return LKHomeCellType_helper;
    }
    if (section==1) {
        return LKHomeCellType_hotCity;
    }
    if (section==2) {
        return LKHomeCellType_hotGuide;
    }
    return LKHomeCellType_default;
}

- (void)setIsLoadMore:(BOOL)isLoadMore{
    _isLoadMore  = isLoadMore;
    if (!isLoadMore) {
        self.page=1;
    }
}

- (NSArray *)hotGuides{
    return [NSArray getArray:[self.tempHotGuides copy]];
}

///首页banner接口
- (void)obtainHomeBanerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model obtainHomeBanerData:@{} finishedBlock:finishedBlock failedBlock:failedBlock];
}

///热门城市接口
- (void)obtainHomeHotCityDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model obtainHomeHotCityData:@{} finishedBlock:finishedBlock failedBlock:failedBlock];
}


///私人导游接口
- (void)obtainHomePrivateGuiderDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model obtainHomePrivateGuiderData:@{} finishedBlock:finishedBlock failedBlock:failedBlock];
}

///热门导游接口
- (void)obtainHomeHotGuiderDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    NSDictionary *params = @{@"page":[NSString stringWithFormat:@"%zd",self.page],@"keyword":[NSString stringValue:self.selected_city_id]};
    @weakify(self);
    [self.model obtainHomeHotGuiderData:params finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        if (isFinished) {
            if (self.page==1) {
                [self.tempHotGuides removeAllObjects];
            }
            [self.tempHotGuides addObjectsFromArray:self.model.hotGuides];
            self.page++;
        }
        finishedBlock(item,isFinished);
    } failedBlock:^(NSError *error) {
        
    }];
}

@end
