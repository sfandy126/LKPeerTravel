//
//  LKPersonInfoViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPersonInfoViewController.h"
#import "LKPersonInfoMainView.h"

@interface LKPersonInfoViewController ()
@property (nonatomic,strong) LKPersonInfoMainView *mainView;
@property (nonatomic,strong) LKPersonInfoServer *server;

@end

@implementation LKPersonInfoViewController

- (LKPersonInfoMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKPersonInfoMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight)];
    }
    return _mainView;
}

- (LKPersonInfoServer *)server{
    if (!_server) {
        _server = [[LKPersonInfoServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    [self.navigationItem setTitle:@"个人资料"];
    self.mainView.server = self.server;
    [self.view addSubview:self.mainView];
    
    if (self.model) {
        self.mainView.model = self.model;
        
        [self.mainView doneLoading];
    } else {
        [LKHttpClient POST:@"tx/cif/customer/page" parameters:@{@"customerNumber":[LKUserInfoUtils getUserNumber]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            LKResult *result = [[LKResult alloc] initWithDict:responseObject];
            if (result.success) {
                self.model = [LKCenterModel modelWithDictionary:result.data[@"data"]];
                self.mainView.model = self.model;
                
                [self.mainView doneLoading];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
