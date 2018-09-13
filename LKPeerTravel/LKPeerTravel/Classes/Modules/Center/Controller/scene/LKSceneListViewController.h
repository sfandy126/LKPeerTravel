//
//  LKSceneListViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/27.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"


/**
 景点列表--添加景点
 */
@interface LKSceneListViewController : LKBaseViewController

@property (nonatomic, assign) NSInteger point_type;
@property (nonatomic, strong) NSString *customNum;
@property (nonatomic, copy) void (^finishedSelectedBlock) (NSArray *scenes,NSInteger pointType);
@end
