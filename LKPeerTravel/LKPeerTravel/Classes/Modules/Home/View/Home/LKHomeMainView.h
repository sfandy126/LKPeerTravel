//
//  LKHomeMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKHomeServer.h"

@protocol LKHomeMainViewDelegate <NSObject>

@optional

- (void)mainViewScrollContentOffsetY:(CGFloat)offsetY;

- (void)didSelectedItem:(LKHomeHotCityModel *)cityModel indexPath:(NSIndexPath *)indexPath;

///查看更多城市列表
- (void)didClickSeeMore;

///换一批次
- (void)didClickedChangeBatch;

///选择城市
- (void)didClickedChangeCity;


@end


@interface LKHomeMainView : UIView
@property (nonatomic,weak) LKHomeServer *server;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,weak) id<LKHomeMainViewDelegate> delegate;
///是否正在滚动
@property (nonatomic,assign) BOOL isScrolling;


- (void)endRefresh;

- (void)doneLoading;

@end


