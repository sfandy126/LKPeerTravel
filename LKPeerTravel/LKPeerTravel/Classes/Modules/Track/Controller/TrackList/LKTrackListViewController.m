//
//  LKTrackListViewController.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackListViewController.h"
#import "LKCollectionViewFlowLayout.h"
#import "LKTrackListHeaderView.h"
#import "LKTrackCityCell.h"
#import "LKTrackListModel.h"

#import "LKSearchBarView.h"

@interface LKTrackListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,LKCollectionViewFlowLayoutDelegate,LKTrackListHeaderViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *datalists;
@property (nonatomic,strong) LKTrackListModel *model;

@property (nonatomic,strong) LKNavigationBar *naviBar;
@property (nonatomic,strong) LKSearchBarView *searchView;
@end

@implementation LKTrackListViewController

- (LKTrackListModel *)model{
    if (!_model) {
        _model = [[LKTrackListModel alloc] init];
    }
    return _model;
}

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
    }
    return _searchView;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKCollectionViewFlowLayout *layout =  [[LKCollectionViewFlowLayout alloc] init];
        layout.delegate = self;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 240);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.columnsCount = 2;
        
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView hiddenFooter:YES];
        [_collectionView  registerClass:[LKTrackListHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLKTrackListHeaderViewIdentify];
        [_collectionView registerClass:[LKTrackCityCell class] forCellWithReuseIdentifier:kTrackCityCollectionCellIdentify];
    }
    return _collectionView;
}

#pragma mark - - <UICollectionViewDataSource,UICollectionViewDelegate>

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datalists.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LKTrackListHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLKTrackListHeaderViewIdentify forIndexPath:indexPath];
        headerView.delegate = self;
        LKTrackCityModel *item = [self.datalists objectAt:0];
        [headerView configData:item];
        return headerView;
    }
    return nil;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKTrackCityCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kTrackCityCollectionCellIdentify forIndexPath:indexPath];
    
    LKTrackCityModel *item = [self.datalists objectAt:indexPath.item];
    [cell configData:item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LKTrackCityModel *item = [self.datalists objectAt:indexPath.item];
    [self openTrackDetail:item];
}

#pragma mark - - LKCollectionViewFlowLayoutDelegate

///设置item的高度
- (CGFloat)collectionFlowLayout:(LKCollectionViewFlowLayout *)flowLayout heightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    LKTrackCityModel *item = [self.datalists objectAt:indexPath.item];
    if (item) {
        return item.itemFrame.height;
    }
    return CGFLOAT_MIN;
}

#pragma mark - - LKTrackListHeaderViewDelegate

///点击头部搜索框
- (void)headerViewWithClickedSearchBar{
    [LKMediator openSearch];
}

- (void)didClickedBannerWithItem:(LKTrackCityModel *)item{
    [self openTrackDetail:item];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
//    @weakify(self);
    [self.naviBar setOffsetY:offsetY alphaBlock:^(CGFloat alpha) {
//        @strongify(self);
        
    }];
}

- (void)openTrackDetail:(LKTrackCityModel *)item{
    [LKMediator openTrackDetail:item.footprintNo];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"我的游记"];
    [self.view addSubview:self.collectionView];
    
    self.naviBar = [[LKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    [self.naviBar setLeftItemImage:@"btn_title_return_none" target:self action:@selector(back)];
    [self.naviBar setTitleAlpha:0];
    [self.naviBar updataNavigationAlpha:0];
    [self.naviBar setTitleView:self.searchView];
    [self.view addSubview:self.naviBar];
    
    @weakify(self);
    self.searchView.clickSearchBarBlock = ^{
        @strongify(self);
        [self headerViewWithClickedSearchBar];
    };
    
    [self.collectionView addLegendHeaderRefreshBlock:^{
        @strongify(self);
        self.model.page = 1;
        [self loadData];
    }];
    [self.collectionView addLegendFooterRefreshBlock:^{
        @strongify(self);
        [self loadData];
    }];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)loadData{
    [self showLoadingView];
    @weakify(self);
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = self.model.page;

    NSDictionary *params = @{};
    if (self.cityNo.length>0) {
        params = @{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"cityNo":[NSString stringValue:self.cityNo]};
    }else{
        NSString *customerNumber = self.customerNumber.length>0?[NSString stringValue:self.customerNumber]:[LKUserInfoUtils getUserNumber];
        params =@{@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]],@"customerNumber":customerNumber};
    }

    [self.model loadTrackListDataWithParams:params finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}

- (void)doneLoading{
    self.datalists = [NSArray getArray:self.model.datalist];
    [self.collectionView endRefreshing];
    [self.collectionView reloadData];
    [self.collectionView setNoticeNoMoreData:self.model.isLastPage];
}




@end
