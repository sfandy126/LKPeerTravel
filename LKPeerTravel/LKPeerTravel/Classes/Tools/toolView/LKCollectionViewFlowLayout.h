//
//  LKCollectionViewFlowLayout.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKCollectionViewFlowLayout;

@protocol LKCollectionViewFlowLayoutDelegate <NSObject>
@required

//设置item的高度(宽度layout中根据行展示多少列计算)
- (CGFloat)collectionFlowLayout:(LKCollectionViewFlowLayout *)flowLayout heightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end


@interface LKCollectionViewFlowLayout : UICollectionViewFlowLayout

///每一列之间的间距
@property (nonatomic, assign) CGFloat columnMargin;

///每一行之间的间距
@property (nonatomic, assign) CGFloat rowMargin;

///显示多少列
@property (nonatomic, assign) int columnsCount;

@property (nonatomic, weak) id<LKCollectionViewFlowLayoutDelegate> delegate;

@end
