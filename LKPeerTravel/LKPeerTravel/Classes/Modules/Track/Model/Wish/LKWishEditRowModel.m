//
//  LKWishEditRowModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishEditRowModel.h"

@implementation LKWishEditRowModel

+ (instancetype)modelWithTitle:(NSString *)title desc:(NSString *)desc showArrow:(BOOL)showArrow showSwitch:(BOOL)showSwitch {
    LKWishEditRowModel *model = [LKWishEditRowModel new];
    model.title = title;
    model.desc = desc;
    model.showArrow = showArrow;
    model.showSwitch = showSwitch;
    return model;
}

@end
