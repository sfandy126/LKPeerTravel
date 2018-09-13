//
//  LKOrderDetailUserInfoCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKOrderDetailModel.h"

static NSString *LKOrderDetailUserInfoCellReuseIndentifier = @"LKOrderDetailUserInfoCellReuseIndentifier";

@interface LKOrderDetailUserInfoCell : UITableViewCell

- (void)configData:(LKOrderDetailModel *)model;

@end
