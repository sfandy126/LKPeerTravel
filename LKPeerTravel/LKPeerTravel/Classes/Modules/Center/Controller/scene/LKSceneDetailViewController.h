//
//  LKSceneDetailViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"

@interface LKSceneDetailViewController : LKBaseViewController

@property (nonatomic, strong) NSString *scene_no;

@property (nonatomic, assign) BOOL is_choose;;

@property (nonatomic, copy) void (^finishedSelectedBlock) (NSDictionary *dict);

@end
