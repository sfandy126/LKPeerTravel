//
//  LKHomeMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeMainView.h"
#import "LKHomeHelperCell.h"
#import "LKHomeHotCityCell.h"
#import "LKHomeHotGuideCell.h"
#import "LKHomeHeaderView.h"

@interface LKHomeMainView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *datalists;
@property (nonatomic,strong) LKHomeHeaderView *headerView;
@end

@implementation LKHomeMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableview];
        self.tableview.tableHeaderView = self.headerView;
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
        
        [_tableview registerClass:[LKBaseCell class] forCellReuseIdentifier:kOtherCellIdentify];
        [_tableview registerClass:[LKHomeHelperCell class] forCellReuseIdentifier:kHomeHelperCellIdentify];
        [_tableview registerClass:[LKHomeHotCityCell class] forCellReuseIdentifier:kHomeHotCityCellIdentify];
        [_tableview registerClass:[LKHomeHotGuideCell class] forCellReuseIdentifier:kHomeHotGuideCellIdentify];
        
    }
    return _tableview;
}

- (LKHomeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LKHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 230.0)];
    }
    return _headerView;
}

#pragma mark - - UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datalists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LKHomeCellType cellType = [self.server getHomeCellType:section];
    if (cellType == LKHomeCellType_hotGuide) {
        return self.server.model.hotGuides.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKHomeCellType cellType = [self.server getHomeCellType:indexPath.section];
    //私人助手
    if (cellType == LKHomeCellType_helper) {
        LKHomeHelperCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeHelperCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model.helpers];
        @weakify(self);
        cell.batchButBlock = ^{
             @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedChangeBatch)]) {
                [self.delegate didClickedChangeBatch];
            }
        };
        cell.clickGuideBlock = ^(NSString *uid) {
//            @strongify(self);
            //进入导游客态主页
            [LKMediator openUserDetail:uid];
        };
        return cell;
    }
    
    //热门城市
    if (cellType == LKHomeCellType_hotCity) {
        LKHomeHotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeHotCityCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model.hotCitys];
        @weakify(self);
        cell.moreButBlock = ^{
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSeeMore)]) {
                [self.delegate didClickSeeMore];
            }
        };
        cell.selectedBlock = ^(LKHomeHotCityModel *item) {
            @strongify(self);
            if (self.delegate  && [self.delegate respondsToSelector:@selector(didSelectedItem:indexPath:)]) {
                [self.delegate didSelectedItem:item indexPath:indexPath];
            }
        };
        return cell;
    }
    
    //热门导游
    if (cellType == LKHomeCellType_hotGuide) {
        LKHomeHotGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeHotGuideCellIdentify forIndexPath:indexPath];
        LKHomeGuideModel *item = [self.server.model.hotGuides objectAt:indexPath.row];
        [cell configData:item];
        return cell;
    }
    
    //无指定类型时。
    LKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtherCellIdentify forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKHomeCellType cellType = [self.server getHomeCellType:indexPath.section];
    if (cellType == LKHomeCellType_helper) {
       return [LKHomeHelperCell getCellHeight:nil];
    }
    if (cellType == LKHomeCellType_hotCity) {
       return [LKHomeHotCityCell getCellHeight:nil];
    }
    if (cellType == LKHomeCellType_hotGuide) {
        LKHomeGuideModel *item = [self.server.model.hotGuides objectAt:indexPath.row];
       return [LKHomeHotGuideCell getCellHeight:item];
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    LKHomeCellType cellType = [self.server getHomeCellType:section];
    if (cellType == LKHomeCellType_hotGuide) {
        return 45.0;
    }
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LKHomeCellType cellType = [self.server getHomeCellType:section];
    if (cellType == LKHomeCellType_hotGuide) {
        LKHomeHotGuideSection *sectionView = [[LKHomeHotGuideSection alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45.0)];
        sectionView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        sectionView.city_name = self.server.selected_city_name;
        sectionView.selectedLoctionBlock = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedChangeCity)]) {
                [self.delegate didClickedChangeCity];
            }
        };
        return sectionView;
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    LKHomeCellType cellType = [self.server getHomeCellType:section];
    if (cellType == LKHomeCellType_hotCity) {
        return 10.0;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LKHomeCellType cellType = [self.server getHomeCellType:section];
    if (cellType == LKHomeCellType_hotCity) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LKHomeCellType cellType = [self.server getHomeCellType:indexPath.section];
    if (cellType == LKHomeCellType_hotGuide) {
        LKHomeGuideModel *item = [self.server.model.hotGuides objectAt:indexPath.row];
        //进入导游客态个人主页
        [LKMediator openUserDetail:item.uid];
    }
}

#pragma mark - - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.isScrolling = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewScrollContentOffsetY:)]) {
        [self.delegate mainViewScrollContentOffsetY:scrollView.contentOffset.y];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isScrolling = NO;
}

- (void)endRefresh{
    [self.tableview endRefreshing];
}

- (void)doneLoading{
    self.datalists = @[@(LKHomeCellType_helper),@(LKHomeCellType_hotCity),@(LKHomeCellType_hotCity)];
    [self.headerView configData:self.server.model.banners];
    
    
    [self.tableview noticeNoMoreData];

    [self.tableview reloadData];
}


@end
