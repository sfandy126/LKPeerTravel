//
//  LKAnswerHotCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  热门回答cell
 *
 *
 **/

#import "LKBaseCell.h"
#import "LKAnswerModel.h"

static NSString *kAnswerHotCellIdentify = @"kAnswerHotCellIdentify";

@interface LKAnswerHotCell : LKBaseCell
@property (nonatomic,copy) void(^selectedBlock)(LKAnswerSingleModel *item);
@end


@interface LKAnswerHotAnswerCell :UICollectionViewCell

- (void)configData:(LKAnswerSingleModel *)model;

@end
