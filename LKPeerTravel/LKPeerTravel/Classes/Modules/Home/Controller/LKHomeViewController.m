//
//  LKHomeViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeViewController.h"
#import "LKHomeMainView.h"
#import "LKSearchBarView.h"

#import "LKCityListViewController.h"
#import "LKSelectCityViewController.h"
#import "LKGuideListViewController.h"

@interface LKHomeViewController ()<LKHomeMainViewDelegate>
@property (nonatomic,strong) LKHomeServer *server;
@property (nonatomic,strong) LKHomeMainView *mainView;
@property (nonatomic,strong) LKNavigationBar *naviBar;
@property (nonatomic,strong) LKSearchBarView *searchView;

@end

@implementation LKHomeViewController

- (LKSearchBarView *)searchView{
    if (!_searchView) {
        _searchView = [[LKSearchBarView alloc] initCustomWithFrame:CGRectMake(0, 30, 240, 25)];
        _searchView.centerX = kScreenWidth/2.0;
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _searchView.placeholderColor = [UIColor colorWithHexString:@"#969696"];
        _searchView.searchItemStyle = LKSearchItemStyle_gray;
        _searchView.layer.cornerRadius = 4.0;
        _searchView.layer.masksToBounds = YES;
        _searchView.placeholder = @"输入导游，城市名称进行搜索";
        _searchView.clickSearchBarBlock = ^{
            [LKMediator openSearch];
        };
    }
    return _searchView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    
    self.naviBar = [[LKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [self.naviBar updataNavigationAlpha:0];
    [self.naviBar setLeftItemImage:@"btn_home_top_none" target:self action:@selector(leftItemAction)];
    [self.naviBar setTitleView:self.searchView];
    self.searchView.hidden = YES;
    self.naviBar.hidden = YES;
    [self.naviBar setTitleHidden:YES];

    self.server = [[LKHomeServer alloc] init];
    self.mainView = [[LKHomeMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight)];
    self.mainView.delegate = self;
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.naviBar];
    self.mainView.server = self.server;
    
    @weakify(self);
    [self.mainView.tableview addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.server.isLoadMore = NO;
        [self refreshData];
    }];
    [self.mainView.tableview addLegendFooterRefreshBlock:^{
        @strongify(self);
        self.server.isLoadMore = YES;
        [self loadHotGuideData];
    }];
    
    [self.mainView doneLoading];

    [self loadData];
}

- (void)loadData{
    [self showLoadingView];
    [self loadBannerData];
    [self loadHotCityData];
    [self loadPrivateGuiderData];
    [self loadHotGuideData];
}

- (void)refreshData{
    [self loadBannerData];
    [self loadHotCityData];
    [self loadPrivateGuiderData];
    [self loadHotGuideData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark - -  加载数据

- (void)loadBannerData{
    @weakify(self);
    [self.server obtainHomeBanerDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView endRefresh];
        if (isFinished) {
            [self.mainView doneLoading];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
    }];
}

- (void)loadHotCityData{
    @weakify(self);
    [self.server obtainHomeHotCityDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView endRefresh];
        if (isFinished) {
            [self.mainView doneLoading];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
    }];
}

- (void)loadPrivateGuiderData{
    @weakify(self);
    [self.server obtainHomePrivateGuiderDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView endRefresh];
        if (isFinished) {
            [self.mainView doneLoading];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
    }];
}

- (void)loadHotGuideData{
    @weakify(self);
    [self.server obtainHomeHotGuiderDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView endRefresh];
        if (isFinished) {
            [self.mainView doneLoading];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
    }];
}

#pragma mark - - Action

- (void)leftItemAction{
    if (self.mainView.isScrolling) {
        NSLog(@"视图正在滚动，不可点击");
        return;
    }
    [self.mainView.tableview setContentOffset:CGPointZero];
}

#pragma mark -- LKHomeMainViewDelegate

- (void)mainViewScrollContentOffsetY:(CGFloat)offsetY {
    @weakify(self);
    [self.naviBar setOffsetY:offsetY alphaBlock:^(CGFloat alpha) {
        @strongify(self);
        self.naviBar.hidden = alpha<=0;
       [self.naviBar setLeftItemHidden:(alpha<0.5)];
    }];

    CGFloat alphaSearch = MIN(1, 1 - ((115 + kNavigationHeight - offsetY) / kNavigationHeight));
    self.searchView.hidden = NO;
    self.searchView.alpha = alphaSearch;
}

///点击单个热门城市
- (void)didSelectedItem:(LKHomeHotCityModel *)cityModel indexPath:(NSIndexPath *)indexPath{
    LKGuideListViewController *controller = [[LKGuideListViewController alloc] init];
    controller.cityNo = cityModel.city_id;
    controller.cityName = cityModel.city_name;
    [self.navigationController pushViewController:controller animated:YES];
}

///查看城市列表
- (void)didClickSeeMore {
    LKCityListViewController *vc = [LKCityListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

///换一批次
- (void)didClickedChangeBatch{
    [self loadPrivateGuiderData];
}

///选择城市
- (void)didClickedChangeCity{
    LKSelectCityViewController *cityCtl = [[LKSelectCityViewController alloc] init];
    cityCtl.isChoose = YES;
    cityCtl.selectCityBlock = ^(NSString *city_id, NSString *city_name) {
        if (city_id.length>0) {
            self.server.page = 1;
            self.server.selected_city_id = city_id;
            self.server.selected_city_name = city_name;
            [self loadHotGuideData];
        }
    };
    [LKMediator pushViewController:cityCtl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
