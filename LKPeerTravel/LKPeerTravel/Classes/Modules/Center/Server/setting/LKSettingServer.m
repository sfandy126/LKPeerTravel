//
//  LKSettingServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSettingServer.h"

@implementation LKSettingServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _model = [[LKSettingModel alloc] init];
    }
    return self;
}

@end
