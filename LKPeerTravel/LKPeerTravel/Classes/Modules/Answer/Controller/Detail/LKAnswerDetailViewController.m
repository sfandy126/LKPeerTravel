//
//  LKAnswerDetailViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerDetailViewController.h"
#import "LKBottomToolView.h"
#import "LKAnswerDetailHeaderView.h"
#import "LKAnswerDetailCommentCell.h"
#import "LKAnswerDetailSectionView.h"
#import "LKAnswerDetailModel.h"

@interface LKAnswerDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) LKAnswerDetailModel *model;
@property (nonatomic, strong) LKAnswerDetailHeaderView *headerView;
@property (nonatomic,strong) LKAnswerDetailSectionView *sectionView;
@property (nonatomic, strong) LKBottomToolView *bottomToolView;

@end

@implementation LKAnswerDetailViewController

- (void)setParams:(NSDictionary *)params{
    _params = params;
    self.answerModel = [LKAnswerSingleModel modelWithDict:params];
}

- (void)setAnswerModel:(LKAnswerSingleModel *)answerModel{
    _answerModel = answerModel;
}

- (LKAnswerDetailModel *)model{
    if (!_model) {
        _model = [[LKAnswerDetailModel alloc] init];
    }
    return _model;
}

- (LKBottomToolView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[LKBottomToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        _bottomToolView.style = LKBottomToolViewStyle_white;
        _bottomToolView.backgroundColor = [UIColor whiteColor];
        _bottomToolView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bottomToolView.layer.shadowOffset = CGSizeMake(5, 5);
        _bottomToolView.layer.shadowOpacity = 0.8;
        @weakify(self);
        _bottomToolView.clickedBlcok = ^(LKBottomToolViewType type) {
            @strongify(self);
            if (type == LKBottomToolViewType_back) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (type == LKBottomToolViewType_comment) {
                [self editContent];
            }
        };
    }
    return _bottomToolView;
}

- (LKAnswerDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[LKAnswerDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    return _headerView;
}

- (LKAnswerDetailSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[LKAnswerDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    }
    return _sectionView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.bottomToolView.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView hiddenFooter:YES];
        [_tableView registerClass:[LKAnswerDetailCommentCell class] forCellReuseIdentifier:LKAnswerDetailCommentCellReuseIndentifier];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
   
    [self.view addSubview:self.bottomToolView];
    
    @weakify(self);
    [self.tableView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.model.page = 1;
        [self loadMoreData:NO];
    }];
    [self.tableView addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadMoreData:YES];
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
    [self.model loadCommentsWithParams:@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"questionNo":[NSString stringValue:self.answerModel.questionNo]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}

- (void)loadMoreData:(BOOL)isMore{
    if (!isMore) {
        self.model.page=1;
    }
    [self loadData:NO];
}

///新增评论
- (void)addComment:(NSString *)intputStr{
    [self showLoadingView];
    @weakify(self);
    [self.model addCommentWithParams:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"questionNo":[NSString stringValue:self.answerModel.questionNo],@"answerContent":[NSString stringValue:intputStr]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
        [LKUtils showMessage:item.replyText];
        if (isFinished) {
            [self loadMoreData:NO];
        }
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
        [LKUtils showMessage:@"上传失败，请检查网络"];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    ///上报流量问答详情
    [self.model reportedAnswerDetailWithParams:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"bussType":@"2",@"bussNumber":[NSString stringValue:self.answerModel.questionNo]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        
    } failedBlock:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKAnswerDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:LKAnswerDetailCommentCellReuseIndentifier];
    LKAnswerCommentModel *item = [self.model.comments objectAt:indexPath.row];
    [cell configData:item indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKAnswerCommentModel *item = [self.model.comments objectAt:indexPath.row];
    return [LKAnswerDetailCommentCell getCellHeight:item indexPath:indexPath];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.sectionView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)editContent{
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_desc title:@"我要评论"];
    @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        [self addComment:inputStr];
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)doneLoading{
    [self.headerView configData:self.answerModel];
    [self.sectionView configData:self.model];
    [self.tableView endRefreshing];
    [self.tableView reloadData];
    [self.tableView hiddenFooter:(self.tableView.contentSize.height <self.tableView.height)];
    [self.tableView setNoticeNoMoreData:self.model.isLastPage];
}




@end
