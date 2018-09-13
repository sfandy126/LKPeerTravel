//
//  LKAppDelegate.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAppDelegate.h"
#import "LKTabBarController.h"

#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>

@interface LKAppDelegate ()

@end

@implementation LKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // bugly appid 1f99327288  appkey 16dbf94d-56b9-42bc-82ed-da09720dc7bc
    [Bugly startWithAppId:@"1f99327288"];
    
    [UMConfigure initWithAppkey:@"5b611b16b27b0a31c7000106" channel:@"appStore"];
    
    //设置当前保存的语言
    if ([LKUserDefault objectForKey:kLanguageKey] && ![[LKUserDefault objectForKey:kLanguageKey] isEqualToString:@""]) {
        [NSBundle setLanguage:[LKUserDefault objectForKey:kLanguageKey]];
    }
    NSLog(@"%@",[LKUserDefault objectForKey:kLanguageKey]);
    
    [[LKConfigServer manager] loadConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[LKConfigServer manager] setRootController];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
