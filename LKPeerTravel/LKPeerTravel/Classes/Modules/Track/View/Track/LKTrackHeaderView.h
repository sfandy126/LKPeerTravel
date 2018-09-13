//
//  LKTrackHeaderView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackModel.h"

///头部背景高度
#define headerIconHeight 240
///更多城市分类的高度
#define moreCityHeight 80
///菜单栏的高度
#define segmentHeight 40
#define segmentTop 36

#define headerHeight (headerIconHeight+moreCityHeight+(segmentTop+segmentHeight))

static NSString *kTrackHeaderIdentify = @"kTrackHeaderIdentify";


@class LKTrackHeaderView;
@protocol LKTrackHeaderViewDelegate <NSObject>

@optional
///菜单栏选择的代理
- (void)headerView:(LKTrackHeaderView *)headerView selectedSegement:(NSInteger )index;

///选择城市分类的代理
- (void)headerView:(LKTrackHeaderView *)headerView selectedSingleCity:(LKTrackCityModel *)item isMore:(BOOL)isMore;

///点击头部搜索框
- (void)headerViewWithClickedSearchBar;

///顶部banner点击
- (void)headerViewDidSelectedBannerWithIndex:(NSInteger)index;

@end


@interface LKTrackHeaderView : UICollectionReusableView

@property (nonatomic,weak) id<LKTrackHeaderViewDelegate> delegate;

- (void)configData:(LKTrackModel *)model;

@end




