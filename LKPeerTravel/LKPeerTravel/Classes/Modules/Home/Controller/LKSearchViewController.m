//
//  LKSearchViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSearchViewController.h"
#import "LKSearchBarView.h"
#import "LKSegmentView.h"
#import "LKSearchModel.h"
#import "LKSearchTableListView.h"

#import "LKAnswerDetailViewController.h"

@interface LKSearchViewController ()<UISearchBarDelegate,UIScrollViewDelegate,LKSearchTableListViewDelegate>
@property (nonatomic,strong) LKSearchBarView *searchView;
@property (nonatomic,strong) LKSegmentView *segment;
@property (nonatomic,assign) LKSearchType searchType;
@property (nonatomic,strong) UIScrollView *contentScroll;
@property (nonatomic,strong) LKSearchModel *model;
@property (nonatomic,strong) NSString *searchKeyword;

@end

@implementation LKSearchViewController


- (LKSearchBarView *)searchView{
    if (!_searchView) {
        _searchView = [[LKSearchBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-100, 27)];
        _searchView.searchItemStyle = LKSearchItemStyle_gray;
        _searchView.canClick = YES;
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _searchView.placeholderColor = [UIColor colorWithHexString:@"#c8c8c8"];
        _searchView.searchItemStyle = LKSearchItemStyle_gray;
        _searchView.layer.cornerRadius = 3.0;
        _searchView.layer.masksToBounds = YES;
        _searchView.placeholder = @"输入导游，城市名称进行搜索";
    }
    return _searchView;
}

- (LKSegmentView *)segment{
    if (!_segment) {
        _segment = [[LKSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 33)];
        _segment.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _segment.selectdTitleFont = [UIFont boldSystemFontOfSize:12.0];
        _segment.selectdTitleColor = [UIColor colorWithHexString:@"#333333"];
        _segment.unSelectdTitleFont = [UIFont systemFontOfSize:12.0];
        _segment.unSelectdTitleColor = [UIColor colorWithHexString:@"#999999"];
        _segment.layoutStyle = LKSegmentLayoutStyle_center;
        _segment.paddingEdgeInsets = UIEdgeInsetsZero;
        _segment.proccessHeight = 5.0;
        _segment.proccessWidth = 50;
        _segment.titles = @[@"导游",@"足迹",@"问答"];
        @weakify(self);
        _segment.selectedBlock = ^(NSInteger index) {
            @strongify(self);
            self.searchType = index+1;
            self.contentScroll.contentOffset = CGPointMake(kScreenWidth *index, 0);
            [self loadData];
        };
    }
    return _segment;
}

- (UIScrollView *)contentScroll{
    if (!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segment.height, kScreenWidth, kScreenHeight - kNavigationHeight -self.segment.height)];
        _contentScroll.contentSize = CGSizeMake(kScreenWidth*self.segment.titles.count, 0);
        _contentScroll.backgroundColor = [UIColor clearColor];
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.delegate = self;
        _contentScroll.pagingEnabled = YES;
        
        for (int i=0; i<3; i++) {
            LKSearchTableListView *listView = [[LKSearchTableListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _contentScroll.height)];
            listView.left = _contentScroll.width*i;
            listView.backgroundColor = [UIColor clearColor];
            listView.tag = 6000+i;
            listView.searchType = i+1;
            listView.delegate = self;
            [_contentScroll addSubview:listView];
        }
    }
    return _contentScroll;
}

