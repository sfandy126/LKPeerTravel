//
//  LKEditServerModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditServerModel.h"

@implementation LKEditServerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.no = [LKUserInfoUtils getUserNumber];
    }
    return self;
}

@end
