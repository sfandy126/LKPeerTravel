//
//  LKCenterMainView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterMainView.h"

#import "LKCenterHeaderView.h"

#import "LKCenterSectionCell.h"


@interface LKCenterMainView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) LKCenterHeaderView *tableHeaderView;

@end

@implementation LKCenterMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
        self.tableview.tableHeaderView = self.tableHeaderView;
        @weakify(self);
        self.tableHeaderView.selectedOrderBlock = ^(NSInteger index) {
            @strongify(self);
            [self.server pushViewCtronllerWithOrderIndex:index];
        };
    }
    return self;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[LKCenterSectionCell class] forCellReuseIdentifier:LKCenterSectionCellReuseIndentifier];
        
    }
    return _tableview;
}

- (LKCenterHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[LKCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    }
    return _tableHeaderView;
}

- (void)setModel:(LKCenterModel *)model {
    _model = model;
    
    [_tableview reloadData];
}

- (void)doneLoading {
    _tableHeaderView.model = self.model;
    [_tableview reloadData];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _model.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKCenterSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:LKCenterSectionCellReuseIndentifier forIndexPath:indexPath];
    LKCenterSectionModel *model = [_model.sections objectAt:indexPath.section];
    cell.sectionModel = model;
    cell.section = indexPath.section;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKCenterSectionModel *model = [_model.sections objectAt:indexPath.section];
    return model.rows.count*50+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewScrollContentOffsetY:)]) {
        [self.delegate mainViewScrollContentOffsetY:scrollView.contentOffset.y];
    }
}

@end
