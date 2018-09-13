//
//  LKWishListMainView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKWishMainModel.h"

@interface LKWishListMainView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataLists;
@property (nonatomic, copy) void (^editWishBlock) (LKWishListModel *model);
@end
