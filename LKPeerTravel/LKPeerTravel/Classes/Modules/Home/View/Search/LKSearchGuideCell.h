//
//  LKSearchGuideCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSearchModel.h"

static NSString *kLKSearchGuideCellIdentify = @"kLKSearchGuideCellIdentify";

@interface LKSearchGuideCell : UITableViewCell

- (void)configData:(LKSearchGuideModel *)item;

+ (CGFloat)getCellHeight:(LKSearchGuideModel *)item;

@end


///标签view
@interface LKSearchGuideTagView :UIView

- (void)configData:(NSArray *)tags;

@end

///底部view
@interface LKSearchGuideBottomView :UIView

- (void)configData:(LKSearchGuideModel *)model;

@end

///星级
@interface LKSearchStarView :UIView

- (void)configData:(NSString *)star;

@end
