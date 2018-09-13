//
//  LKTrackCityListCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackCityListModel.h"

static NSString *kLKTrackCityListCellIdentifty = @"kLKTrackCityListCellIdentifty";

@interface LKTrackCityListCell : UITableViewCell

- (void)configData:(LKTrackCityListItemModel *)item;

@end


@interface LKTrackCityLooksView : UIView

- (void)configData:(LKTrackCityListItemModel *)model;

@end
