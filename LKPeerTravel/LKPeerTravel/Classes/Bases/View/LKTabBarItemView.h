//
//  LKTabBarItemView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/5/26.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKBadgeView.h"

@interface LKTabBarItemView : UIView

@property (nonatomic,readonly) UIImageView *icon; //图标
@property (nonatomic,readonly) UILabel *title; //标题
@property (nonatomic,strong) UILabel *lbage;
@property (nonatomic,strong) UIImageView *tipView;
@property (nonatomic,strong) LKBadgeView *badgeView;

@property (nonatomic, copy) NSString *badgeNum;

@end
