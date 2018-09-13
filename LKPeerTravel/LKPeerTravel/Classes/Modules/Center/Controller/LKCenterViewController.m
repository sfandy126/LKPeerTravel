//
//  LKCenterViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterViewController.h"

#import "LKCenterMainView.h"
#import "LKNavigationBar.h"

#import "LKCenterServer.h"
#import "LKSettingViewController.h"
#import "UIViewController+LKStatusBarStyle.h"

@interface LKCenterViewController () <LKCenterMainViewDelegate>

@property (nonatomic, strong) LKCenterMainView *mainView;
@property (nonatomic, strong) LKCenterServer *server;
@property (nonatomic, strong) LKNavigationBar *navigationBar;

@end

@implementation LKCenterViewController



- (LKCenterMainView *)mainView {
    if (_mainView==nil) {
        _mainView = [[LKCenterMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight)];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (LKNavigationBar *)navigationBar {
    if (_navigationBar==nil) {
        _navigationBar = [[LKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    }
    return _navigationBar;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];

    [self.navigationBar setTitle:LKLocalizedString(@"LKTabbar_title_mine")];
    [self.navigationBar setRightItemImage:@"btn_my_set_gray_none" target:self action:@selector(enterSetting)];
    [self.navigationBar updataNavigationAlpha:0];
    [self.navigationBar setTitleHidden:YES];
    
    
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.navigationBar];
 
    self.server = [[LKCenterServer alloc] init];
    self.mainView.server = self.server;
    self.mainView.model = self.server.centerModel;
    
    self.LK_lightStatusBar = YES;
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadData];
}


- (void)loadData {
     @weakify(self);
    [self.server obtainUserDataFinished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        [self.mainView doneLoading];
    } failed:^(LKBaseModel *item, NSError *error) {
        
    }];
}

- (void)enterSetting {
    LKSettingViewController *ctl = [[LKSettingViewController alloc] init];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark -- LKCenterMainViewDelegate

- (void)mainViewScrollContentOffsetY:(CGFloat)offsetY {
     @weakify(self);
    [self.navigationBar setOffsetY:offsetY alphaBlock:^(CGFloat alpha) {
        @strongify(self);
        [self.navigationBar setTitleHidden:alpha<0.1];
        if (alpha<0.1) {
            self.LK_lightStatusBar = YES;
        } else {
            self.LK_lightStatusBar = NO;
        }
//        self.LK_lightStatusBar = alpha<0.1;
    }];
}


@end
