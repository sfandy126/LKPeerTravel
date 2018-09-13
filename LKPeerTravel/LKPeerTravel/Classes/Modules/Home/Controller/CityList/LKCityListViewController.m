//
//  LKCityListViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCityListViewController.h"
#import "LKCityListCell.h"
#import "LKGuideListViewController.h"

@interface LKCityListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LKHomeCityListModel *model;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LKCityListViewController

- (LKHomeCityListModel *)model{
    if (!_model) {
        _model = [[LKHomeCityListModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市列表";
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [self.tableView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.model.page=1;
        [self loadData:NO];
    }];
    
    [self.tableView addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadData:NO];
    }];
    
    [self loadData:YES];
}

- (void)loadData:(BOOL)isShowLoading{
    if (isShowLoading) {
        [self showLoadingView];
    }
    @weakify(self);
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;
    [self.model obtainHomeCityListData:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.datalists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:LKCityListCellReuseIndentifier];
    LKHomeCityItemModel *item = [self.model.datalists objectAt:indexPath.row];
    [cell configData:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKHomeCityItemModel *item = [self.model.datalists objectAt:indexPath.row];
    LKGuideListViewController *controller = [[LKGuideListViewController alloc] init];
    controller.cityNo = item.cityNo;
    controller.cityName = item.cityName;
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[LKCityListCell class] forCellReuseIdentifier:LKCityListCellReuseIndentifier];
        _tableView.backgroundColor = TableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView hiddenFooter:YES];
    }
    return _tableView;
}

- (void)doneLoading{
    [self.tableView endRefreshing];
    [self.tableView reloadData];
    [self.tableView hiddenFooter:(self.tableView.contentSize.height<self.tableView.height)];
    if (self.model.isLastPage) {
        [self.tableView noticeNoMoreData];
    }else{
        [self.tableView resetNoMoreData];
    }
}


@end
