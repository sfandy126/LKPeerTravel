//
//  LKMediator.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  公共跳转类
 *
 *
 **/


#import <Foundation/Foundation.h>

@interface LKMediator : NSObject

///打开tabbar
+ (void)openTabBar;

+ (void)openTabBar:(NSInteger )index;

///选择的控制器
+ (LKBaseViewController *)selectedCtl;

///安全push方法
+ (void)pushViewController:(LKBaseViewController *)controller animated:(BOOL) animated;

+ (void)presentViewController:(UIViewController *)controller animated:(BOOL) animated;

///打开欢迎引导界面,直接设置为root
+ (void)openWelcome;

+ (void)openLauchVC;

///打开登录界面，如没有tabbar则直接设置为root
+ (void)openLogin;

///打开选择用户类型界面，非正常流程，需重新设置navi为root
+ (void)openSelectUserType;

///打开搜索界面
+ (void)openSearch;

///切换国际化语言
+ (void)changeLanguage:(NSString *)language;

/// 进入客态个人主页
+ (void)openUserDetail:(NSString *)uid;

///打开个人资料界面
+ (void)openPersonInfo:(NSString *)uid;

///打开订单详情
+ (void)openOrderDetail:(NSString *)order_id;

///打开问答详情
+ (void)openAnswerDetail:(NSString *)questionNo;

///打开问答列表
+ (void)openAnswerList:(NSString *)type;

///打开足迹详情
+ (void)openTrackDetail:(NSString *)footprintNo;

///打开查看大图
+ (void)openImageBrowse:(NSDictionary *)params;

///打开分享（分享成功完成回掉）
+ (void)openShare:(void(^)(LKShareType shareType))finishedBlock;

@end
