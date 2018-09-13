//
//  LKHomeHelperCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//
/**
 *  私人助手cell
 *
 *
 **/

#import <UIKit/UIKit.h>
#import "LKHomeModel.h"

static NSString *kHomeHelperCellIdentify = @"kHomeHelperCellIdentify";

@interface LKHomeHelperCell : LKBaseCell

//换一批回调
@property (nonatomic,copy) void (^batchButBlock)(void);

//点击导游头像回调
@property (nonatomic,copy) void (^clickGuideBlock)(NSString *uid);

- (void)configData:(id)data;

+ (CGFloat)getCellHeight:(id)data;

@end


@interface LKHomeHelperCollectionCell : UICollectionViewCell

- (void)configData:(LKHomeGuideModel *)model;

@end
