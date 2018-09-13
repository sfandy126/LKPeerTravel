//
//  LKSendTrackServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackServer.h"

@implementation LKSendTrackServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKSendTrackModel alloc] init];
    }
    return self;
}

///编辑、发布足迹
- (void)sendFootprintDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock{
    
    self.model.infoModel.customerNumber = [LKUserInfoUtils getUserNumber];
    
    //发布的图片
    NSMutableArray *tempDatalist = [NSMutableArray array];
    for (LKSendTrackAddModel *item in self.model.addItems) {
        if (!item.is_add) {
            LKSendTrackPicModel *picModel = [LKSendTrackPicModel new];
            picModel.imageUrl = item.city_icon;
            picModel.flagCover = @"y";
            picModel.imageDesc = item.content;
            [tempDatalist addObject:picModel];
        }
    }
    self.model.infoModel.dataList = [NSArray getArray:[tempDatalist copy]];
    
    NSDictionary *params = [NSDictionary getDictonary:[self.model.infoModel modelToJSONObject]];
    
    [self.model sendFootprintData:params finishedBlock:finishedBlock failedBlock:failedBlock];
}

@end
