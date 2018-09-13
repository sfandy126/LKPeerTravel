//
//  LKUserDetailHeaderView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailHeaderView.h"

#import "LKUserDetailUserView.h"

@implementation LKUserDetailHeaderView

{
    LKUserDetailUserView *_userView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120)];
        bgIV.image = [UIImage imageNamed:@"img_my_block_yellow"];
        [self addSubview:bgIV];
        
        LKUserDetailUserView *userView = [[LKUserDetailUserView alloc] initWithFrame:CGRectMake(6, 74, self.width-12, 178)];
        [self addSubview:userView];
        _userView = userView;
     
        
        self.height = userView.bottom+2;
    }
    return self;
}

- (void)setDetailModel:(LKUserDetailModel *)detailModel {
    _detailModel = detailModel;
    
    _userView.detailModel = detailModel;
}

@end



