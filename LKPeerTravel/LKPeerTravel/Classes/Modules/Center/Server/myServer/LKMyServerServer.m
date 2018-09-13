//
//  LKMyServerServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerServer.h"

@interface LKMyServerServer ()

@end

@implementation LKMyServerServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKMyServerModel alloc] init];
    }
    return self;
}

- (NSArray *)cellLists{
    return [NSArray getArray:self.model.cellDatas];
}


- (LKMyServerType)getCellType:(NSInteger )section{
    LKMyServerType cellType = LKMyServerType_Info;
    switch (section) {
        case 0:
            cellType = LKMyServerType_Info;
            break;
        case 1:
            cellType = LKMyServerType_scene;
            break;
        case 2:
            cellType = LKMyServerType_cate;
            break;
        case 3:
            cellType = LKMyServerType_shop;
            break;
        case 4:
            cellType = LKMyServerType_date;
            break;
    }
    return cellType;
}


///获取我的服务接口
- (void)obtainMyServerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self.model obtainMyServerData:@{@"no":[LKUserInfoUtils getUserID]} finishedBlock:finishedBlock failedBlock:failedBlock];
}

///保存我的服务接口
- (void)saveMyServerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    NSDictionary *params = @{@"no":[LKUserInfoUtils getUserID],
                             @"serviceNo":self.model.serviceNo,
                             @"dateSets":@[@{@"dateOff":@"",@"dateOff":@"",@"dateOff":@""}],
                             @"point":self.model.point,
                             @"pmax":self.model.pmax,
                             @"attractions":@[@{@"codDestinationPointNo":@"",@"codDestinationPointName":@"",@"codDestinationPointLogo":@""}],
                             @"shopps":@[@{@"codDestinationPointNo":@"",@"codDestinationPointName":@"",@"codDestinationPointLogo":@""}],
                             @"foods":@[@{@"codDestinationPointNo":@"",@"codDestinationPointName":@"",@"codDestinationPointLogo":@""}],
                             @"discounts":@[@{@"discountNo":@"",@"discountPost":@"",@"maxNum":@"",@"minNum":@""}],
                             @"flagCar":@"0",
                             @"flagPlane":@"0",
                             };
    [self.model saveMyServerData:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

- (void)saveMyServerParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock {
     [self.model saveMyServerData:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

@end
