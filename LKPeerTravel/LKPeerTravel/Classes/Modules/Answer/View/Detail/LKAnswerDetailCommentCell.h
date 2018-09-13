//
//  LKAnswerDetailCommentCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAnswerDetailModel.h"

static NSString *LKAnswerDetailCommentCellReuseIndentifier = @"LKAnswerDetailCommentCellReuseIndentifier";

@interface LKAnswerDetailCommentCell : UITableViewCell

- (void)configData:(LKAnswerCommentModel *)data indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(LKAnswerCommentModel *)data indexPath:(NSIndexPath *)indexPath;

@end

static NSString *kLKAnswerDetailSubCommentCellIdentify = @"kLKAnswerDetailSubCommentCellIdentify";


@interface LKAnswerDetailSubCommentCell :LKBaseCell

@property (nonatomic,strong) UILabel *contentLab;

- (void)configData:(LKAnswerCommentModel *)subItem;

+ (CGFloat )getSubCellHeight:(LKAnswerCommentModel *)subItem;

@end
