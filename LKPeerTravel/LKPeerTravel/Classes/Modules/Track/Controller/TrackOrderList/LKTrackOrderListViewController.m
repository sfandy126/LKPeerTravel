//
//  LKTrackOrderListViewController.m
//  LKPeerTravel
//
//  Created by LK on 2018/8/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackOrderListViewController.h"
#import "LKTrackOrderListCell.h"

@interface LKTrackOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *datalists;
@property (nonatomic,strong) LKTrackOrderListModel *model;
@property (nonatomic,assign) BOOL isFirstEndter;
@end

@implementation LKTrackOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"订单列表"];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [self.tableView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.model.page=1;
        [self loadData];
    }];
    [self.tableView addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadData];
    }];
    
    [self showLoadingView];
    [self loadData];
    self.isFirstEndter = YES;
}

- (void)loadData{
    @weakify(self);
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;
    [self.model loadTrackOrderDataWithParams:@{@"no":[LKUserInfoUtils getUserNumber],@"status":@(2),@"type":@"1",@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}

- (LKTrackOrderListModel *)model{
    if (!_model) {
        _model = [[LKTrackOrderListModel alloc] init];
    }
    return _model;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[LKTrackOrderListCell class] forCellReuseIdentifier:kLKTrackOrderListCellIdentify];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datalists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LKTrackOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKTrackOrderListCellIdentify forIndexPath:indexPath];
    LKTrackOrderListItemModel *item = [self.datalists objectAt:indexPath.section];
    [cell configData:item];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LKTrackOrderListCell getCellHeight:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKTrackOrderListItemModel *item = [self.datalists objectAt:indexPath.section];
    for (LKTrackOrderListItemModel *itemModel in self.datalists) {
        if (item == itemModel) {
            itemModel.isSelected = YES;
        }else{
            itemModel.isSelected = NO;
        }
    }
    [self.tableView reloadData];
    
    if (self.selectedBlock) {
        self.selectedBlock([NSDictionary getDictonary:[item modelToJSONObject]]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneLoading{
    [self.tableView endRefreshing];
    self.datalists = [NSArray getArray:self.model.list];
    //每次重新进入该界面才执行一次
    if (self.isFirstEndter) {
        self.isFirstEndter = NO;
        for (LKTrackOrderListItemModel *item in self.datalists) {
            if (self.selectedOrderNo.length>0 && [item.orderNo isEqualToString:self.selectedOrderNo]) {
                item.isSelected = YES;
            }else{
                item.isSelected = NO;
            }
        }
    }

    [self.tableView reloadData];
    [self.tableView setNoticeNoMoreData:self.model.isLastPage];
    [self.tableView hiddenFooter:(self.tableView.contentSize.height<self.tableView.height)];
}



@end
