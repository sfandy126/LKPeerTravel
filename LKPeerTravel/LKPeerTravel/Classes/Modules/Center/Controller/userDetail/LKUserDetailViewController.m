//
//  LKUserDetailViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailViewController.h"

#import "LKUserDetailMainView.h"
#import "UIViewController+LKStatusBarStyle.h"

#import "LKCertifyShowViewController.h"
#import "LKSceneListViewController.h"
#import "LKOrderViewController.h"

@interface LKUserDetailViewController () <LKUserDetailMainViewDelegate>

@property (nonatomic, strong) LKUserDetailMainView *mainView;
@property (nonatomic, strong) LKNavigationBar *navigationBar;

@end

@implementation LKUserDetailViewController

- (LKUserDetailMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LKUserDetailMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    
    [self.navigationBar setTitle:@""];
    
    [self.navigationBar setLeftItemImage:@"btn_title_return_none" target:self action:@selector(popVc)];
    [self.navigationBar setRightItemImage:@"btn_title_share_none" target:self action:@selector(shareAction)];
    [self.navigationBar updataNavigationAlpha:0];
    [self.navigationBar setTitleHidden:YES];
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.navigationBar];
    
    
    // 加载用户信息
    [self loadData];
    
    // 加载服务信息
    [self loadServerData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)loadData {
    NSString *num = self.customerNum;
    if ([NSString isEmptyStirng:num]) {
        num = [LKUserInfoUtils getUserNumber];
    }
    @weakify(self);
    [LKHttpClient POST:@"tx/cif/customer/page" parameters:@{@"customerNumber":num} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
         @strongify(self);
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            LKUserDetailModel *model = [LKUserDetailModel modelWithDictionary:result.data[@"data"]];
            self.mainView.model = model;
            [self.mainView doneLoading];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
  
}

/// 加载服务数据
- (void)loadServerData {
    NSString *num = self.customerNum;
    if ([NSString isEmptyStirng:num]) {
        num = [LKUserInfoUtils getUserNumber];
    }
     @weakify(self);
    [LKHttpClient POST:@"tx/cif/CosSrvice/get" parameters:@{@"no":num} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            LKServerModel *server = [LKServerModel modelWithDictionary:result.data[@"data"]];
            self.mainView.serverModel = server;
            [self.mainView doneLoading];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)shareAction {
    
}

- (void)popVc {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mainViewDidScroll:(CGPoint)contentOffset {
    @weakify(self);
    [self.navigationBar setOffsetY:contentOffset.y alphaBlock:^(CGFloat alpha) {
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

- (void)clickCertifyAtIndex:(NSInteger)index {
    LKCertifyShowViewController *vc = [[LKCertifyShowViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickAllBtnAtPointType:(NSInteger)pointType {
    LKSceneListViewController *vc = [[LKSceneListViewController alloc] init];
    vc.point_type = pointType;
    vc.customNum = self.mainView.model.customerNumber;
     @weakify(self);
    vc.finishedSelectedBlock = ^(NSArray *scenes,NSInteger pointType) {
        @strongify(self);
        [self.mainView finishAddScenes:scenes pointType:pointType];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickImmediateBookingBtn {
    [self.mainView obtainEditData];
    if (self.mainView.editModel.pNum==0) {
        [LKUtils showMessage:@"请选择出行人数"];
        return;
    }
    if (self.mainView.editModel.attractions.count==0) {
        [LKUtils showMessage:@"请选择出行景点"];
        return;
    }
//    if (self.mainView.editModel.shopps.count==0) {
//        [LKUtils showMessage:@"请选择出行商场"];
//        return;
//    }
//    if (self.mainView.editModel.foods.count==0) {
//        [LKUtils showMessage:@"请选择出行美食"];
//        return;
//    }
    NSDictionary *params = [self.mainView.editModel modelToJSONObject];
    NSString *jsonStr = [params modelToJSONString];
    NSLog(@"%@",jsonStr);
    [LKHttpClient POST:@"tx/cif/OmsOrderMast/save" parameters:params progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            [LKUtils showMessage:result.replyText];
//            [self.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //预约成功后跳转至订单列表，待支付tab
                LKOrderViewController *orderList = [[LKOrderViewController alloc] init];
                orderList.orderType = 0;
                [self.navigationController pushViewController:orderList animated:YES];
            });
            
        }else{
            [LKUtils showMessage:result.replyText];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [LKUtils showMessage:@"预约失败，请检查网络"];
    }];
}

@end
