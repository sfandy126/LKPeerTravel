//
//  LKCenterHeaderView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterHeaderView.h"

#import "LKCenterUserView.h"
#import "LKCenterOrderView.h"

@implementation LKCenterHeaderView

{
    LKCenterUserView *_userView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120)];
        bgIV.image = [UIImage imageNamed:@"img_my_block_yellow"];
        [self addSubview:bgIV];
        
        LKCenterUserView *userView = [[LKCenterUserView alloc] initWithFrame:CGRectMake(6, 74, self.width-12, 178)];
        [self addSubview:userView];
        _userView = userView;
        
        LKCenterOrderView *orderView = [[LKCenterOrderView alloc] initWithFrame:CGRectMake(6, userView.bottom+3, self.width-12, 152)];
        orderView.selectedBlock = ^(NSInteger index) {
            if (self.selectedOrderBlock) {
                self.selectedOrderBlock(index);
            }
        };
        [self addSubview:orderView];
        
        self.height = orderView.bottom+2;
    }
    return self;
}

- (void)setModel:(LKCenterModel *)model {
    _model = model;
    
    _userView.model = model;
}

@end
