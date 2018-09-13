//
//  LKTrackViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackViewController.h"
#import "LKTrackMainView.h"
#import "LKSearchBarView.h"
#import "LKTrackCityListViewController.h"
#import "LKTrackListViewController.h"

@interface LKTrackViewController ()<LKTrackMainViewDelegate>
@property (nonatomic,strong) LKTrackMainView *mainView;
@property (nonatomic,strong) LKTrackServer *server;
@property (nonatomic,strong) LKNavigationBar *naviBar;
@property (nonatomic,strong) LKSearchBarView *searchView;
@end

@implementation LKTrackViewController

- (LKSearchBarView *)searchView{
    if (!_searchView) {
        _searchView = [[LKSearchBarView alloc] initCustomWithFrame:CGRectMake(0, 0, 240, 25)];
        _searchView.centerX = kScreenWidth/2.0;
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _searchView.placeholderColor = [UIColor colorWithHexString:@"#969696"];
        _searchView.searchItemStyle = LKSearchItemStyle_gray;
        _searchView.layer.cornerRadius = 4.0;
        _searchView.layer.masksToBounds = YES;
        _searchView.placeholder = @"输入导游，城市名称进行搜索";
    }
    return _searchView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = LKLocalizedString(@"LKTabbar_title_anwser");//@"足迹";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];

    self.server = [[LKTrackServer alloc] init];
    self.mainView = [[LKTrackMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -kTabBarHeight)];
    self.mainView.delegate =self;
    self.mainView.server = self.server;
    [self.view addSubview:self.mainView];
    
    self.naviBar = [[LKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [self.naviBar setTitleAlpha:0];
    [self.naviBar updataNavigationAlpha:0];
    self.searchView.hidden = YES;
    [self.naviBar setTitleView:self.searchView];
    self.naviBar.hidden = YES;
    [self.view addSubview:self.naviBar];
    
    @weakify(self);
    self.searchView.clickSearchBarBlock = ^{
        @strongify(self);
        [self didClickedSearchBar];
    };
    
    [self.mainView.collectionView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.server.refreshType = LKRefreshType_Refresh;
        [self loadData:NO];
    }];
    [self.mainView.collectionView addLegendFooterRefreshBlock:^{
        @strongify(self);
        self.server.refreshType = LKRefreshType_LoadMore;
        [self loadTrackList];
    }];
 
    [self loadData:YES];
}

- (void)loadData:(BOOL)isShowLoading{
    if (isShowLoading) {
        [self showLoadingView];
    }
    [self loadBannerData];
    [self loadCityList];
    [self loadTrackList];
}

- (void)loadBannerData{
     @weakify(self);
    [self.server loadTrackBannerDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

- (void)loadCityList {
    @weakify(self);
    [self.server loadCityClassDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

- (void)loadTrackList {
     @weakify(self);
    [self.server loadTrackListDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}


#pragma mark -- LKTrackMainViewDelegate

- (void)mainViewScrollContentOffsetY:(CGFloat)offsetY {
    @weakify(self);
    [self.naviBar setOffsetY:offsetY alphaBlock:^(CGFloat alpha) {
        @strongify(self);
        self.naviBar.hidden = alpha<=0;
        self.searchView.hidden = NO;
        self.searchView.alpha = alpha;
    }];
}

- (void)didSelectedItem:(LKTrackCityModel *)cityModel indexPath:(NSIndexPath *)indexPath{
    [LKMediator openTrackDetail:cityModel.footprintNo];
}

- (void)didClickedSearchBar{
    [LKMediator openSearch];
}

- (void)didSwitchSegment:(NSInteger)index{
    self.server.selectedType = (index==1?LKTrackSelectedType_Hot:LKTrackSelectedType_Newest);
    [self loadTrackList];
}

- (void)didSelectedBannerWithIndex:(NSInteger)index{    
    [LKMediator openTrackDetail:self.server.model.headerModel.footprintNo];

}

- (void)didSelectedCityClass:(LKTrackCityModel *)cityModel isMore:(BOOL)isMore{
    if (isMore) {
        LKTrackCityListViewController *controller = [[LKTrackCityListViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        LKTrackListViewController *trackList = [[LKTrackListViewController alloc] init];
        trackList.cityNo = cityModel.city_id;
        [self.navigationController pushViewController:trackList animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
