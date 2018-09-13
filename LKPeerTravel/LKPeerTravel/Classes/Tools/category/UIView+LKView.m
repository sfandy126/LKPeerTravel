//
//  UIView+LKView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIView+LKView.h"

@implementation UIView (LKView)

+ (UIView *)createLineWithX:(CGFloat )x y:(CGFloat)y{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, kScreenWidth -x*2, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    return lineView;
}

+ (UIView *)createLineWithFrame:(CGRect )rect{
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    return lineView;
}

@end
