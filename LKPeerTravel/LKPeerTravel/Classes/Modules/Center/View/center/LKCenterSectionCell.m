//
//  LKCenterSectionCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterSectionCell.h"

#import "LKCenterRowCell.h"

#import "LKCenterModel.h"

#import "LKMyServerViewController.h"
#import "LKWishListViewController.h"
#import "LKCertifyShowViewController.h"
#import "LKTrackListViewController.h"
#import "LKAgreementViewController.h"

@interface LKCenterSectionCell () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *bgIV;

@end

@implementation LKCenterSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 背景图
    _bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, kScreenWidth-12, 160)];
    _bgIV.userInteractionEnabled = YES;
    _bgIV.image = [[UIImage imageNamed:@"img_block1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:_bgIV];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, _bgIV.width-10, _bgIV.height-10) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor hexColore6e6e6];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 64, 0, 0);
    [_tableView registerClass:[LKCenterRowCell class] forCellReuseIdentifier:LKCenterRowCellReuseIndentifier];
    [_bgIV addSubview:_tableView];

    _tableView.layer.cornerRadius = 10;
    _tableView.layer.masksToBounds = YES;
    
}

- (void)setSectionModel:(LKCenterSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    
    _bgIV.height = sectionModel.rows.count*50+10;
    _tableView.height = sectionModel.rows.count*50;
    [_tableView reloadData];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _sectionModel.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKCenterRowCell *cell = [tableView dequeueReusableCellWithIdentifier:LKCenterRowCellReuseIndentifier forIndexPath:indexPath];
    LKCenterRowModel *model = [_sectionModel.rows objectAt:indexPath.row];
    cell.rowModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKCenterRowModel *model = [_sectionModel.rows objectAt:indexPath.row];
    switch (model.rowType) {
            // 心愿单
        case LKCenterRowType_wish:
        {
            LKWishListViewController *vc = [[LKWishListViewController alloc] init];
            [LKMediator pushViewController:vc animated:YES];
        }
            break;
            // 服务协议
        case LKCenterRowType_serviceProtocol:
        {
            LKAgreementViewController *vc = [[LKAgreementViewController alloc] init];
            [LKMediator pushViewController:vc animated:YES];
        }
            break;
            // 邀请码
        case LKCenterRowType_inviteCode:
        {
            
        }
            break;
            // 邀请列表
        case LKCenterRowType_inviceList:
        {
            
        }
            break;
            // 我的游记
        case LKCenterRowType_myTravelList:
        {
            LKTrackListViewController *myTrackList = [[LKTrackListViewController alloc] init];
            [LKMediator pushViewController:myTrackList animated:YES];
        }
            break;
            // 我的回答
        case LKCenterRowType_myAnswer:
        {
            [LKMediator openAnswerList:@"isMine"];
        }
            break;
            // 认证
        case LKCenterRowType_certify:
        {
            LKCertifyShowViewController *vc = [[LKCertifyShowViewController alloc] init];
            if ([model.desc isEqualToString:@"未认证"]) {
                vc.isEdit = YES;
            }
            [LKMediator pushViewController:vc animated:YES];
        }
            break;
            // 我的服务
        case LKCenterRowType_myService:
        {
            LKMyServerViewController *ctl = [[LKMyServerViewController alloc] init];
            [LKMediator pushViewController:ctl animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
