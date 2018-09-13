//
//  NSArray+LKSafe.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LKSafe)

+ (BOOL)isEmptyArray:(NSArray *)arr;

+ (BOOL)isNotEmptyArray:(NSArray *)arr;

+ (NSArray *)getArray:(NSArray *)arr;

- (id)objectAt:(NSUInteger)index;

@end
