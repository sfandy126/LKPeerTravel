//
//  LKConfig.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 * 框架相关的宏定义
 *
 *
 *
 **/

#ifndef LKConfig_h
#define LKConfig_h

#ifdef DEBUG
#define NSLog(FORMAT, ...)    fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...)    nil
#endif

#define kSystemVersion      [[[UIDevice currentDevice] systemVersion] floatValue]
#define kScreenHeight       [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth        [[UIScreen mainScreen] bounds].size.width
#define kWidthRadio         (kScreenWidth / 375)

#define ISIPHONE_X          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define kStatusBarHeight    ([UIApplication sharedApplication].isStatusBarHidden ? (ISIPHONE_X ? 44 : 20):[UIApplication sharedApplication].statusBarFrame.size.height)

#define kIOS7_OR_LATER      ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kIOS10_OR_LATER      ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)

// 导航栏高度
#define kNavigationHeight     (kIOS7_OR_LATER ? (kStatusBarHeight + 44.0f) : 44.0f)

#define kTabBarHeight               (ISIPHONE_X ? 83.0f : 49.0f)

#define kAppVersion               ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define kAppBuild                ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define kAppDisplayName         ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

///字体
#define kFont(sizefont) [UIFont systemFontOfSize:sizefont]
#define kBFont(sizefont) [UIFont boldSystemFontOfSize:sizefont]

///国际语言本地化
#define LKLocalizedString(key) NSLocalizedStringFromTable(key, @"InfoPlist", nil)

// 默认头像
#define kDefaultManHead [UIImage imageNamed:@"head_man"]
#define kDefaultFemaleHead [UIImage imageNamed:@"head_female"]
#endif /* LKConfig_h */
