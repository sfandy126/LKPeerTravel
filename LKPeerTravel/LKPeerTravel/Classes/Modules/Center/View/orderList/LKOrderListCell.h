//
//  LKOrderListCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseCell.h"
#import "LKOrderModel.h"

static NSString *kLKOrderListCellIdentify = @"kLKOrderListCellIdentify";

@interface LKOrderListCell : LKBaseCell
@property (nonatomic,copy) void (^clickedStateHandleBlock)(LKOrderListModel *item,LKOrderHandleType handleType);

- (void)configData:(LKOrderListModel *)model;

@end

@interface LKOrderListHeaderView : UIView
- (void)configData:(LKOrderListModel *)model;
@end


@interface LKOrderListFootView : UIView

@property (nonatomic,copy) void (^clickedStateHandleBlock)(LKOrderListModel *item,LKOrderHandleType handleType);

- (void)configData:(LKOrderListModel *)model;
@end
