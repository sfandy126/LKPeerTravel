//
//  LKOrderListShopsView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  订单列表中的商品容器
 *
 *
 **/

#import <UIKit/UIKit.h>
#import "LKOrderModel.h"

#define titleTop 10.0
#define titleAndCollectionInval 17.0
#define collectionBottom 7.0

@interface LKOrderListShopsView : UIView

///配置订单列表的选择的订单服务
- (void)configData:(LKOrderListModel *)model;

///配置订单详情的选择的订单服务
- (void)configOrderDetailData:(NSArray *)datas shopsHeight:(CGFloat )shopsHeight;

@end


@interface LKOrderListShopFlowLayout : UICollectionViewFlowLayout

@end


@interface LKOrderListShopsViewCell : UICollectionViewCell

- (void)configData:(LKOrderSingleShopModel *)item;

@end
