//
//  LKGuideListViewController.m
//  LKPeerTravel
//
//  Created by LK on 2018/8/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKGuideListViewController.h"
#import "LKGuideListModel.h"
#import "LKGuideListCell.h"

@interface LKGuideListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LKGuideListModel *model;
@end

@implementation LKGuideListViewController

- (LKGuideListModel *)model{
    if (!_model) {
        _model = [[LKGuideListModel alloc] init];
    }
    return _model;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView hiddenFooter:YES];
        [_tableView registerClass:[LKGuideListCell class] forCellReuseIdentifier:kLKGuideListCellIdentify];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"导游列表";
    [self.navigationItem setTitle:self.cityName];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
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
}

- (void)loadData{
    @weakify(self);
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;
    [self.model obtainGuideListData:@{@"cityNo":[NSString stringValue:self.cityNo],@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKGuideListCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKGuideListCellIdentify forIndexPath:indexPath];
    LKGuideListItemModel *item = [self.model.list objectAt:indexPath.section];
    [cell configData:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKGuideListItemModel *item = [self.model.list objectAt:indexPath.section];
    return [LKGuideListCell getCellHeight:item];
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
    LKGuideListItemModel *item = [self.model.list objectAt:indexPath.section];
    //进入导游客态主页
    [LKMediator openUserDetail:item.uid];
}

- (void)doneLoading{
    [self.tableView endRefreshing];
    [self.tableView reloadData];
    [self.tableView hiddenFooter:(self.tableView.contentSize.height<self.tableView.height)];
    [self.tableView setNoticeNoMoreData:self.model.isLastPage];
}



@end
