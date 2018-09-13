//
//  LKWishListViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishListViewController.h"

#import "LKWishListMainView.h"
#import "LKWishMainModel.h"

#import "LKWishEditViewController.h"

@interface LKWishListViewController ()

@property (nonatomic, strong) LKWishListMainView *mainView;
@property (nonatomic, strong) LKPageInfo *page;
@property (nonatomic, strong) NSMutableArray *datalists;

@end

@implementation LKWishListViewController

- (NSMutableArray *)datalists {
    if (!_datalists) {
        _datalists = [NSMutableArray array];
    }
    return _datalists;
}

- (LKPageInfo *)page {
    if (!_page) {
        _page = [[LKPageInfo alloc] init];
    }
    return _page;
}

- (LKWishListMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LKWishListMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight)];
        
         @weakify(self);
        [_mainView.tableView addLegendHeaderRefreshBlock:^{
            @strongify(self);
            [self loadDataAdPage:1];
        }];
        [_mainView.tableView addLegendFooterRefreshBlock:^{
            @strongify(self);
            [self loadDataAdPage:self.page.pageNum+1];
        }];
    }
    return _mainView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"心愿单列表";
    [self.view addSubview:self.mainView];
    
    [self loadDataAdPage:1];
}


- (void)loadDataAdPage:(NSInteger)page {
    @weakify(self);
    self.page.pageNum = page;
    [LKHttpClient POST:@"tx/cif/customer/wish/list" parameters:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"page":[NSDictionary getDictonary:[self.page modelToJSONObject]]} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        LKWishMainModel *model = [LKWishMainModel modelWithDictionary:result.data];
        if (result.success) {
            self.page.pageNum = page;
            if (page==1) {
                [self.datalists removeAllObjects];
            }
            self.page.pageNum = page;
         
            [self.datalists addObjectsFromArray:model.dataList];
        }
        self.mainView.dataLists = self.datalists;
        
        if (page==1) {
            [self.mainView.tableView endHeaderRefreshing];
        } else {
            [self.mainView.tableView endFooterRefreshing];
            if (model.dataList.count==0) {
                [self.mainView.tableView noticeNoMoreData];
            }
        }
       
        [self.mainView.tableView hiddenFooter:self.mainView.tableView.contentSize.height<self.mainView.tableView.height];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.mainView.tableView endRefreshing];
    }];
}


@end
