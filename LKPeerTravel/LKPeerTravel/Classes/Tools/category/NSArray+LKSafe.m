//
//  NSArray+LKSafe.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "NSArray+LKSafe.h"

@implementation NSArray (LKSafe)

+ (BOOL)isEmptyArray:(NSArray *)arr{
    if (arr && [arr isKindOfClass:[NSArray class]] && arr.count>0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isNotEmptyArray:(NSArray *)arr{
    if (arr && [arr isKindOfClass:[NSArray class]] && arr.count>0) {
        return YES;
    }
    return NO;
}

+ (NSArray *)getArray:(NSArray *)arr{
    if (arr && [arr isKindOfClass:[NSArray class]] && arr.count>0) {
        return arr;
    }
    return @[];
}

- (id)objectAt:(NSUInteger)index
{
    if (index < self.count)
    {
        return self[index];
    }
    else
    {
        return nil;
    }
}

@end
