//
//  LKTrackCityCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseCell.h"
#import "LKTrackModel.h"

static NSString *kTrackCityCollectionCellIdentify = @"kTrackCityCollectionCellIdentify";

@interface LKTrackCityCell : UICollectionViewCell

- (void)configData:(LKTrackCityModel *)model;

@end


///用户信息视图
@interface LKTrackUserView : UIView

- (void)configData:(LKTrackCityModel *)model;

@end
