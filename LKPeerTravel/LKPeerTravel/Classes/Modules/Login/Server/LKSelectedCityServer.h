//
//  LKSelectedCityServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKSelectCityModel.h"

@interface LKSelectedCityServer : LKBaseServer

@property (nonatomic,strong) LKSelectCityModel *model;

- (void)loadCityListWithName:(NSString *)name successedBlock:(LKFinishedBlock)finished failedBlock:(LKFailedBlock)failed;

- (void)saveSelectedCityWithParams:(NSDictionary *)params finishedBlock:(LKFinishedBlock)finishedBlock failedBlock:(LKFailedBlock)failedBlock;

@end
