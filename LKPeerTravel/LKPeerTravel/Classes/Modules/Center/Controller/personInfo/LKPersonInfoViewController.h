//
//  LKPersonInfoViewController.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  个人资料界面
 *
 *
 **/

#import "LKBaseViewController.h"

#import "LKCenterModel.h"

@interface LKPersonInfoViewController : LKBaseViewController

@property (nonatomic,copy) NSString *uid;
@property (nonatomic, strong) LKCenterModel *model;

@end
