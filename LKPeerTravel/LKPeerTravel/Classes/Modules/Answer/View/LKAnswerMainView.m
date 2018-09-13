//
//  LKAnswerMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerMainView.h"
#import "LKAnswerHotCell.h"
#import "LKAnswerNewestCell.h"
#import "LKAnswerSectionView.h"

#import "LKAnswerDetailViewController.h"

@interface LKAnswerMainView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LKAnswerMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableview];
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
        [_tableview hiddenFooter:YES];
        
        [_tableview registerClass:[LKBaseCell class] forCellReuseIdentifier:kOtherCellIdentify];
        [_tableview registerClass:[LKAnswerHotCell class] forCellReuseIdentifier:kAnswerHotCellIdentify];
        [_tableview registerClass:[LKAnswerNewestCell class] forCellReuseIdentifier:kAnswerNewestCellIdentify];
        
    }
    return _tableview;
}

#pragma mark - - UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return self.server.model.lastestList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //热门
    if (indexPath.section==0) {
        LKAnswerHotCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnswerHotCellIdentify forIndexPath:indexPath];
        [cell configData:[self.server.model.hotLists copy]];
        cell.selectedBlock = ^(LKAnswerSingleModel *item) {
            [self openAnswerDetail:item];
        };
        return cell;
    }
    
    //最新
    if (indexPath.section==1) {
        LKAnswerNewestCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnswerNewestCellIdentify forIndexPath:indexPath];
        LKAnswerSingleModel *item = [self.server.model.lastestList objectAt:indexPath.row];
        [cell configData:item];
        return cell;
    }
    
    //无指定类型时。
    LKBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kOtherCellIdentify forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [LKAnswerHotCell getCellHeight:nil];
    }
    if (indexPath.section==1) {
        LKAnswerSingleModel *item = [self.server.model.lastestList objectAt:indexPath.row];
        return [LKAnswerNewestCell getCellHeight:item];
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LKAnswerSectionView *sectionView = [[LKAnswerSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) withTitle:(section==0?@"热门回答":@"最新") isHot:section==0];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    sectionView.moreButBlock = ^(BOOL isHot) {
        [LKMediator openAnswerList:isHot?@"2":@"1"];
    };
    return sectionView;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LKAnswerSingleModel *item = [self.server.model.lastestList objectAt:indexPath.row];

    if (indexPath.section==1) {
        [self openAnswerDetail:item];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

///打开问答详情
- (void)openAnswerDetail:(LKAnswerSingleModel *)item{
    LKAnswerDetailViewController *vc = [[LKAnswerDetailViewController alloc] init];
    vc.answerModel = item;
    [LKMediator pushViewController:vc animated:YES];
}

- (void)doneLoading{
    [self.tableview endRefreshing];
    [self.tableview reloadData];
    
    if (self.server.model.isLastPage) {
        [self.tableview noticeNoMoreData];
    }else{
        [self.tableview resetNoMoreData];
    }
}



@end
