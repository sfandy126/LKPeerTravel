//
//  LKSceneListViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/27.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSceneListViewController.h"

#import "LKSceneListCell.h"

#import "LKSceneListModel.h"

#import "LKSceneDetailViewController.h"

@interface LKSceneListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LKPageInfo *page;
@property (nonatomic, strong) NSMutableArray <LKSceneListModel *>*dataLists;
@property (nonatomic, strong) NSMutableArray <LKSceneListModel *>*selectedScenes;

@end

static NSString *cellID = @"LKSceneListCell";

@implementation LKSceneListViewController

- (LKPageInfo *)page {
    if (!_page) {
        _page = [[LKPageInfo alloc] init];
    }
    return _page;
}

- (NSMutableArray *)dataLists {
    if (!_dataLists) {
        _dataLists = [NSMutableArray array];
    }
    return _dataLists;
}

- (NSMutableArray *)selectedScenes {
    if (!_selectedScenes) {
        _selectedScenes = [NSMutableArray array];
    }
    return _selectedScenes;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LKSceneListCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.point_type==1) {
        self.title = @"景点";
    } else if (self.point_type==2) {
        self.title = @"商场";
    } else if (self.point_type==3) {
        self.title = @"美食";
    }
    
    [self.view addSubview:self.tableView];
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 44, 44);
    [rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBut.titleLabel.font = kBFont(14);
    self.rightBtn = rightBut;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    self.point_type = 2;
    
    [self loadDataAtPage:1];
    
     @weakify(self);
    [self.tableView addHeaderRefreshBlock:^{
        @strongify(self);
        [self loadDataAtPage:1];
    }];
    
    [self.tableView addFooterRefreshBlock:^{
        @strongify(self);
        [self loadDataAtPage:self.page.pageNum+1];
    }];
}

- (void)loadDataAtPage:(NSInteger)page {
    self.page.pageNum = page;
     @weakify(self);
    [LKHttpClient POST:@"tx/cif/CosDestinationPoint/list" parameters:@{@"pointType":@(self.point_type),@"customerNumber":self.customNum?self.customNum:[LKUserInfoUtils getUserNumber],@"page":[self.page modelToJSONObject],@"type":@(1)} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            self.page.pageNum = page;
            if (page==1) {
                [self.dataLists removeAllObjects];
            }
            NSArray *array = [NSArray getArray:result.data[@"dataList"]];
            for (NSDictionary *dict in array) {
                LKSceneListModel *model = [LKSceneListModel modelWithDictionary:dict];
                [self.dataLists addObject:model];
            }
        }
        [self.tableView endRefreshing];
        [self.tableView reloadData];
        [self.tableView hiddenFooter:self.tableView.contentSize.height<self.tableView.height];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self.tableView endFooterRefreshing];
    }];
}

- (void)rightAction {
    if (self.selectedScenes.count==0) {
        [LKUtils showMessage:@"请选择景点"];
        return;
    }
    if (self.finishedSelectedBlock) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.selectedScenes.count];
        for (LKSceneListModel *model in self.selectedScenes) {
            [temp addObject:[model modelToJSONObject]];
        }
        self.finishedSelectedBlock([NSArray arrayWithArray:temp],self.point_type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKSceneListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    LKSceneListModel *model = [self.dataLists objectAt:indexPath.row];
    cell.model = model;
     @weakify(self);
    cell.selectSceneBlock = ^(LKSceneListModel *listModel) {
        @strongify(self);
        if (listModel.selectedState) {
            [self.selectedScenes addObject:listModel];
        } else {
            [self.selectedScenes removeObject:listModel];
        }
        [self updateBtnState];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKSceneDetailViewController *vc = [[LKSceneDetailViewController alloc] init];
    LKSceneListModel *model = [self.dataLists objectAt:indexPath.row];
    vc.scene_no = model.codDestinationPointNo;
    vc.is_choose = YES;
     @weakify(self);
    vc.finishedSelectedBlock = ^(NSDictionary *dict) {
        @strongify(self);;
        if (![self.selectedScenes containsObject:model]) {
            model.selectedState = YES;
            [self.selectedScenes addObject:model];
            [self.tableView reloadData];
        }
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateBtnState {
    if (self.selectedScenes.count) {
        [self.rightBtn setTitleColor:kColorYellow1 forState:UIControlStateNormal];
    } else {
        [self.rightBtn setTitleColor:kColorGray2 forState:UIControlStateNormal];
    }
}

@end
