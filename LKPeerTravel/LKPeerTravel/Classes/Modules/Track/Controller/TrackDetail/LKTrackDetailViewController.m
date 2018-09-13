//
//  LKTrackDetailViewController.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailViewController.h"
#import "LKTrackDetailMainView.h"

@interface LKTrackDetailViewController ()

@property (nonatomic,strong) LKTrackDetailMainView *mainView;
@property (nonatomic,strong) LKTrackDetailServer *server;

@end

@implementation LKTrackDetailViewController

- (void)setFootprintNo:(NSString *)footprintNo{
    _footprintNo = footprintNo;
    self.server.footprintNo = footprintNo;
}

- (LKTrackDetailMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKTrackDetailMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _mainView;
}

- (LKTrackDetailServer *)server{
    if (!_server) {
        _server = [[LKTrackDetailServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainView.server = self.server;
    self.mainView.vc =self;
    [self.view addSubview:self.mainView];
    
    @weakify(self);
    [self.mainView.tableView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        [self.server resetParams];
        [self loadTrackInfoData];
    }];
    [self.mainView.tableView addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadTrackCommentData];
    }];
    
    self.mainView.addCommentBlock = ^(NSString *inputComment) {
        @strongify(self);
        [self addComment:inputComment];
    };
    
    [self showLoadingView];
    [self loadData];
}

- (void)loadData{
    [self loadTrackInfoData];
    [self loadTrackCommentData];
}

- (void)loadTrackInfoData{
    @weakify(self);
    [self.server loadTrackInfoDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

- (void)loadTrackCommentData{
    @weakify(self);
    [self.server loadCommentsFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

///新增评论
- (void)addComment:(NSString *)intputStr{
    [self showLoadingView];
    @weakify(self);
    [self.server addCommentWithParams:@{@"commentCustomerNumber":[LKUserInfoUtils getUserNumber],@"footprintNo":[NSString stringValue:self.footprintNo],@"commentContent":[NSString stringValue:intputStr]} finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        [LKUtils showMessage:item.replyText];
        if (isFinished) {
            [self loadTrackCommentData];
        }
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        [LKUtils showMessage:@"上传失败，请检查网络"];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    ///上报足迹详情浏览记录接口
    [self.server reportedTrackDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
