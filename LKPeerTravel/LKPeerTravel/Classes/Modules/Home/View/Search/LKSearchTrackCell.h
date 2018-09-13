//
//  LKSearchTrackCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSearchModel.h"

static NSString *kLKSearchTrackCellIdentify = @"kLKSearchTrackCellIdentify";

@interface LKSearchTrackCell : UITableViewCell

- (void)configData:(LKSearchTrackModel *)item;

+ (CGFloat)getCellHeight:(LKSearchTrackModel *)item;


@end
