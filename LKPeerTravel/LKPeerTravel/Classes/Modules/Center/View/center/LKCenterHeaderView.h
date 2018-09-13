//
//  LKCenterHeaderView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKCenterModel.h"

@interface LKCenterHeaderView : UIView
@property (nonatomic,copy) void (^selectedOrderBlock)(NSInteger index);
@property (nonatomic,strong) LKCenterModel *model;
@end
