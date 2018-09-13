//
//  LKMyServerServer.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseServer.h"
#import "LKMyServerModel.h"

@interface LKMyServerServer : LKBaseServer

@property (nonatomic,strong) LKMyServerModel *model;

@property (nonatomic,copy) NSArray *cellLists;

- (LKMyServerType )getCellType:(NSInteger )section;

///获取我的服务接口
- (void)obtainMyServerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///保存我的服务接口
- (void)saveMyServerDataFinishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

- (void)saveMyServerParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;
@end
