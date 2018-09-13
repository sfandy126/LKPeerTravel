//
//  LKConfigServer.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKConfigServer.h"

#import "LKLoginServer.h"

@implementation LKConfigServer

+ (LKConfigServer *)manager{
    static LKConfigServer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LKConfigServer alloc] init];
        }
    });
    return instance;
}

- (void)setRootController{
    
    BOOL isNotFirstLogin = [LKUserDefault boolForKey:@"kNotFirstLogin"];
    if (!isNotFirstLogin) {//是否为第一次登录
        [LKUserDefault setBool:YES forKey:@"kNotFirstLogin"];
        [LKMediator openWelcome];
    }else{
        [LKMediator openLauchVC];
        // 判断是否已经登录过
        NSString *token = [LKUserInfoUtils token];
        NSString *phone = [LKUserInfoUtils getUserIphone];
        // 已经登录过,开始自动登录
        if ([NSString isNotEmptyStirng:token] && [NSString isNotEmptyStirng:phone]) {
            [[LKLoginServer manager] loginWithParams:@{@"loginType":@"2",@"loginId":phone,@"token":token} finishedBlock:^(LKResult *item, BOOL isFinished) {
                NSString *customerNumber = [NSString stringValue:item.data[@"customerNumber"]];
                NSString *retoken = [NSString stringValue:item.data[@"token"]];
                
                if (customerNumber.length>0 && retoken.length>0) {
                    [LKUserInfoUtils updateValue:customerNumber withKey:@"customerNumber"];
                    [LKUserInfoUtils updateValue:retoken withKey:@"token"];
                    [LKMediator openTabBar];
                }else{
                    //自动登录失败
                    [LKMediator openLogin];
                }
                
            } failedBlock:^(NSError *error) {
                // 自动登录失败,跳转到登录页
                [LKMediator openLogin];
            }];
        } else {
            [LKMediator openLogin];
        }
        /*
        //是否登录成功
        BOOL isLogined = NO;
        if (isLogined) {
            //是否选择了用户类型
            LKUserType userType = [LKUserInfoUtils getUserType];
            if (userType == LKUserType_Default) {
                [LKMediator openSelectUserType];
            }else{
                [LKMediator openTabBar];
            }
        }else{
            [LKMediator openLogin];
        }
         */
    }
}

- (void)loadConfig{
    [self appNaigationConfig];
}

- (void)loadThirdConfig{
    
}

- (void)appNaigationConfig{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont systemFontOfSize:18.0] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:[UIColor colorWithHexString:@"#222222"] forKey:NSForegroundColorAttributeName];
    [titleBarAttributes setValue:nil forKey:NSShadowAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"] andHeight:CGSizeMake(kScreenWidth, kNavigationHeight)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
}

@end
