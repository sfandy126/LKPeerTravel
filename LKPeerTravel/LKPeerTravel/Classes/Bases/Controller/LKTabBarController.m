//
//  LKTabBarController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTabBarController.h"
#import "LKHomeViewController.h"
#import "LKCenterViewController.h"
#import "LKAnswerViewController.h"
#import "LKTrackViewController.h"

#import "LKWishEditViewController.h"
#import "LKSendTrackViewController.h"

#import "LKCustomTabBar.h"

#import "LKSendTrackMaskView.h"

@interface LKTabBarController ()

@property (nonatomic, strong) LKCustomTabBar *customTabbar;
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@property (nonatomic, strong) LKSendTrackMaskView *sendTrackMaskView;
@end

@implementation LKTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    LKNavigationViewController *home = [self createNavigationViewCtronller:[LKHomeViewController class]];
    LKNavigationViewController *track =[self createNavigationViewCtronller:[LKTrackViewController class]];

    LKNavigationViewController *navi3 = [self createNavigationViewCtronller:[UIViewController class]];
    LKNavigationViewController *answer = [self createNavigationViewCtronller:[LKAnswerViewController class]];
    LKNavigationViewController *center = [self createNavigationViewCtronller:[LKCenterViewController class]];

    LKUserType userType = [LKUserInfoUtils getUserType];
    if (userType==LKUserType_Guide) {
        self.viewControllers = @[track,answer,center];
    } else {
        self.viewControllers = @[home,track,navi3,answer,center];
    }
    self.selectedIndex = 0;
    
    
    NSInteger selectIndex = 0;
    
    self.lastSelectedIndex = selectIndex;
    
    [self customSelected];
    [self setTabSelectedIndex:selectIndex];
}

- (void)customSelected {
    if (self.customTabbar.superview) {
        [self.customTabbar updateTabBarFrame:self.tabBar.bounds];
        [self.tabBar bringSubviewToFront:self.customTabbar];
        return;
    }
    // 自定义 tabbar， 并设置相关属性
    self.customTabbar = [[LKCustomTabBar alloc] initWithFrame:self.tabBar.bounds];
    
    NSArray *itemtitles;
    NSArray *itemNormalIcons;
    NSArray *itemSelectedIcons;
    
    LKUserType userType = [LKUserInfoUtils getUserType];
    if (userType==LKUserType_Guide) {
        itemtitles = @[LKLocalizedString(@"LKTabbar_title_track"),LKLocalizedString(@"LKTabbar_title_anwser"),LKLocalizedString(@"LKTabbar_title_mine")];
        itemNormalIcons = @[@"btn_table_foot_none",
                            @"btn_table_answer_none",
                            @"btn_table_my_none",];
        itemSelectedIcons = @[@"btn_table_foot_pressed",
                               @"btn_table_answer_pressed",
                               @"btn_table_my_pressed",];
    } else {
        itemtitles =  @[LKLocalizedString(@"LKTabbar_title_home"),LKLocalizedString(@"LKTabbar_title_track"),@"",LKLocalizedString(@"LKTabbar_title_anwser"),LKLocalizedString(@"LKTabbar_title_mine")];
        itemNormalIcons = @[
                            @"btn_table_home_none",
                            @"btn_table_foot_none",
                            @"btn_table_publish_none",
                            @"btn_table_answer_none",
                            @"btn_table_my_none",
                            ];
        itemSelectedIcons = @[@"btn_table_home_pressed",
                              @"btn_table_foot_pressed",
                              @"btn_table_publish_pressed",
                              @"btn_table_answer_pressed",
                              @"btn_table_my_pressed",
                              ];
    }
    
    self.customTabbar.itemTitles = itemtitles;
    self.customTabbar.itemNormalIcons = itemNormalIcons;
    self.customTabbar.itemSelectedIcons = itemSelectedIcons;
    
    self.customTabbar.itemNormalTitleColor = [UIColor lightGrayColor];
    self.customTabbar.itemSelectedTitleColor = [UIColor blackColor];
    
    @weakify(self);
    self.customTabbar.onSelected = ^(NSInteger index) {
        @strongify(self);
        [self setTabSelectedIndex:index];
        self.lastSelectedIndex = index;
    };
    self.customTabbar.centerButBlock = ^{
        @strongify(self);
        NSLog(@"点击了中间按钮");
        [self.sendTrackMaskView show];
        self.sendTrackMaskView.selectedBlock = ^(NSInteger index) {
            @strongify(self);
            if (index==0) {///发布心愿单
                LKNavigationViewController *navi = [self createNavigationViewCtronller:[LKWishEditViewController class]];
                [self presentViewController:navi animated:YES completion:nil];
            }else{//发布足迹
                LKNavigationViewController *navi = [self createNavigationViewCtronller:[LKSendTrackViewController class]];
                [self presentViewController:navi animated:YES completion:nil];
            }
   
        };
    };
    
    [self.customTabbar setUpTabBar];
    self.tabBar.backgroundColor = [UIColor clearColor];
    //添加自定义tabBar
    [self.tabBar addSubview:self.customTabbar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    for (UIView *view in self.tabBar.subviews) {
        if (![view isKindOfClass:[LKCustomTabBar class]]) {
            view.hidden = YES;
        } else {
            [self.customTabbar hiddenSubViews];
        }
    }
}

- (void)setTabSelectedIndex:(NSUInteger)selectedIndex {
  
    if (self.viewControllers.count > selectedIndex) {
        [self setSelectedIndex:selectedIndex];
        [self.customTabbar selectedAtIndex:selectedIndex];
    }
}

- (LKNavigationViewController *)createNavigationViewCtronller:(Class )controllerClass{
    LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:[[controllerClass alloc] init]];
    return navi;
}

- (LKSendTrackMaskView *)sendTrackMaskView{
    if (!_sendTrackMaskView) {
        _sendTrackMaskView = [[LKSendTrackMaskView alloc] init];
    }
    return _sendTrackMaskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
