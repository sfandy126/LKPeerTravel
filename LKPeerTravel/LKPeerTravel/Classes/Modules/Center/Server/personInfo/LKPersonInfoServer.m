//
//  LKPersonInfoServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPersonInfoServer.h"

@implementation LKPersonInfoServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[LKPersonInfoModel alloc] init];
    }
    return self;
}

@end
