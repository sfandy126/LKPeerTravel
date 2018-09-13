//
//  LKTrackDetailMainView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailMainView.h"
#import "LKTrackDetailHeaderView.h"
#import "LKBottomToolView.h"
#import "LKTrackDetailCell.h"
#import "LKTrackDetailCommentCell.h"
#import "LKTrackDetailSectionView.h"

@interface LKTrackDetailMainView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LKTrackDetailHeaderView *headerView;
@property (nonatomic,strong) LKBottomToolView *bottomToolView;
@property (nonatomic,strong) LKTrackDetailSectionView *sectionView;
@end

@implementation LKTrackDetailMainView


- (LKBottomToolView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[LKBottomToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        _bottomToolView.style = LKBottomToolViewStyle_white;
        _bottomToolView.backgroundColor = [UIColor whiteColor];
        _bottomToolView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bottomToolView.layer.shadowOffset = CGSizeMake(5, 5);
        _bottomToolView.layer.shadowOpacity = 0.8;
    }
    return _bottomToolView;
}

- (LKTrackDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LKTrackDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, 240)];
        _headerView.clickedHeaderBlock = ^(LKTrackInfoModel *model) {
            [LKMediator openImageBrowse:@{@"images":[NSArray getArray:model.city_icons],@"foot_id":[NSString stringValue:model.footprintNo],@"content":[NSString stringValue:model.content]}];
        };
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.bottomToolView.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[LKTrackDetailCell class] forCellReuseIdentifier:kLKTrackDetailCellIdentify];
        [_tableView registerClass:[LKTrackDetailCommentCell class] forCellReuseIdentifier:kLKTrackDetailCommentCellIdentify];
        
    }
    return _tableView;
}

- (LKTrackDetailSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[LKTrackDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    }
    return _sectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView.tableHeaderView = self.headerView;
        [self addSubview:self.tableView];
        
        [self addSubview:self.bottomToolView];
        @weakify(self);
        self.bottomToolView.clickedBlcok = ^(LKBottomToolViewType type) {
            @strongify(self);
            if (type == LKBottomToolViewType_back) {
                [self.vc.navigationController popViewControllerAnimated:YES];
            }
            if (type == LKBottomToolViewType_comment) {
                [self editContent];
            }
        };
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.server.model.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        LKTrackDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKTrackDetailCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model.infoModel];
        return cell;
    }
    if (indexPath.section==1) {
        LKTrackDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKTrackDetailCommentCellIdentify forIndexPath:indexPath];
        LKTrackCommentModel *item = [self.server.model.comments objectAt:indexPath.row];
        [cell configData:item indexPath:indexPath];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [LKTrackDetailCell getCellHeight:self.server.model.infoModel];
    }
    
    if (indexPath.section==1) {
        LKTrackCommentModel *item = [self.server.model.comments objectAt:indexPath.row];
        return [LKTrackDetailCommentCell getCellHeight:item indexPath:indexPath];
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return self.sectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return self.sectionView.height;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 17;
    }
    return CGFLOAT_MIN;
}

- (void)editContent{
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_desc title:@"我要评论"];
    @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        if (self.addCommentBlock) {
            self.addCommentBlock(inputStr);
        }
    };
 
    [self.vc presentViewController:vc animated:YES completion:nil];
}


- (void)doneLoading{
    [self.headerView configData:self.server.model.infoModel];
    [self.sectionView configData:self.server.model];
    [self.tableView endRefreshing];
    [self.tableView reloadData];
}


@end
