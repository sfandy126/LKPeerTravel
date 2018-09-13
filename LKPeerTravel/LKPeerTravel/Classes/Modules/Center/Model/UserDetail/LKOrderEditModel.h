//
//  LKOrderEditModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKOrderEditModel : NSObject


@property (nonatomic, strong)NSString *no;//    是    String    登陆用户编号
@property (nonatomic, strong)NSString *serviceNo;//    是    String    服务编号
@property (nonatomic, assign)double point;//    是    double    价格
@property (nonatomic, strong)NSArray *attractions;//    是    [{}]    景点数据
//@property (nonatomic, strong)NSString *codDestinationPointNo;//    是    String    下游用户选择的景点编号
@property (nonatomic, strong)NSArray *shopps;//    是    [{}]    商场数据,结构同景点数据
@property (nonatomic, strong)NSArray *foods;//    是    [{}]    美食数据,结构同景点数据
@property (nonatomic, assign)NSInteger dNum;//    是    int    天数
@property (nonatomic, assign)NSInteger pNum;//   是    int    人数
@property (nonatomic, strong)NSString *dateStart;//    是    String    开始时间
@property (nonatomic, strong)NSString *dateEnd;//    是    String    结束时间
@property (nonatomic, assign)double discount;//    是    double    折扣

@end
