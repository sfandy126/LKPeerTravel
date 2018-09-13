//
//  LKOrderMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderMainView.h"
#import "LKSegmentView.h"
#import "LKOrderListCell.h"

#import "LKOderDetailViewController.h"

@interface LKOrderMainView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LKSegmentView *segment;
@property (nonatomic,strong) NSArray *datalists;

@end

@implementation LKOrderMainView

- (void)setServer:(LKOrderServer *)server{
    _server = server;
    
    NSInteger index = 0;

    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        if (self.server.clickIndex==0||self.server.clickIndex==1) {
            index = 0;
        } else {
            index = self.server.clickIndex-1;
        }
    } else {
        index = self.server.clickIndex;
    }
    [self.segment setSelectedCurrentIndex:index];
//    [self.segment setSelectedCurrentIndex:server.orderType-1];
}

- (LKSegmentView *)segment{
    if (!_segment) {
        _segment = [[LKSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.width, 33)];
        _segment.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _segment.selectdTitleFont = [UIFont boldSystemFontOfSize:12.0];
        _segment.selectdTitleColor = [UIColor colorWithHexString:@"#333333"];
        _segment.unSelectdTitleFont = [UIFont systemFontOfSize:12.0];
        _segment.unSelectdTitleColor = [UIColor colorWithHexString:@"#999999"];
        _segment.layoutStyle = LKSegmentLayoutStyle_center;
        _segment.paddingEdgeInsets = UIEdgeInsetsZero;
        _segment.proccessHeight = 5.0;
        
        if ([LKUserInfoUtils getUserType] == LKUserType_Guide) {
            _segment.titles = @[@"待服务",@"已服务",@"已取消"];
        } else {
            _segment.titles = @[@"待支付",@"已支付",@"已完成",@"已取消"];
        }
    }
    return _segment;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0) style:UITableViewStyleGrouped];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [UIView new];
        [_tableview registerClass:[LKOrderListCell class] forCellReuseIdentifier:kLKOrderListCellIdentify];
    }
    return _tableview;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.segment showSegment];
    [self addSubview:self.segment];
    
    self.tableview.top = self.segment.bottom;
    self.tableview.height = self.height - self.segment.bottom;
    [self addSubview:self.tableview];
    
    @weakify(self);
    self.segment.selectedBlock = ^(NSInteger index) {
        @strongify(self);
        self.server.orderType = index+1;
        if (LKUserType_Guide==[LKUserInfoUtils getUserType]) {
            self.server.clickIndex = index+1;
        } else {
            self.server.clickIndex = index;
        }
        if (self.switchSegmentBlock) {
            self.switchSegmentBlock(index+1);
        }
    };
}

