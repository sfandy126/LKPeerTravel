//
//  LKHomeHotCityCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  热门城市cell
 *
 *
 **/

#import "LKBaseCell.h"
#import "LKHomeModel.h"

static NSString *kHomeHotCityCellIdentify = @"kHomeHotCityCellIdentify";

@interface LKHomeHotCityCell : LKBaseCell
@property (nonatomic,copy) void (^moreButBlock)(void);

@property (nonatomic,copy) void (^selectedBlock)(LKHomeHotCityModel *item);


@end

@interface LKHomeHotCityCollectionCell : UICollectionViewCell

- (void)configData:(LKHomeHotCityModel *)model;

@end

@interface LKHomeCityCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
