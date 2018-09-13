//
//  LKMediator.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMediator.h"
#import "LKTabBarController.h"
#import "LKLoginViewController.h"
#import "LKWelcomeViewController.h"
#import "LKSearchViewController.h"
#import "LKStateViewController.h"
#import "LKSettingViewController.h"
#import "LKUserDetailViewController.h"
#import "LKLauchViewController.h"
#import "LKPersonInfoViewController.h"
#import "LKOderDetailViewController.h"
#import "LKAnswerListViewController.h"
#import "LKTrackDetailViewController.h"
#import "LKImageBrowseViewController.h"
#import "LKShareViewController.h"
#import "LKAnswerDetailViewController.h"

@implementation LKMediator

+ (void)openTabBar{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    LKTabBarController *tabBarCtl = [[LKTabBarController alloc] init];
    window.rootViewController = tabBarCtl;
    [window makeKeyAndVisible];
}

+ (void)openTabBar:(NSInteger )index{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    LKTabBarController *tabBarCtl = [[LKTabBarController alloc] init];
    [tabBarCtl setTabSelectedIndex:index];
    window.rootViewController = tabBarCtl;
    [window makeKeyAndVisible];
}

+ (LKBaseViewController *)selectedCtl{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.rootViewController && [window.rootViewController isKindOfClass:[LKTabBarController class]]) {
        LKTabBarController *tabbar = (LKTabBarController*)window.rootViewController;
        LKNavigationViewController *navi = [tabbar selectedViewController];
        return [navi.childViewControllers lastObject];
    }
    
    if (window.rootViewController && [window.rootViewController isKindOfClass:[LKNavigationViewController class]]) {
        LKNavigationViewController *navi = (LKNavigationViewController*)window.rootViewController;
        return [navi.childViewControllers lastObject];
    }
    if (window.rootViewController && [window.rootViewController isKindOfClass:[LKBaseViewController class]]) {
        LKBaseViewController *ctl = (LKBaseViewController*)window.rootViewController;
        return ctl;
    }
    return nil;
}

+ (void)pushViewController:(LKBaseViewController *)controller animated:(BOOL) animated{
    LKBaseViewController *ctl = [LKMediator selectedCtl];
    if (!controller || !ctl) {
        return;
    }
    if (ctl.navigationController) {
        controller.hidesBottomBarWhenPushed = YES;
        [ctl.navigationController pushViewController:controller animated:animated];
    }else{
        [ctl presentViewController:controller animated:animated completion:nil];
    }
}

+ (void)presentViewController:(UIViewController *)controller animated:(BOOL) animated {
    LKBaseViewController *ctl = [LKMediator selectedCtl];
    if (!controller || !ctl) {
        return;
    }
    [ctl presentViewController:controller animated:animated completion:nil];
}

+ (void)openWelcome{
    LKWelcomeViewController *ctl = [[LKWelcomeViewController alloc] init];
    LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:ctl];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = navi;
    [window makeKeyAndVisible];
}

+ (void)openLauchVC {
    LKLauchViewController *ctl = [[LKLauchViewController alloc] init];
    LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:ctl];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = navi;
    [window makeKeyAndVisible];
}

+ (void)openLogin{
    LKLoginViewController *ctl = [[LKLoginViewController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.rootViewController && [window.rootViewController isKindOfClass:[LKTabBarController class]]) {
        [LKMediator pushViewController:ctl animated:YES] ;
    }else{
        LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:ctl];
        window.rootViewController = navi;
        [window makeKeyAndVisible];
    }
}

+ (void)openSelectUserType{
    LKStateViewController *ctl = [[LKStateViewController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.rootViewController && [window.rootViewController isKindOfClass:[LKTabBarController class]]) {
        [LKMediator pushViewController:ctl animated:YES] ;
    }else{
        LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:ctl];
        window.rootViewController = navi;
        [window makeKeyAndVisible];
    }
}

+ (void)openSearch{
    LKSearchViewController *ctl = [[LKSearchViewController alloc] init];
    [self pushViewController:ctl animated:YES];
}

+ (void)changeLanguage:(NSString *)language{
    [NSBundle setLanguage:language];
    [LKUserDefault setObject:language forKey:kLanguageKey];
    [LKMediator openTabBar:4];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LKSettingViewController *ctl = [[LKSettingViewController alloc] init];
        [LKMediator pushViewController:ctl animated:NO];
    });
}

+ (void)openUserDetail:(NSString *)uid {
    LKUserDetailViewController *vc = [[LKUserDetailViewController alloc] init];
    vc.customerNum = uid;
    [self pushViewController:vc animated:YES];
}

+ (void)openPersonInfo:(NSString *)uid{
    LKPersonInfoViewController *vc = [[LKPersonInfoViewController alloc] init];
    [self pushViewController:vc animated:YES];
}

+ (void)openOrderDetail:(NSString *)order_id{
    LKOderDetailViewController *orderDetail = [[LKOderDetailViewController alloc] init];
    orderDetail.order_id = order_id;
    [self pushViewController:orderDetail animated:YES];
}

+ (void)openAnswerDetail:(NSString *)questionNo{
    LKAnswerDetailViewController *answerDetail = [[LKAnswerDetailViewController alloc] init];
    answerDetail.questionNo = questionNo;
    [self pushViewController:answerDetail animated:YES];
}

+ (void)openAnswerList:(NSString *)type{
    LKAnswerListViewController *answerList = [[LKAnswerListViewController alloc] init];
    answerList.type = type;
    [self pushViewController:answerList animated:YES];
}

+ (void)openTrackDetail:(NSString *)footprintNo{
    LKTrackDetailViewController *trackDetail = [[LKTrackDetailViewController alloc] init];
    trackDetail.footprintNo = footprintNo;
    [self pushViewController:trackDetail animated:YES];

}

+ (void)openImageBrowse:(NSDictionary *)params{
    LKImageBrowseViewController *imageBrowse = [[LKImageBrowseViewController alloc] init];
    imageBrowse.params = params;
    [self pushViewController:imageBrowse animated:YES];
}

+ (void)openShare:(void(^)(LKShareType shareType))finishedBlock{
    LKShareViewController *share = [[LKShareViewController alloc] init];
    share.finishedBlock = finishedBlock;
    [self presentViewController:share animated:YES];
}

@end
