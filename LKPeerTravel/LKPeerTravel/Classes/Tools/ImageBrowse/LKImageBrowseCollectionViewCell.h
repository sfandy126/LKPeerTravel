//
//  LKImageBrowseCollectionViewCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImageBrowseModel.h"

static NSString *kLKImageBrowseCollectionViewCellIdentify = @"kLKImageBrowseCollectionViewCellIdentify";

@interface LKImageBrowseCollectionViewCell : UICollectionViewCell

- (void)configData:(LKImageBrowseSingleModel *)item;

@end


