//
//  LKServerModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/21.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKServerModel : NSObject

@property (nonatomic, strong) NSString *serviceNo;//    String    服务编号 ,不为空时为修改
@property (nonatomic, strong) NSString *codNo;//    String    用户编号
@property (nonatomic, strong) NSString *flagCar;//    String    是否要车, 1-是;0-否
@property (nonatomic, strong) NSString *flagPlane;//    String    是否安排接机, 1-是;0-否
@property (nonatomic, strong) NSArray *dateSets;//     [{}]    安排时间
@property (nonatomic, strong) NSArray *dateDisables;//    [{}    不可设置为休息的时间
@property (nonatomic, strong) NSArray *attractions;//     [{}]    景点数据
/*
@property (nonatomic, strong) NSString *codDestinationPointLogo;//     String    景点图片
@property (nonatomic, strong) NSString *codDestinationPointName;//     String    景点名称
@property (nonatomic, strong) NSString *codDestinationPointNo;//     String    景点编码
 */
@property (nonatomic, strong) NSArray *shopps;//     [{}]    商场数据,结构同景点数据
@property (nonatomic, strong) NSArray *foods;//    [{}]    美食数据,结构同景点数据
@property (nonatomic, strong) NSArray *discounts;//     [{}]    折扣信息
/*
@property (nonatomic, strong) NSString *discountNo;//     String    折扣编号,不为空时为修改
@property (nonatomic, strong) NSString *discountPost;//     String    折扣
@property (nonatomic, strong) NSString *maxNum;//     String    最在人数
@property (nonatomic, strong) NSString *minNum;//     String    最小人数
 */
@property (nonatomic, assign) double point;//     double    价格
@property (nonatomic, assign) NSInteger pmax;//     int    服务人员上限

@end
