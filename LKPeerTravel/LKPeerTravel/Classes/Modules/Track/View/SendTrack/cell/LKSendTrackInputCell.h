//
//  LKSendTrackInputCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSendTrackModel.h"

static NSString *kLKSendTrackInputCellIdentify = @"kLKSendTrackInputCellIdentify";
@interface LKSendTrackInputCell : UITableViewCell

- (void)configData:(LKSendTrackInfoModel *)data;

+ (CGFloat)getCellHeight:(id)data;

- (void)resignTextFieldFirstResponder;
@end
