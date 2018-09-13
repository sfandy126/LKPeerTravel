//
//  LKSelectCityMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/8.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSelectedCityServer.h"

@interface LKSelectCityMainView : UIView
@property (nonatomic,weak) LKSelectedCityServer *server;

@property (nonatomic,copy) void (^sureBlock)(NSString *city_id,NSString *city_name);
@property (nonatomic,copy) void (^skipBlock)(void);
@property (nonatomic,copy) void (^searchBlock)(NSString *city_name);

- (instancetype)initWithFrame:(CGRect)frame isChoose:(BOOL)isChoose;

- (void)refreshData;

@end
