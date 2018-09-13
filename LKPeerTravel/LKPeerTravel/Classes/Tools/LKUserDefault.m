//
//  LKUserDefault.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/25.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 NSData
 NSString
 NSNumber
 NSDate
 NSArray
 NSDictionary
  **/

#import "LKUserDefault.h"

#define defaults [NSUserDefaults standardUserDefaults]

@implementation LKUserDefault

+ (void)setValue:(id)value forKey:(NSString *)key{
    if ([NSString isEmptyStirng:key] || !value) {
        return;
    }
    [defaults setValue:value forKey:key];
    [defaults  synchronize];
}

+ (id) valueForKey:(NSString *)key{
    if (![NSString isEmptyStirng:key]) {
        return @"";
    }
    return [defaults valueForKey:key];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    if ([NSString isEmptyStirng:defaultName] || !value) {
        return;
    }
    [defaults setObject:value forKey:defaultName];
    [defaults  synchronize];
}

+ (id) objectForKey:(NSString *)key{
    if ([NSString isEmptyStirng:key]) {
        return @"";
    }
    return [defaults objectForKey:key];
}

+ (NSString *)stringForKey:(NSString *)defaultName{
    if ([NSString isNotEmptyStirng:defaultName]) {
        return [defaults stringForKey:defaultName];
    }
    return @"";
}

+ (NSArray *)arrayForKey:(NSString *)defaultName{
    if ([NSString isNotEmptyStirng:defaultName]) {
        return [defaults arrayForKey:defaultName];
    }
    return @[];
}

+ (NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName{
    if ([NSString isNotEmptyStirng:defaultName]) {
        return [defaults dictionaryForKey:defaultName];
    }
    return @{};
}

+ (NSData *)dataForKey:(NSString *)defaultName{
    if ([NSString isNotEmptyStirng:defaultName]) {
        return [defaults dataForKey:defaultName];
    }
    return [NSData data];
}

+ (NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName{
    if ([NSString isNotEmptyStirng:defaultName]) {
        return [defaults stringArrayForKey:defaultName];
    }
    return @[];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key{
    if ([NSString isEmptyStirng:key]) {
        return;
    }
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (void)removeObjectForKey:(NSString *)key{
    if ([NSString isEmptyStirng:key]) {
        return;
    }
    [defaults removeObjectForKey:key];
    [defaults  synchronize];
}

+ (BOOL)boolForKey:(NSString *)defaultName{
    if ([NSString isNotEmptyStirng:defaultName]) {
        return [defaults boolForKey:defaultName];
    }
    return NO;
}


@end
