//
//  LKSettingViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSettingViewController.h"
#import "LKSettingServer.h"
#import "LKSettingCell.h"

#import "LKAboutViewController.h"
#import "LKFeedbackViewController.h"

@interface LKSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LKSettingServer *server;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *datalists;
@property (nonatomic,strong) UIButton *logoutBut;
@end

@implementation LKSettingViewController

- (LKSettingServer *)server{
    if (!_server) {
        _server = [[LKSettingServer alloc] init];
    }
    return _server;
}

- (UITableView *)tableview{
    if (!_tableview) {
        CGRect rect = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight - self.logoutBut.height);
        _tableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [UIView new];
        [_tableview registerClass:[LKSettingCell class] forCellReuseIdentifier:kLKSettingCellIdentify];
    }
    return _tableview;
}

- (UIButton *)logoutBut{
    if (!_logoutBut) {
        _logoutBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBut.frame = CGRectMake(0, 0, kScreenWidth, 60);
        _logoutBut.bottom = kScreenHeight - kNavigationHeight;
        _logoutBut.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _logoutBut.titleLabel.font = kFont(16);
        [_logoutBut setTitle:@"退出账号" forState:UIControlStateNormal];
        [_logoutBut setTitleColor:[UIColor colorWithHexString:@"#ff584f"] forState:UIControlStateNormal];
        [_logoutBut addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBut;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:LKLocalizedString(@"LKSetting_title")];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.logoutBut];
    [self refreshData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSArray *sections = [NSArray getArray:self.datalists];
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = [self.datalists objectAt:section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSettingCellIdentify forIndexPath:indexPath];
    
    NSArray *sections = [self.datalists objectAt:indexPath.section];
    LKSettingRowModel *item = [sections objectAt:indexPath.row];

    [cell configData:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sections = [self.datalists objectAt:indexPath.section];
    LKSettingRowModel *item = [sections objectAt:indexPath.row];
    return [LKSettingCell getCellHeight:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *sections = [self.datalists objectAt:indexPath.section];
    LKSettingRowModel *item = [sections objectAt:indexPath.row];
    [self selectedItemAction:item];
}

///选择某一行的事件处理
- (void)selectedItemAction:(LKSettingRowModel *)item{
    LKSettingRowType rowType = item.rowType;
    switch (rowType) {
        case LKSettingRowType_about:
        {
            [LKMediator pushViewController:[LKAboutViewController new] animated:YES];
        }
            break;
        case LKSettingRowType_feedback:
        {
            [LKMediator pushViewController:[LKFeedbackViewController new] animated:YES];

        }
            break;
        case LKSettingRowType_support:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1144816653?mt=8"]];
        }
            break;
        case LKSettingRowType_share:
        {
            [LKMediator openShare:nil];
        }
            break;
        case LKSettingRowType_nocation:
        {
            
        }
            break;
        case LKSettingRowType_switchLanguage:
        {
            [UIActionSheet showButtonsWithTitle:nil buttons:@[@"简体中文",@"English"] handler:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                NSString *language = @"";
                if (buttonIndex==0) {//中文
                    language = kChinese;
                }
                if (buttonIndex==1) {//英文
                    language = kEnglish;
                }
                
                if (language.length>0 && ![[LKUserDefault objectForKey:kLanguageKey] isEqualToString:language]) {
                    [LKMediator changeLanguage:language];
                }
            }];
        }
            break;
        case LKSettingRowType_clearCache:
        {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self.tableview reloadData];
            }];
        }
            break;
    }

}

- (void)logoutAction{
    
}


- (void)refreshData{
    self.datalists = [NSArray getArray:self.server.model.sections];
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
