//
//  LKSelectCityViewController.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/8.
//  Copyright © 2018年 LK. All rights reserved.
//


/**
 *  选择城市界面
 *
 *
 **/

#import "LKBaseViewController.h"

@interface LKSelectCityViewController : LKBaseViewController

///默认是来自注册流程，其他流程不显示跳过按钮
@property (nonatomic, assign) BOOL isChoose;
@property (nonatomic, copy) void (^selectCityBlock)(NSString *city_id,NSString *city_name);

@end
