//
//  LKCityListCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKHomeCityListModel.h"

static NSString *LKCityListCellReuseIndentifier = @"LKCityListCellReuseIndentifier";

@interface LKCityListCell : UITableViewCell

- (void)configData:(LKHomeCityItemModel *)model;

@end
