//
//  LKSendTrackTrackCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSendTrackModel.h"

static NSString *kLKSendTrackTrackCellIdentify = @"kLKSendTrackTrackCellIdentify";

@interface LKSendTrackTrackCell : UITableViewCell
@property (nonatomic,copy) void (^addImageBlock)(LKSendTrackAddModel *item);

- (void)configData:(id)data;

+ (CGFloat)getCellHeight:(id)data;

@end
