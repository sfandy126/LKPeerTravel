//
//  LKUserDetailUserView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKUserDetailModel.h"



@interface LKUserDetailUserView : UIView

@property (nonatomic, strong) LKUserDetailModel *detailModel;


@end


@interface LKUserDetailUserIconView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *num;

@end
