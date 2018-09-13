//
//  NSString+LKSafe.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LKSafe)

+ (BOOL)isEmptyStirng:(NSString *)value;

+ (BOOL)isNotEmptyStirng:(NSString *)value;

+ (NSString *)stringValue:(NSString *)value;

+ (NSString*)fileMD5:(NSData *)fileData;

@end
