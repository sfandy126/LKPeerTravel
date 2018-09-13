//
//  NSDictionary+LKSafe.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LKSafe)

+ (BOOL)isEmptyDict:(NSDictionary *)dict;

+ (BOOL)isNotEmptyDict:(NSDictionary *)dict;

+ (NSDictionary *)getDictonary:(NSDictionary *)dict;

@end
