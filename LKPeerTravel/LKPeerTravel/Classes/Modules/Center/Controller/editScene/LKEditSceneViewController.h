//
//  LKEditSceneViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"


/**
 编辑景点 商场 美食
 */
@interface LKEditSceneViewController : LKBaseViewController

/// 类型,1-景点,2-商场,3-美食
@property (nonatomic, assign) NSInteger point_type;

@property (nonatomic, strong) NSString *scene_id;

@property (nonatomic, copy) void (^successAddBlock) (NSDictionary *dict);

@end
