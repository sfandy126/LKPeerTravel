//
//  NSBundle+LKLanguage.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/14.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  国际化语言切换
 *
 *
 **/

#import <Foundation/Foundation.h>


static NSString *kLanguageKey = @"kLanguageKey";

static NSString *kChinese = @"zh-Hans";
static NSString *kEnglish = @"en";

@interface NSBundle (LKLanguage)

+ (void)setLanguage:(NSString *)language;

@end
