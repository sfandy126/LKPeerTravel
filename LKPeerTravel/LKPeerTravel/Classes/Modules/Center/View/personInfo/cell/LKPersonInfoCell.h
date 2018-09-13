//
//  LKPersonInfoCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKPersonInfoModel.h"
#import "LKCenterModel.h"

static NSString *kLKPersonInfoCellIdentify = @"kLKPersonInfoCellIdentify";

@interface LKPersonInfoCell : UITableViewCell

- (void)configData:(LKCenterModel *)model indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(LKCenterModel *)model indexPath:(NSIndexPath *)indexPath;


@end
