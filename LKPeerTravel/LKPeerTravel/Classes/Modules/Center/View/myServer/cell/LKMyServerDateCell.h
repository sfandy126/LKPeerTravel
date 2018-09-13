//
//  LKMyServerDateCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/19.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  日期安排cell
 *
 **/

#import <UIKit/UIKit.h>
#import "LKMyServerModel.h"

static NSString *kMyServerDateCellIdentify = @"kMyServerDateCellIdentify";

@interface LKMyServerDateCell : UITableViewCell

- (void)configData:(LKMyServerModel *)model  indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(LKMyServerModel *)model indexPath:(NSIndexPath *)indexPath;


/// 获取休息的时间
- (NSArray *)getDateOffs;

@end

