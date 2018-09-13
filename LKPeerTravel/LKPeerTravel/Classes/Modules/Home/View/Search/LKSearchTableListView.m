//
//  LKSearchTableListView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSearchTableListView.h"
#import "LKSearchGuideCell.h"
#import "LKSearchTrackCell.h"
#import "LKSearchAnswerCell.h"

@interface LKSearchTableListView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray *datalists;
@end


@implementation LKSearchTableListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        @weakify(self);
        [self.tableView addLegendHeaderRefreshBlock:^{
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataIsMore:)]) {
                [self.delegate loadDataIsMore:NO];
            }
        }];
        [self.tableView addLegendFooterRefreshBlock:^{
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataIsMore:)]) {
                [self.delegate loadDataIsMore:YES];
            }
        }];
        
        [self.tableView hiddenFooter:YES];
    }

    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[LKSearchGuideCell class] forCellReuseIdentifier:kLKSearchGuideCellIdentify];
        [_tableView registerClass:[LKSearchTrackCell class] forCellReuseIdentifier:kLKSearchTrackCellIdentify];
        [_tableView registerClass:[LKSearchAnswerCell class] forCellReuseIdentifier:kLKSearchAnswerCellIdentify];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datalists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self.datalists objectAt:indexPath.section];
    if (item && [item isKindOfClass:[LKSearchGuideModel class]]) {
        LKSearchGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSearchGuideCellIdentify forIndexPath:indexPath];
        [cell configData:item];
        return cell;
    }
  
    if (item && [item isKindOfClass:[LKSearchTrackModel class]]) {
        LKSearchTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSearchTrackCellIdentify forIndexPath:indexPath];
        [cell configData:item];
        return cell;
    }

    if (item && [item isKindOfClass:[LKSearchAnswerModel class]]) {
        LKSearchAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSearchAnswerCellIdentify forIndexPath:indexPath];
        [cell configData:item];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self.datalists objectAt:indexPath.section];
    if (item && [item isKindOfClass:[LKSearchGuideModel class]]) {
        return [LKSearchGuideCell getCellHeight:item];
    }
    
    if (item && [item isKindOfClass:[LKSearchTrackModel class]]) {
        return [LKSearchTrackCell getCellHeight:item];
    }
    
    if (item && [item isKindOfClass:[LKSearchAnswerModel class]]) {
        return [LKSearchAnswerCell getCellHeight:item];
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id item = [self.datalists objectAt:indexPath.section];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItem:indexPath:)]) {
        [self.delegate didSelectedItem:item indexPath:indexPath];
    }
}

- (void)configData:(LKSearchListModel *)listModel{
    self.datalists = [NSArray getArray:listModel.datalists];
    [self.tableView endRefreshing];
    [self.tableView reloadData];
    [self.tableView setNoticeNoMoreData:listModel.isLastPage];
    [self.tableView hiddenFooter:(self.datalists.count==0 || self.tableView.contentSize.height <self.tableView.height)];
}


@end
