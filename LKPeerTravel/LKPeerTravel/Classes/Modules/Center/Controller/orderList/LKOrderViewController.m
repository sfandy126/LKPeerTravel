//
//  LKOrderViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderViewController.h"
#import "LKOrderMainView.h"

@interface LKOrderViewController () <LKOrderMainViewDelegate>
@property (nonatomic,strong) LKOrderMainView *mainView;
@property (nonatomic,strong) LKOrderServer *server;

@end

@implementation LKOrderViewController

- (LKOrderMainView *)mainView{
    if (!_mainView){
        _mainView = [[LKOrderMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight)];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (LKOrderServer *)server{
    if (!_server) {
        _server = [[LKOrderServer alloc] init];
    }
    return _server;
}

- (void)setOrderType:(NSInteger)orderType{
    _orderType = orderType;
    
    self.server.orderType = orderType+1;

    self.server.clickIndex = orderType;

    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        self.server.orderIndexMap = @{@"0":@(1),@"1":@(1),@"2":@(2),@"3":@(-1)};
        /*待服务 已服务 已取消*/
        if (orderType==0||orderType==1) {
            self.server.staus = 3;
        } else if (orderType==2) {
            self.server.staus = 4;
        } else if (orderType==3) {
            self.server.staus = -1;
        }
    } else {
        self.server.orderIndexMap = @{@"0":@(0),@"1":@(1),@"2":@(2),@"3":@(-1)};

        /*待支付 已支付 已完成 已取消*/
        if (orderType==0) {
            self.server.staus = 0;
        } else if (orderType==1) {
            self.server.staus = 1;
        } else if (orderType==2) {
            self.server.staus = 2;
        } else if (orderType==3) {
            self.server.staus = -1;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"订单"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    self.mainView.server = self.server;
    [self.view addSubview:self.mainView];
    
    @weakify(self);
    [self.mainView.tableview addLegendHeaderRefreshBlock:^{
        @strongify(self);
        [self.server resetParams];
//        [self.server resetParamsWithOrderType:self.orderType];
        [self loadData];
    }];
    [self.mainView.tableview addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadData];
    }];
    
    self.mainView.switchSegmentBlock = ^(NSInteger index) {
        @strongify(self);
        [self loadData];
    };
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)loadData{
    [self showLoadingView];
    @weakify(self);
    [self.server obtainOrderListDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

- (void)stateOperationFinished {
    [self.server resetParams];
    [self loadData];
}

@end
