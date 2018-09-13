//
//  LKTrackOrderListViewController.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/7.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  发布足迹-关联的订单列表
 *
 **/

#import "LKBaseViewController.h"

@interface LKTrackOrderListViewController : LKBaseViewController

///外面带过来的订单编号，需要标记为已选中状态
@property (nonatomic,copy) NSString *selectedOrderNo;

///选择的数据回调
@property (nonatomic,copy) void (^selectedBlock)(NSDictionary *data);

@end
