//
//  LKTrackListHeaderView.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackListModel.h"

static NSString *kLKTrackListHeaderViewIdentify = @"kLKTrackListHeaderViewIdentify";


@class LKTrackHeaderView;
@protocol LKTrackListHeaderViewDelegate <NSObject>

@optional

- (void)didClickedBannerWithItem:(LKTrackCityModel *)item;


@end

@interface LKTrackListHeaderView : UICollectionReusableView

@property (nonatomic,weak) id<LKTrackListHeaderViewDelegate> delegate;


- (void)configData:(LKTrackCityModel *)item;

@end
