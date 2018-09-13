//
//  LKAnswerListViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerListViewController.h"
#import "LKAnswerNewestCell.h"
#import "LKAnswerListServer.h"
#import "LKAnswerDetailViewController.h"

@interface LKAnswerListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) LKAnswerListServer *server;
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation LKAnswerListViewController

- (void)setType:(NSString *)type{
    _type = type;
    self.server.questionListType = type;
}

- (LKAnswerListServer *)server{
    if (!_server) {
        _server = [[LKAnswerListServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问答列表";
    
    [self.view addSubview:self.tableview];
    
     @weakify(self);
    [self.tableview addLegendHeaderRefreshBlock:^{
        @strongify(self);
        [self.server resetParams];
        [self loadData:NO];
    }];
    [self.tableview addLegendFooterRefreshBlock:^{
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
    [self.server obtainAnswerListDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [UIView new];
        [_tableview hiddenFooter:YES];
        [_tableview registerClass:[LKAnswerNewestCell class] forCellReuseIdentifier:kAnswerNewestCellIdentify];
    }
    return _tableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.server.model.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKAnswerNewestCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnswerNewestCellIdentify forIndexPath:indexPath];
    LKAnswerSingleModel *item = [self.server.model.datalist objectAt:indexPath.row];
    [cell configData:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKAnswerSingleModel *item = [self.server.model.datalist objectAt:indexPath.row];
    return [LKAnswerNewestCell getCellHeight:item];
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKAnswerSingleModel *item = [self.server.model.datalist objectAt:indexPath.row];
    LKAnswerDetailViewController *vc = [[LKAnswerDetailViewController alloc] init];
    vc.answerModel = item;
    [LKMediator pushViewController:vc animated:YES];
}

- (void)doneLoading{
    [self.tableview hiddenFooter:(self.tableview.contentSize.height<self.tableview.height)];
    [self.tableview endRefreshing];
    [self.tableview reloadData];
    
    if (self.server.model.isLastPage) {
        [self.tableview noticeNoMoreData];
    }else{
        [self.tableview resetNoMoreData];
    }
}


@end
