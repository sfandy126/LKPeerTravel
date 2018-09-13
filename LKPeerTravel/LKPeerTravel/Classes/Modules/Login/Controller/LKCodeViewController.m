//
//  LKCodeViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCodeViewController.h"
#import "LKCodeMainView.h"
#import "LKStateViewController.h"

@interface LKCodeViewController ()
@property (nonatomic,strong) LKCodeMainView *mainView;
@end

@implementation LKCodeViewController

- (LKCodeMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKCodeMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        @weakify(self);
        _mainView.sureBlock = ^(NSString *code) {
            @strongify(self);
            [self sureWithCode:code];
        };
        _mainView.skipBlock = ^{
            @strongify(self);
            LKStateViewController *ctl = [[LKStateViewController alloc] init];
            ctl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ctl animated:YES];
        };
    }
    return _mainView;
}

- (void)sureWithCode:(NSString *)code {
    @weakify(self);
    NSString *customerNumber = [NSString stringValue:[LKUserInfoUtils getUserNumber]];
    
    [LKHttpClient POST:@"tx/cif/customer/fill/invitation-code" parameters:@{@"codPrsCode":code,@"customerNumber":customerNumber} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        LKStateViewController *ctl = [[LKStateViewController alloc] init];
        ctl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];

    [self.view addSubview:self.mainView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