#pragma mark - - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datalists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKOrderListCellIdentify forIndexPath:indexPath];
    LKOrderListModel *item = [self.datalists objectAt:indexPath.section];
    [cell configData:item];
    
    cell.clickedStateHandleBlock = ^(LKOrderListModel *item, LKOrderHandleType handleType) {
        [self updateOrderState:item handleType:handleType];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKOrderListModel *item = [self.datalists objectAt:indexPath.section];
    return [LKOrderListCell getCellHeight:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10.0;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKOrderListModel *item = [self.datalists objectAt:indexPath.section];
    [LKMediator openOrderDetail:item.order_id];
}

///更新订单状态
- (void)updateOrderState:(LKOrderListModel *)item handleType:(LKOrderHandleType )handleType{
    if (handleType == LKOrderHandleType_cancel) {
        NSLog(@"取消订单");
        [self.server updateOrderStatusData:@{@"no":[NSString stringValue:item.order_id],@"status":@"-1"} finishedBlock:^(LKResult *item, BOOL isFinished) {
            [LKUtils showMessage:item.replyText];
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        } failedBlock:^(NSError *error) {
            [LKUtils showMessage:@"取消失败，请检查网络"];
        }];
    }
    if (handleType == LKOrderHandleType_pay) {
         NSLog(@"去支付");
        [self.server updateOrderStatusData:@{@"no":[NSString stringValue:item.order_id],@"status":@"3"} finishedBlock:^(LKResult *item, BOOL isFinished) {
            [LKUtils showMessage:item.replyText];
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        } failedBlock:^(NSError *error) {
            [LKUtils showMessage:@"取消失败，请检查网络"];
        }];
    }
    if (handleType == LKOrderHandleType_sure) {
        NSLog(@"确认订单");
        [self.server updateOrderStatusData:@{@"no":[NSString stringValue:item.order_id],@"status":@"4"} finishedBlock:^(LKResult *item, BOOL isFinished) {
            [LKUtils showMessage:item.replyText];
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        } failedBlock:^(NSError *error) {
            [LKUtils showMessage:@"确认订单失败，请检查网络"];
        }];
    }
    if (handleType==LKOrderHandleType_service) {
        NSLog(@"开始服务");
        [self.server updateOrderStatusData:@{@"no":[NSString stringValue:item.order_id],@"status":@"5"} finishedBlock:^(LKResult *item, BOOL isFinished) {
            [LKUtils showMessage:item.replyText];
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        } failedBlock:^(NSError *error) {
            [LKUtils showMessage:@"确认订单失败，请检查网络"];
        }];
    }
    
    if (handleType==LKOrderHandleType_complete) {
        NSLog(@"开始服务");
        [self.server updateOrderStatusData:@{@"no":[NSString stringValue:item.order_id],@"status":@"2"} finishedBlock:^(LKResult *item, BOOL isFinished) {
            [LKUtils showMessage:item.replyText];
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        } failedBlock:^(NSError *error) {
            [LKUtils showMessage:@"确认订单失败，请检查网络"];
        }];
    }
    if (handleType == LKOrderHandleType_evaluate) {
        NSLog(@"去评价");
        NSString *title = @"去回复";
        if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
            title = @"去评价";
        }
        
        LKOderDetailViewController *vc = [[LKOderDetailViewController alloc] init];
        vc.order_id = item.order_id;
        vc.shouldScrollBottom = YES;
        vc.handleBlock = ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        };
        [self.lk_viewController.navigationController pushViewController:vc animated:YES];

    }
    if (handleType == LKOrderHandleType_reservation) {
        NSLog(@"再次预定");
    }
}

- (void)evaluteWithInputStr:(NSString *)str item:(LKOrderListModel *)item {
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        [LKHttpClient POST:@"tx/cif/OmsOrderComment/save" parameters:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"level":@"1.0",@"orderNo":item.order_id,@"txtCommentContent":str} progress:^(NSProgress *progress) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                [self.delegate stateOperationFinished];
            }
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        LKPageInfo *page = [[LKPageInfo alloc] init];
        page.pageNum = 1;
        [LKHttpClient POST:@"tx/cif/OmsOrderComment/list" parameters:@{@"no":item.order_id,@"page":[page modelToJSONObject]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            LKResult *result = [[LKResult alloc] initWithDict:responseObject];
            if (result.success) {
                NSArray *lists = [NSArray getArray:result.data[@"dataList"]];
                NSDictionary *dict = [lists firstObject];
                for (NSDictionary *info in lists) {
                    if ([[NSString stringValue:info[@"orderNo"]] isEqualToString:item.order_id]) {
                        dict = info;
                        break;
                    }
                }
                if ([NSDictionary isNotEmptyDict:dict]) {
                    [LKHttpClient POST:@"tx/cif/OmsOrderComment/replay" parameters:@{@"commentNo":[NSString stringValue:dict[@"omsCommentNo"]],@"replayNumber":[NSString stringValue:[LKUserInfoUtils getUserNumber]],@"txtCommentContent":str} progress:^(NSProgress *progress) {
                        
                    } success:^(NSURLSessionDataTask *task, id responseObject) {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(stateOperationFinished)]) {
                            [self.delegate stateOperationFinished];
                        }
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)doneLoading{
    NSNumber *num = [self.server.orderIndexMap objectForKey:[NSString stringWithFormat:@"%zd",self.server.clickIndex]];
    LKOrderTypeModel *model = [self.server.typeModelMap objectForKey:[NSString stringWithFormat:@"%@",num]];
    if ([model isKindOfClass:LKOrderTypeModel.class]) {
        self.datalists = [NSArray getArray:model.listData];
    }
    [self.tableview endRefreshing];
    [self.tableview reloadData];
}

@end
