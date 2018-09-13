//
//  LKUserDetailModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/27.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKUserDetailModel : NSObject

@property (nonatomic, strong) NSString *customerNumber;//    String    客户编号
@property (nonatomic, strong) NSString *loginNumber;//    String    登陆名
@property (nonatomic, assign) NSInteger carStatus;//    int    1-已认证;0-未认证
@property (nonatomic, strong) NSString *customerName;//    String    客户名称
@property (nonatomic, strong) NSString *customerType;//    String    客户类型1=下游；2=上游
@property (nonatomic, strong) NSString *customerNm;//    int    昵称
@property (nonatomic, assign) NSInteger commentNum;//    int    评论数
@property (nonatomic, assign) NSInteger serviceNum;//    int    服务数,订单数
@property (nonatomic, assign) NSInteger collectionNum;//    int    收藏数

@property (nonatomic, assign) NSInteger browseNum;//    int    浏览数
@property (nonatomic, strong) NSString *starLevel;//    String    星级
@property (nonatomic, strong) NSString *customerMobile;//    String    手机号码
@property (nonatomic, strong) NSString *icType;//    String    证件类型 1=身份证
@property (nonatomic, strong) NSString *icNo;//    String    证件号码
@property (nonatomic, strong) NSString *portraitPic;//    String    头像
@property (nonatomic, assign) NSInteger age;//    int    年龄
@property (nonatomic, strong) NSString *city;//    String    城市编码
@property (nonatomic, strong) NSString *cityName;//    String    城市名称
@property (nonatomic, strong) NSString *mail;//    String    邮件
@property (nonatomic, strong) NSString *maritalstatus;//    String    婚姻状态1=未婚；2=已婚
@property (nonatomic, strong) NSString *gender;//    String    性别1=女；2=男
@property (nonatomic, strong) NSString *status;//    String    状态1=正常；2=禁用
@property (nonatomic, strong) NSString *txtDesc;//    String    自我介绍
@property (nonatomic, strong) NSString *txtRemark;//    String    备注
@property (nonatomic, strong) NSString *prsCode;//    String    推荐码
@property (nonatomic, strong) NSString *rcmCode;//    String    推荐人的推荐码
@property (nonatomic, strong) NSString *datCreate;//    String    创建时间
@property (nonatomic, strong) NSString *speechIntroduction;//    String    语音说明
@property (nonatomic, strong) NSArray *language;//    [{}]    语言,结构和job一样
@property (nonatomic, strong) NSArray *job;//    [{}]    工作
/*
@property (nonatomic, strong) NSString *labelNo;//    string    编号
@property (nonatomic, strong) NSString *labelName;//    string    名称
 */
@property (nonatomic, strong) NSArray *hobby;//    [{}]    爱好 ,结构和job一样

@end
