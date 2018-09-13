//
//  LKWishListCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKWishMainModel.h"

static NSString *LKWishListCellReuseIndentifier = @"LKWishListCellReuseIndentifier";

@interface LKWishListCell : UITableViewCell

@property (nonatomic, strong) LKWishListModel *model;
@property (nonatomic, copy) void (^reEditBlock) (LKWishListModel *model);
@property (nonatomic, copy) void (^deleteBlock) (LKWishListModel *model);

- (void)countDown;

+ (CGFloat)heightWithModel:(LKWishListModel *)model;

@end
