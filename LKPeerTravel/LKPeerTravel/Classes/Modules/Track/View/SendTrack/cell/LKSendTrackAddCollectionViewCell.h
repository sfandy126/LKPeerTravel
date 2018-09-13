//
//  LKSendTrackAddCollectionViewCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSendTrackModel.h"

static NSString *kLKSendTrackAddCollectionViewCellIdentify = @"kLKSendTrackAddCollectionViewCellIdentify";

@interface LKSendTrackAddCollectionViewCell : UICollectionViewCell


- (void)configData:(LKSendTrackAddModel *)item;

@end
