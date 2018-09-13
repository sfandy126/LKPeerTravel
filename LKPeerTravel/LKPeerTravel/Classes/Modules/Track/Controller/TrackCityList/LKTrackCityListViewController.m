//
//  LKTrackCityListViewController.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackCityListViewController.h"
#import "LKTrackCityListCell.h"
#import "LKTrackCityListModel.h"
#import "LKTrackListViewController.h"

@interface LKTrackCityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *datalists;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LKTrackCityListModel *model;
@end

@implementation LKTrackCityListViewController

- (LKTrackCityListModel *)model{
    if (!_model) {
        _model = [[LKTrackCityListModel alloc] init];
    }
    return _model;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LKTrackCityListCell class] forCellReuseIdentifier:kLKTrackCityListCellIdentifty];
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
    LKTrackCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKTrackCityListCellIdentifty forIndexPath:indexPath];
    LKTrackCityListItemModel *item = [self.datalists objectAt:indexPath.row];
    [cell configData:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
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
    
    LKTrackCityListItemModel *item = [self.datalists objectAt:indexPath.row];

    LKTrackListViewController *trackList = [[LKTrackListViewController alloc] init];
    trackList.cityNo = item.cityNo;
    [self.navigationController pushViewController:trackList animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"城市列表"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    
    [self.view addSubview:self.tableView];

    [self showLoadingView];
    [self loadData];

    @weakify(self);
    [self.tableView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.model.page = 1;
        [self loadData];
    }];
    [self.tableView addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadData];
    }];
    
}

- (void)loadData{
    @weakify(self);
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;
    [self.model loadTrackCityDataWithParams:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.tableView endRefreshing];
        [self refreshData];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.tableView endRefreshing];
    }];
}

- (void)refreshData{
    self.datalists = [NSArray getArray:[self.model.list copy]];
    [self.tableView reloadData];
    
    [self.tableView setNoticeNoMoreData:self.model.isLastPage];
    [self.tableView hiddenFooter:(self.tableView.contentSize.height<self.tableView.height)];
}



@end
