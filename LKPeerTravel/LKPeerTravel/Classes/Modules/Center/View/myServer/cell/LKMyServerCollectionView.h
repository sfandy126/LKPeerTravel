//
//  LKMyServerCollectionView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKMyServerModel.h"


@interface LKMyServerCollectionView : UIView

@property (nonatomic, copy) void (^deleteItemBlock) (LKMyServerCityModel *itemModel);

- (void)configData:(LKMyServerTypeModel *)datas;

@end


@interface LKMyServerItemFlowLayout : UICollectionViewFlowLayout

@end


@interface LKMyServerItemViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^deleteItemBlock) (LKMyServerCityModel *itemModel);
- (void)configData:(LKMyServerCityModel *)item;

@end
