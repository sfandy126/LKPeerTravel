//
//  LKUserDefault.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/25.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  针对NSUserDefault数据安全封装一层
 *
 *  所有NSuserDefault都通过该类调用。
 **/

#import <Foundation/Foundation.h>

@interface LKUserDefault : NSObject

+ (void)setValue:(id)value forKey:(NSString *)key;

+ (id) valueForKey:(NSString *)key;

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (id) objectForKey:(NSString *)key;

+ (NSString *)stringForKey:(NSString *)defaultName;

+ (NSArray *)arrayForKey:(NSString *)defaultName;

+ (NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName;

+ (NSData *)dataForKey:(NSString *)defaultName;

+ (NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)defaultName;


@end
