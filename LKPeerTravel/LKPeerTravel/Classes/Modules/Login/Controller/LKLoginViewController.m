//
//  LKLoginViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKLoginViewController.h"
#import "LKLoginMainView.h"

@interface LKLoginViewController ()
@property (nonatomic,strong) LKLoginMainView *mainView;

@end

@implementation LKLoginViewController

- (LKLoginMainView *)mainView{
    if (!_mainView){
        _mainView = [[LKLoginMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"登录"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self.view addSubview:self.mainView];
    
    @weakify(self);
    self.mainView.clickedGetCodeBlock = ^(NSString *iphone) {
        @strongify(self);
        [self loadCode:iphone];
    };
    
    self.mainView.codeLogin = ^(NSString *iphone, NSString *code) {
        @strongify(self);
        [self loginWithPhone:iphone code:code];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

///根据手机号码获取验证码
- (void)loadCode:(NSString *)iphone{
     @weakify(self);
    [[LKLoginServer manager] getCodeModelWithParams:@{@"phoneNumber":[NSString stringValue:iphone],@"noticeType":@(1),@"businessType":@"MSG1001"} successedBlock:^(LKBaseModel *item, LKResult *response) {
        NSString *code = response.data[@"code"];
        NSLog(@"当前验证码是___%@",code);
        @strongify(self);
        // 测试环境直接设置code
//        [self.mainView settingCode:code];
    } failedBlock:^(LKBaseModel *item, NSError *error) {
        
    }];
}

- (void)loginWithPhone:(NSString *)phone code:(NSString *)code {
    [[LKLoginServer manager] loginWithParams:@{@"loginType":@"1",@"loginId":phone,@"code":code,@"token":@""} finishedBlock:^(LKResult *item, BOOL isFinished) {
        if (isFinished) {
            LKUserInfoModel *model = [LKUserInfoModel modelWithDict:item.data];
            model.iphone = phone;
            
            [LKUserInfoUtils updateModel:model];
            
            if (model.user_type != LKUserType_Default) {
                // 已选择状态
                [LKMediator openTabBar];
            }else{
                [LKMediator openSelectUserType];
            }
        }else{
            [LKUtils showMessage:item.replyText];
        }
     
    } failedBlock:^(NSError *error) {
        [LKUtils showMessage:@"登录失败，请检查网络"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
