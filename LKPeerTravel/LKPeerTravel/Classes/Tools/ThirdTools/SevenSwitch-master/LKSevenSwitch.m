//
//  LKSevenSwitch.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSevenSwitch.h"

@implementation LKSevenSwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbTintColor = [UIColor clearColor];
        self.activeColor = [UIColor clearColor];
        self.inactiveColor = [UIColor clearColor];
        self.onTintColor = [UIColor clearColor];
        self.borderColor = [UIColor clearColor];
        self.shadowColor = [UIColor clearColor];
        self.onImageView.image = [UIImage imageNamed:@"btn_service_switch_on"];
        self.onImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.offImageView.image = [UIImage imageNamed:@"btn_service_switch_off"];
        self.offImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end
