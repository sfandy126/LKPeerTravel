//
//  NSString+LKSafe.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "NSString+LKSafe.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (LKSafe)

+ (BOOL)isEmptyStirng:(NSString *)value{
    if (value && [value isKindOfClass:[NSString class]] && value.length>0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isNotEmptyStirng:(NSString *)value{
    if (value && [value isKindOfClass:[NSString class]] && value.length>0) {
        return YES;
    }
    return NO;
}

+ (NSString *)stringValue:(NSString *)value{
    if (value && [value isKindOfClass:[NSString class]] && value.length>0){
        return value;
    }
    if (value && [value isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber*)value;
        value = [num stringValue];
        return value;
    }
    return @"";
}


+ (NSString*)fileMD5:(NSData *)fileData {
    if (!fileData) {
        return @"ERROR GETTING FILE MD5";
    }// file didnt exist
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, [fileData bytes], (int)[fileData length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString *md5Str = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[0], digest[1],
                        digest[2], digest[3],
                        digest[4], digest[5],
                        digest[6], digest[7],
                        digest[8], digest[9],
                        digest[10], digest[11],
                        digest[12], digest[13],
                        digest[14], digest[15]];
    return [md5Str lowercaseString];
}

@end
