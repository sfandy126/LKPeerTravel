//
//  LKGuideListCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKGuideListModel.h"

static NSString *kLKGuideListCellIdentify = @"kLKGuideListCellIdentify";

@interface LKGuideListCell : LKBaseCell

@end

///标签view
@interface LKGuideTagView :UIView

- (void)configData:(NSArray *)tags;

@end

///底部view
@interface LKGuideBottomView :UIView

- (void)configData:(LKGuideListItemModel*)model;

@end

///星级
@interface LKGuideStarView :UIView

- (void)configData:(NSString *)star;

@end
