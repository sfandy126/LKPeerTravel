//
//  LKOrderDetailServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKOrderDetailModel.h"

@interface LKOrderDetailServer : NSObject

@property (nonatomic,strong) LKOrderDetailModel *model;

@property (nonatomic,strong) NSString *order_id;

///获取订单详情接口
- (void)obtainOrderDetailDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

@end
