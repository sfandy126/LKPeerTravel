//
//  LKWishListMainView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishListMainView.h"

#import "LKWishListCell.h"

#import "LKWishEditViewController.h"

#import <YYTimer.h>

@interface LKWishListMainView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) YYTimer *timer;

@end

@implementation LKWishListMainView

- (void)dealloc {
    [_timer invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        
        _timer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) repeats:YES];
    }
    return self;
}

- (void)countDown {
    NSArray *cells = [self.tableView visibleCells];
    for (LKWishListCell *listCell in cells) {
        if ([listCell isKindOfClass:LKWishListCell.class]) {
            [listCell countDown];
        }
    }
}

- (void)setDataLists:(NSArray *)dataLists {
    _dataLists = dataLists;
    
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKWishListCell *cell = [tableView dequeueReusableCellWithIdentifier:LKWishListCellReuseIndentifier];
    cell.model = [_dataLists objectAt:indexPath.row];
     @weakify(self);
    cell.reEditBlock = ^(LKWishListModel *model) {
        @strongify(self);
        LKWishEditViewController *vc = [LKWishEditViewController new];
        vc.model = model;
        
        LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:vc];
        
        [self.lk_viewController presentViewController:navi animated:YES completion:nil];
    };
    cell.deleteBlock = ^(LKWishListModel *model) {
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKWishListModel *model = [_dataLists objectAt:indexPath.row];
    return [LKWishListCell heightWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableBackgroundColor;
        [_tableView registerClass:[LKWishListCell class] forCellReuseIdentifier:LKWishListCellReuseIndentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return _tableView;
}

@end
