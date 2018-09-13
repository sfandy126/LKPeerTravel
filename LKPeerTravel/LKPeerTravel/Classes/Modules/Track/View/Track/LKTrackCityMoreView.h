//
//  LKTrackCityMoreView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  更多城市
 *
 *
 **/

#import <UIKit/UIKit.h>
#import "LKTrackModel.h"

@interface LKTrackCityMoreView : UIView
@property (nonatomic,copy) void (^selectedBlock)(LKTrackCityModel *item);

- (void)configData:(NSArray *)citys;

@end

@interface LKTrackCityMoreCollectionCell : UICollectionViewCell

- (void)configData:(LKTrackCityModel *)model;

@end
