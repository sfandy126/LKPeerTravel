//
//  LKOderDetailViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"

@interface LKOderDetailViewController : LKBaseViewController
///订单编号
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,assign) BOOL shouldScrollBottom;

///处理一些操作成功后，需要刷新订单列表接口
@property (nonatomic,copy) void (^handleBlock)(void);

@end
