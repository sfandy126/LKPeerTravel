//
//  LKTabBarItemView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/5/26.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTabBarItemView.h"

@implementation LKTabBarItemView

@synthesize icon;
@synthesize title;
@synthesize lbage;
@synthesize tipView;
@synthesize badgeView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, width, height - 10)];
        icon.contentMode = UIViewContentModeCenter;
        [self addSubview:icon];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(0, height*0.65f, width, height*0.3f)];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"";
        title.font = [UIFont systemFontOfSize:10];
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        tipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icn-number-bg"]];
        tipView.frame = CGRectMake(width-25, 5, 21, 18);
        [self addSubview:tipView];
        tipView.hidden = YES;
        
        lbage = [[UILabel alloc] initWithFrame:CGRectMake(width-25, 5, 21, 18)];
        lbage.textAlignment = NSTextAlignmentCenter;
        lbage.font = [UIFont systemFontOfSize:12];
        lbage.textColor = [UIColor whiteColor];
        [self addSubview:lbage];
        lbage.hidden = YES;
        
        
        badgeView = [[LKBadgeView alloc] init];
        [self addSubview:badgeView];
        
    }
    return self;
}

@end