- (LKSearchModel *)model{
    if (!_model) {
        _model = [[LKSearchModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self.navigationItem setTitle:@"搜索界面"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
    self.searchView.searchBar.delegate = self;
    self.navigationItem.titleView=self.searchView;
    
    if(@available(iOS 11.0, *)){
//        [self.searchView.widthAnchor constraintEqualToConstant:kScreenWidth-100].active = YES;
    }
    
    
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBut.frame = CGRectMake(0, 0, 44, 44);
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    cancelBut.titleLabel.font = kFont(14);
    if (kSystemVersion>11.0) {
        [cancelBut.widthAnchor constraintEqualToConstant:44].active=YES;
    }
    [cancelBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
    
    [self.segment showSegment];
    [self.view addSubview:self.segment];
    
    [self.view addSubview:self.contentScroll];
    
    //默认第一个为导游
    self.searchType = LKSearchType_guide;
}

- (void)cancelAction{
    [self.searchView.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    NSInteger page = 1;
    if (self.searchType == LKSearchType_guide) {
        page = self.model.guideListModel.page;
    }
    if (self.searchType == LKSearchType_track) {
        page = self.model.trackListModel.page;
    }
    if (self.searchType == LKSearchType_answer) {
        page = self.model.answerListModel.page;
    }
    LKPageInfo *pageInfo = [[LKPageInfo alloc] init];
    pageInfo.pageNum = page;
    
    @weakify(self);
    [self.model obtainSearchListDataWithParams:@{@"keyword":[NSString stringValue:self.searchKeyword],@"searchType":[NSString stringWithFormat:@"%zd",self.searchType],@"page":[NSDictionary getDictonary:[pageInfo modelToJSONObject]]} finishedBlock:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    } failedBlock:^(LKBaseModel *item, NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self doneLoading];
    }];
}

- (void)doneLoading{
    LKSearchTableListView *listView = [self.contentScroll viewWithTag:6000+(self.searchType-1)];
    if (self.searchType == LKSearchType_guide) {
        [listView configData:self.model.guideListModel];
    }
    if (self.searchType == LKSearchType_track) {
        [listView configData:self.model.trackListModel];

    }
    if (self.searchType == LKSearchType_answer) {
        [listView configData:self.model.answerListModel];
    }
}

#pragma mark - - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self showLoadingView];
    if (self.searchType == LKSearchType_guide) {
        self.model.guideListModel.page=1;
    }
    if (self.searchType == LKSearchType_track) {
        self.model.trackListModel.page=1;
    }
    if (self.searchType == LKSearchType_answer) {
        self.model.answerListModel.page=1;
    }
    self.searchKeyword = searchBar.text;
    [self loadData];
}

#pragma mark - - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX/kScreenWidth;
    if ((page+1) != self.searchType) {
        [self.segment setSelectedCurrentIndex:page];
        self.searchType = page+1;
    }
}

#pragma mark - - LKSearchTableListViewDelegate

- (void)loadDataIsMore:(BOOL)isMore{
    if (!isMore) {
        if (self.searchType == LKSearchType_guide) {
            self.model.guideListModel.page=1;
        }
        if (self.searchType == LKSearchType_track) {
            self.model.trackListModel.page=1;
        }
        if (self.searchType == LKSearchType_answer) {
            self.model.answerListModel.page=1;
        }
    }
    [self loadData];
}

- (void)didSelectedItem:(id)item indexPath:(NSIndexPath *)indexPath{
    if (item && [item isKindOfClass:[LKSearchGuideModel class]]) {
        LKSearchGuideModel *itemModel = item;
        [LKMediator openUserDetail:itemModel.uid];
    }
    
    if (item && [item isKindOfClass:[LKSearchTrackModel class]]) {
        LKSearchTrackModel *itemModel = item;
        [LKMediator openTrackDetail:itemModel.footprintNo];
    }
    
    if (item && [item isKindOfClass:[LKSearchAnswerModel class]]) {
        LKSearchAnswerModel *itemModel = item;
//        [LKMediator openAnswerDetail:itemModel.questionNo];
        LKAnswerDetailViewController *controller = [[LKAnswerDetailViewController alloc] init];
        controller.params = @{@"questionNo":[NSString stringValue:itemModel.questionNo],
                              @"customerNumber":[NSString stringValue:itemModel.uid],
                              @"customerNm":[NSString stringValue:itemModel.nick_name],
                              @"portraitPic":[NSString stringValue:itemModel.face],
                              @"questionTitle":[NSString stringValue:itemModel.title],
                              @"questionContent":[NSString stringValue:itemModel.content],
                              @"cityName":[NSString stringValue:itemModel.location],
                              @"pageViews":[NSString stringValue:itemModel.looks],
                              @"replyCount":[NSString stringValue:itemModel.comments],
                              @"datCreate":[NSString stringValue:itemModel.datCreate],
                              };
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
