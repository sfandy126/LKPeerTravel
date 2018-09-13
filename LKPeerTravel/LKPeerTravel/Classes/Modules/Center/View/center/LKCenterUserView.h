//
//  LKCenterUserView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKCenterModel.h"

@interface LKCenterUserView : UIView
@property (nonatomic,strong) LKCenterModel *model;

@end

@interface LKCenterUserIconView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *num;

@end
