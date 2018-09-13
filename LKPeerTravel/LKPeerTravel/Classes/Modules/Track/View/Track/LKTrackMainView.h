//
//  LKTrackMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackServer.h"

@protocol LKTrackMainViewDelegate <NSObject>

@optional

- (void)mainViewScrollContentOffsetY:(CGFloat)offsetY;

- (void)didSelectedItem:(LKTrackCityModel *)cityModel indexPath:(NSIndexPath *)indexPath;

- (void)didClickedSearchBar;

- (void)didSwitchSegment:(NSInteger )index;

- (void)didSelectedBannerWithIndex:(NSInteger )index;

- (void)didSelectedCityClass:(LKTrackCityModel *)cityModel isMore:(BOOL)isMore;

@end

@interface LKTrackMainView : UIView

@property (nonatomic,weak) LKTrackServer *server;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id<LKTrackMainViewDelegate> delegate;

- (void)doneLoading;

@end
