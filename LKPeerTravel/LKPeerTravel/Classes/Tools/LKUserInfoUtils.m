//
//  LKUserInfoUtils.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/25.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserInfoUtils.h"

#import "NSObject+MJCoding.h"

static  NSString *USERINFOKEY = @"LKUserInfoKey";

@implementation LKUserInfoUtils

+ (void)saveUserInfoModel:(NSDictionary *)dict{
    LKUserInfoModel *model = [LKUserInfoModel modelWithDict:dict];
    if (model) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [LKUserDefault setObject:data forKey:USERINFOKEY];
    }else{
        NSLog(@"保存用户信息失败");
    }
}

+ (LKUserInfoModel *)getUserInfoModel{
    NSData *data = [LKUserDefault objectForKey:USERINFOKEY];
    if (data && [data isKindOfClass:[NSData class]] && data.length>0) {
        LKUserInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    }
    NSLog(@"获取用户信息失败");
    return nil;
}

+ (void)updateValue:(NSString *)value withKey:(NSString *)key{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        [model setValue:value forKey:key];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [LKUserDefault setObject:data forKey:USERINFOKEY];
    }
}

+ (void)updateModel:(LKUserInfoModel*)model{
    if (model) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [LKUserDefault setObject:data forKey:USERINFOKEY];
    }
}

+ (NSString *)getUserID{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.uid;
    }
    return @"";
}

+ (NSString *)getAccount{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.account;
    }
    return @"";
}

+ (NSString *)getUserNickName{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.nick_name;
    }
    return @"";
}

+ (BOOL)isBindIphone{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.isBindIphone;
    }
    return NO;
}

+ (NSString *)getUserIphone{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return [NSString stringValue:model.iphone];
    }
    return @"";
}

+ (NSString *)getUserEmail{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.email;
    }
    return @"";
}

+ (LKLoginType)getLoginType{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.login_type;
    }
    return LKLoginType_guest;
}

+ (LKUserType)getUserType{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return model.user_type;
    }
    return LKUserType_Default;
}

+ (void)setUserType:(LKUserType)userType {
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        model.user_type = userType;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [LKUserDefault setObject:data forKey:USERINFOKEY];
    }
}

///获取用户编号
+ (NSString *)getUserNumber{
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return [NSString stringValue:model.customerNumber];
    }
    return @"";
}

+ (NSString *)token {
    LKUserInfoModel *model = [LKUserInfoUtils getUserInfoModel];
    if (model) {
        return [NSString stringValue:model.token];
    }
    return @"";
}
@end



@implementation LKUserInfoModel

MJCodingImplementation

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]){
        LKUserInfoModel *model = [LKUserInfoModel new];
        model.account = [NSString stringValue:[dict valueForKey:@"account"]];
        model.password = [NSString stringValue:[dict valueForKey:@"password"]];
        model.nick_name = [NSString stringValue:[dict valueForKey:@"nick_name"]];
        model.isBindIphone = [[NSString stringValue:[dict valueForKey:@"isBindIphone"]] boolValue];
        model.iphone = [NSString stringValue:[dict valueForKey:@"iphone"]];
        model.email = [NSString stringValue:[dict valueForKey:@"email"]];
        model.login_type = [[NSString stringValue:[dict valueForKey:@"login_type"]] integerValue];
        model.user_type = [[NSString stringValue:[dict valueForKey:@"customerType"]] integerValue];
        model.customerNumber = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        model.uid = model.customerNumber;
        model.token = [NSString stringValue:[dict valueForKey:@"token"]];
        return model;
    }
    return nil;
}

@end
