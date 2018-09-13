//
//  LKTrackOrderListCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackOrderListModel.h"

static NSString *kLKTrackOrderListCellIdentify = @"kLKTrackOrderListCellIdentify";

@interface LKTrackOrderListCell : LKBaseCell

- (void)configData:(LKTrackOrderListItemModel *)data;

@end
