//
//  LKPageInfo.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPageInfo.h"

@implementation LKPageInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _limit = 0;
        _returnCount = 0;
        _orderBy = @"";
        _count = 0;
        _pageSize = 10;
        _offset = 1;
        _pageNum = 1;
        /*
        "limit": 0,
        "returnCount": true,
        "orderBy": "",
        "count": 0,
        "pageSize": 10,
        "offset": 1,
        "pageNum": 1
         */
    }
    return self;
}

@end
