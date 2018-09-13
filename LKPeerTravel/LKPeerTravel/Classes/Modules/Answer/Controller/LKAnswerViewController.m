//
//  LKAnswerViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerViewController.h"
#import "LKAnswerMainView.h"

#import "LKAnswerEditViewController.h"
#import "LKAnswerListViewController.h"

@interface LKAnswerViewController ()
@property (nonatomic,strong) LKAnswerServer *server;
@property (nonatomic,strong) LKAnswerMainView *mainView;

@property (nonatomic,strong) UIButton *askBut;
@property (nonatomic,strong) UIButton *answerBut;
@end

@implementation LKAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"问答";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];

    self.server = [[LKAnswerServer alloc] init];
    self.mainView = [[LKAnswerMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight- kNavigationHeight-kTabBarHeight)];
    [self.view addSubview:self.mainView];
    self.mainView.server = self.server;
    
    if ([LKUserInfoUtils getUserType] == LKUserType_Traveler) {
        self.askBut.right = kScreenWidth;
        self.askBut.bottom = kScreenHeight - kTabBarHeight -20;
        
        self.answerBut.right = self.askBut.right;
        self.answerBut.bottom = self.askBut.top - 10;
        [self.navigationController.view addSubview:self.askBut];
    }else{
        self.answerBut.right = kScreenWidth;
        self.answerBut.bottom = kScreenHeight - kTabBarHeight -20;
    }
    [self.navigationController.view addSubview:self.answerBut];
    
    @weakify(self);
    [self.mainView.tableview addLegendHeaderRefreshBlock:^{
        @strongify(self);
        [self.server resetParams];
        [self loadData:NO];
    }];
    [self.mainView.tableview addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadLastestData];
    }];
    
    [self loadData:YES];

}

- (void)loadData:(BOOL)isShowLoading{
    if (isShowLoading) {
        [self showLoadingView];
    }
    @weakify(self);
    [self.server obtainAnswerHotListDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
    
    [self loadLastestData];
}

- (void)loadLastestData{
    @weakify(self);
    [self.server obtainAnswerLastestListDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.askBut.hidden = NO;
    self.answerBut.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count>1) {
        self.askBut.hidden = YES;
        self.answerBut.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UIButton *)askBut{
    if (!_askBut) {
        _askBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _askBut.backgroundColor = [UIColor clearColor];
        _askBut.frame = CGRectMake(0, 0, 50, 40);
        [_askBut setBackgroundImage:[UIImage imageNamed:@"btn_answer_ask_none"] forState:UIControlStateNormal];
        [_askBut addTarget:self action:@selector(askButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _askBut;
}

- (UIButton *)answerBut{
    if (!_answerBut) {
        _answerBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _answerBut.backgroundColor = [UIColor clearColor];
        _answerBut.frame = CGRectMake(0, 0, 50, 40);
        [_answerBut setBackgroundImage:[UIImage imageNamed:@"btn_answer_answer_none"] forState:UIControlStateNormal];
        [_answerBut addTarget:self action:@selector(answerButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerBut;
}


- (void)askButAction{
    LKAnswerEditViewController *vc = [[LKAnswerEditViewController alloc] init];
    [LKMediator pushViewController:vc animated:YES];
}

- (void)answerButAction{
    [LKMediator openAnswerList:@"3"];
}


@end
