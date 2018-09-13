//
//  LKSearchTableListView.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSearchModel.h"

@protocol LKSearchTableListViewDelegate<NSObject>

- (void)loadDataIsMore:(BOOL)isMore;

- (void)didSelectedItem:(id )item indexPath:(NSIndexPath *)indexPath;

@end

@interface LKSearchTableListView : UIView

@property (nonatomic,assign) id<LKSearchTableListViewDelegate> delegate;

@property (nonatomic,assign) LKSearchType searchType;

@property (nonatomic,strong) UITableView *tableView;

- (void)configData:(LKSearchListModel *)listModel;

@end
