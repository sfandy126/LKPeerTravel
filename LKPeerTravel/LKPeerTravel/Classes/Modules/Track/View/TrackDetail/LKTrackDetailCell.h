//
//  LKTrackDetailCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackDetailModel.h"

static NSString *kLKTrackDetailCellIdentify = @"kLKTrackDetailCellIdentify";


@interface LKTrackDetailCell : UITableViewCell

- (void)configData:(LKTrackInfoModel *)model;

+ (CGFloat)getCellHeight:(id)data;

@end