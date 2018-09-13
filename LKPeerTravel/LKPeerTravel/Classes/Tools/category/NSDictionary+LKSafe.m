//
//  NSDictionary+LKSafe.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "NSDictionary+LKSafe.h"

@implementation NSDictionary (LKSafe)

+ (BOOL)isEmptyDict:(NSDictionary *)dict{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.allKeys.count>0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isNotEmptyDict:(NSDictionary *)dict{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.allKeys.count>0) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)getDictonary:(NSDictionary *)dict{
    if (dict && [dict isKindOfClass:[NSDictionary class]] && dict.allKeys.count>0) {
        return dict;
    }
    return @{};
}

@end
