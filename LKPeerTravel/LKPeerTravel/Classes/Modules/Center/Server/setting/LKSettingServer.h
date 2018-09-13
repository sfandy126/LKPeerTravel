//
//  LKSettingServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKSettingModel.h"

@interface LKSettingServer : LKBaseServer

@property (nonatomic,strong) LKSettingModel *model;

@end
