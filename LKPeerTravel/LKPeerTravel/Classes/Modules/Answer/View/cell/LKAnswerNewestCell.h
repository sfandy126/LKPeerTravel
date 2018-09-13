//
//  LKAnswerNewestCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  最新回答cell
 *
 *
 **/

#import "LKBaseCell.h"
#import "LKAnswerModel.h"


static NSString *kAnswerNewestCellIdentify = @"kAnswerNewestCellIdentify";

@interface LKAnswerNewestCell : LKBaseCell

@end

@interface LKAnswerUserView : UIView

- (void)configData:(LKAnswerSingleModel *)model;

@end

