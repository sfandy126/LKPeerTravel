//
//  LKUserInfoUtils.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/25.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  封装用户信息处理层。
 *
 *  所有有关用户信息，都通过该工具类调用。
 **/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LKLoginType) {
    LKLoginType_guest=0,     //游客
    LKLoginType_default=1,     //普通登录
    LKLoginType_wechat=2,      //微信登录
    LKLoginType_qq=3,          //QQ登录
    LKLoginType_sina=4,       //新浪微博登录
    LKLoginType_facebook=5,    //facebook登录
    LKLoginType_twitter=6,     //twitter登录
};

typedef NS_ENUM(NSInteger,LKUserType) {
    LKUserType_Default = 0,//未选择身份
    LKUserType_Traveler = 1,//游客(下游)
    LKUserType_Guide = 2,//导游(上游)
};

@class LKUserInfoModel;
@interface LKUserInfoUtils : NSObject

+ (void)saveUserInfoModel:(NSDictionary *)dict;

+ (LKUserInfoModel *)getUserInfoModel;

//key必须为模型的属性名一致
+ (void)updateValue:(NSString *)value withKey:(NSString *)key;

//不建议把LKUserInfoModel放在外部
+ (void)updateModel:(LKUserInfoModel*)model;

+ (NSString *)getUserID;

+ (NSString *)getAccount;

+ (NSString *)getUserNickName;

+ (BOOL)isBindIphone;

+ (NSString *)getUserIphone;

+ (NSString *)getUserEmail;

+ (LKLoginType)getLoginType;

+ (LKUserType)getUserType;

+ (void)setUserType:(LKUserType)userType;

///获取用户编号
+ (NSString *)getUserNumber;

/// 登录token
+ (NSString *)token;

@end


@interface LKUserInfoModel :NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,assign) BOOL isBindIphone;
@property (nonatomic,copy) NSString *iphone;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,assign) LKLoginType login_type;
@property (nonatomic,assign) LKUserType user_type;
///用户编号
@property (nonatomic,copy) NSString *customerNumber;

///登录token
@property (nonatomic,copy) NSString *token;


+ (id)modelWithDict:(NSDictionary *)dict;

@end
