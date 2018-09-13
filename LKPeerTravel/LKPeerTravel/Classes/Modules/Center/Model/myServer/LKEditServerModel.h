//
//  LKEditServerModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 服务编辑信息
 */
@interface LKEditServerModel : NSObject

@property (nonatomic, strong) NSString *no;//    是    String    登陆用户编号
@property (nonatomic, strong) NSString *serviceNo;//    是    String    服务编号 ,不为空时为修改
@property (nonatomic, strong) NSArray *dateSets;//    是    [{}]    日期安排
//@property (nonatomic, strong) NSString *dateOff;//    是    String    时间,如果是区间,需要拆成按天上传数据
@property (nonatomic, assign) double point;//    是    double    价格
@property (nonatomic, assign) NSInteger pmax;//    是    int    服务人员上限
@property (nonatomic, strong) NSArray *attractions;//    是    [{}]    景点数据
//@property (nonatomic, strong) NSString *codDestinationPointLogo;//    是    String    景点图片
//@property (nonatomic, strong) NSString *codDestinationPointName;//    是    String    景点名称
//@property (nonatomic, strong) NSString *codDestinationPointNo;//    是    String    景点编码
@property (nonatomic, strong) NSArray *shopps;//    是    [{}]    商场数据,结构同景点数据
@property (nonatomic, strong) NSArray *foods;//    是    [{}]    美食数据,结构同景点数据
@property (nonatomic, strong) NSArray *discounts;//    是    [{}]    折扣信息
//@property (nonatomic, strong) NSString *discountNo;//    是    String    折扣编号,不为空时为修改
//@property (nonatomic, strong) NSString *discountPost;//    是    String    折扣
//@property (nonatomic, strong) NSString *maxNum;//    是    String    最在人数
//@property (nonatomic, strong) NSString *minNum;//    是    String    最小人数

@property (nonatomic, strong) NSString *flagCar;
@property (nonatomic, strong) NSString *flagPlane;
@end
