//
//  LKWishEditModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/21.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKWishEditModel : NSObject

@property (nonatomic,strong) NSString *customerNumber;//    是    String    用户编码
@property (nonatomic,strong) NSString *codWishNo;//    否    String    心愿编号，新增的时候不填或者传”0”, 编辑心愿时必填
@property (nonatomic,assign) NSInteger codPeopleCount;//    是    Int    人数
@property (nonatomic,assign) NSInteger codBudgetAmount;//    是    long    预算
@property (nonatomic,strong) NSString *flgCar;//    是    String    有车优先 （1 是 ，2 否）
@property (nonatomic,strong) NSString *flagPickUp;//    是    String    接机优先 （1 是 ，2 否）
@property (nonatomic,strong) NSString *endTime;//    是    String    结束时间 格式 yyyy-MM-dd
@property (nonatomic,strong) NSString *beginTime;//    是    String    开始时间 格式 yyyy-MM-dd
@property (nonatomic,strong) NSString *language;//    是    String    语言标签编号，多个用逗号隔开
@property (nonatomic,strong) NSString *wishLabel;//    是    String    心愿标签，多个用逗号隔开
@property (nonatomic,strong) NSString *codCityNo;//    是    String    城市编号

@end
