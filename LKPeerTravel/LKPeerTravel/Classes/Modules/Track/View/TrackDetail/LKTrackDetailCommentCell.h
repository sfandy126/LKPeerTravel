//
//  LKTrackDetailCommentCell.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackDetailModel.h"

static NSString *kLKTrackDetailCommentCellIdentify = @"kLKTrackDetailCommentCellIdentify";


@interface LKTrackDetailCommentCell : UITableViewCell

- (void)configData:(LKTrackCommentModel *)data indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(LKTrackCommentModel *)data indexPath:(NSIndexPath *)indexPath;


@end

static NSString *kLKTrackDetailSubCommentCellIdentify = @"kLKTrackDetailSubCommentCellIdentify";


@interface LKTrackDetailSubCommentCell :LKBaseCell

@property (nonatomic,strong) UILabel *contentLab;

- (void)configData:(LKTrackCommentModel *)subItem;

+ (CGFloat )getSubCellHeight:(LKTrackCommentModel *)subItem;

@end
