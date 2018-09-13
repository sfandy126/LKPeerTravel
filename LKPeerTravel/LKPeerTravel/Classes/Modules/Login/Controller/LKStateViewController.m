//
//  LKStateViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKStateViewController.h"
#import "LKStateMainView.h"
#import "LKSelectCityViewController.h"

@interface LKStateViewController ()
@property (nonatomic,strong) LKStateMainView *mainView;
@end

@implementation LKStateViewController

- (LKStateMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKStateMainView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self.view addSubview:self.mainView];
    
    @weakify(self);
    self.mainView.nextBlock = ^(LKUserType userType) {
        @strongify(self);
        [self selectUserType:userType];
    };

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)selectUserType:(LKUserType)userType {
     @weakify(self);
    NSString *customerNumber = [NSString stringValue:[LKUserInfoUtils getUserNumber]];
    
    [LKHttpClient POST:@"tx/cif/customer/set/user/type" parameters:@{@"userType":@(userType),@"customerNumber":customerNumber} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [LKUserInfoUtils setUserType:userType];
        LKSelectCityViewController *ctl = [[LKSelectCityViewController alloc] init];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
