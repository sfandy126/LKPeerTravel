//
//  LKSearchAnswerCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSearchModel.h"

static NSString *kLKSearchAnswerCellIdentify = @"kLKSearchAnswerCellIdentify";

@interface LKSearchAnswerCell : UITableViewCell

- (void)configData:(LKSearchAnswerModel *)item;

+ (CGFloat)getCellHeight:(LKSearchAnswerModel *)item;

@end


@interface LKSearchAnswerUserView : UIView

- (void)configData:(LKSearchAnswerModel *)model;

@end
