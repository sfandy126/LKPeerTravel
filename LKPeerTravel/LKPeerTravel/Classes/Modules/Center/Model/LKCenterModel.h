//
//  LKCenterModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKCenterSectionModel;

typedef NS_ENUM(NSInteger,LKCenterModelType) {
    LKCenterModelType_upUser = 1,  //上游用户
    LKCenterModelType_downUser
};


typedef NS_ENUM(NSInteger,LKCenterRowType) {
    LKCenterRowType_certify = 1, // 认证
    LKCenterRowType_myService, // 我的服务
    LKCenterRowType_serviceProtocol, //服务协议
    LKCenterRowType_inviteCode, // 我的邀请码
    LKCenterRowType_inviceList, // 邀请列表
    LKCenterRowType_phone, // 手机号码
    LKCenterRowType_wechat, // 微信
    LKCenterRowType_facebook,
    LKCenterRowType_wish, // 心愿单
    LKCenterRowType_myTravelList, //我的游记
    LKCenterRowType_myAnswer, // 我的问答
};

@interface LKCenterModel : LKBaseModel

@property (nonatomic,strong) NSArray <LKCenterSectionModel *> *sections;

@property (nonatomic, assign) LKCenterModelType userType;


@property (nonatomic, strong) NSString *customerNumber;//    String    客户编号
@property (nonatomic, strong) NSString *loginNumber;//    String    登陆名
@property (nonatomic, assign) NSInteger carStatus;//    int    1-已认证;0-未认证
@property (nonatomic, strong) NSString *customerName;//    String    客户名称
@property (nonatomic, strong) NSString *customerType;//    String    客户类型1=下游；2=上游
@property (nonatomic, strong) NSString *customerNm;//    int    昵称
@property (nonatomic, assign) NSInteger commentNum;//    int    评论数
@property (nonatomic, assign) NSInteger browseNum;//    int    浏览数
@property (nonatomic, strong) NSString *starLevel;//    String    星级
@property (nonatomic, assign) NSInteger serviceNum;//    int    服务数,订单数

@property (nonatomic, assign) NSInteger collectionNum;//    int    收藏数
@property (nonatomic, assign) NSInteger travelsNum;//    int    游记数,只在下游用户时有值
@property (nonatomic, assign) NSInteger answerNum;//    int    问答数,只在下游用户时有值

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

- (instancetype)initWithUserType:(LKCenterModelType)userType;

- (void)obtainUserDataFinished:(LKFinishedBlock)finished failed:(LKFailedBlock)failed;


@end

@class LKCenterRowModel;

@interface LKCenterSectionModel : NSObject

@property (nonatomic,strong) NSArray <LKCenterRowModel *> *rows;


@end

@interface LKCenterRowModel : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger rowType;

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title desc:(NSString *)desc rowType:(LKCenterRowType)rowType;

@end
