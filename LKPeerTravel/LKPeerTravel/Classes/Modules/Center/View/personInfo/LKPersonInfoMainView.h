//
//  LKPersonInfoMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPersonInfoServer.h"
#import "LKCenterModel.h"

@interface LKPersonInfoMainView : UIView

@property (nonatomic,weak) LKPersonInfoServer *server;
@property (nonatomic,strong) LKCenterModel *model;

- (void)doneLoading;

@end
