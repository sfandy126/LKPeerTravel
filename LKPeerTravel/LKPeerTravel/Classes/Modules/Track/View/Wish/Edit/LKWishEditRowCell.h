//
//  LKWishEditRowCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKWishEditRowModel.h"

static NSString *LKWishEditRowCellReuseIndentifier = @"LKWishEditRowCellReuseIndentifier";

@interface LKWishEditRowCell : UITableViewCell

@property (nonatomic, strong) LKWishEditRowModel *model;
@property (nonatomic, copy) void (^switchValueChanged) (BOOL on,LKWishEditRowModel *row);

@end
