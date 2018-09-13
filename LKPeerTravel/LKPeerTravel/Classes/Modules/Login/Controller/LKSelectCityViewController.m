//
//  LKSelectCityViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/8.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSelectCityViewController.h"
#import "LKSelectCityMainView.h"
#import "LKSelectedCityServer.h"

@interface LKSelectCityViewController ()
@property (nonatomic,strong) LKSelectCityMainView *mainView;
@property (nonatomic,strong) LKSelectedCityServer *server;

@end

@implementation LKSelectCityViewController

- (LKSelectCityMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKSelectCityMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) isChoose:self.isChoose];
    }
    return _mainView;
}

- (LKSelectedCityServer *)server{
    if (!_server) {
        _server = [[LKSelectedCityServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainView.server = self.server;
    [self.view addSubview:self.mainView];
    
    [self.mainView refreshData];

     @weakify(self);
    [self.mainView setSureBlock:^(NSString *city_id,NSString *title) {
        @strongify(self);
        if (self.isChoose) {
            if (self.selectCityBlock) {
                self.selectCityBlock(city_id,title);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self saveSelectedCity:city_id];
            [LKMediator openTabBar];
        }
     
    }];
    
    [self.mainView setSkipBlock:^{
        @strongify(self);
        if (self.isChoose) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [LKMediator openTabBar];
        }

    }];
    
    [self.mainView setSearchBlock:^(NSString *city_name) {
        @strongify(self);
        [self loadCityListName:city_name];
    }];
    // 拉取热门城市数据
    [self loadCityListName:@""];
}

- (void)loadCityListName:(NSString *)name {
     @weakify(self);
    [self.server loadCityListWithName:name successedBlock:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        [self.mainView refreshData];
    } failedBlock:^(LKBaseModel *item, NSError *error) {

    }];
}

- (void)saveSelectedCity:(NSString *)city_id{
    [self.server saveSelectedCityWithParams:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"city":city_id} finishedBlock:^(LKBaseModel *item, LKResult *response) {
        
    } failedBlock:^(LKBaseModel *item, NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
