//
//  LKMyServerViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerViewController.h"
#import "LKMyServerMainView.h"

#import "LKSceneListViewController.h"
#import "LKEditSceneViewController.h"

#import "LKEditServerModel.h"

@interface LKMyServerViewController () <LKMyServerMainViewDelegate>
@property (nonatomic,strong) LKMyServerMainView *mainView;
@property (nonatomic,strong) LKMyServerServer *server;
@property (nonatomic,strong) UIButton *rightBut;



@end

@implementation LKMyServerViewController

- (LKMyServerMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKMyServerMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight)];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (LKMyServerServer *)server{
    if (!_server) {
        _server =[[LKMyServerServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];

    [self.navigationItem setTitle:@"我的服务"];
    
    _rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBut.frame = CGRectMake(0, 0, 44, 44);
    [_rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [_rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    _rightBut.titleLabel.font = kBFont(14);
    [_rightBut addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.mainView.server = self.server;
    [self.view addSubview:self.mainView];
    
    [self loadData];
}

- (void)loadData{
    [self showLoadingView];
    @weakify(self);
    [self.server obtainMyServerDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
        [self.mainView doneLoading];
        [LKUtils showMessage:@"请求失败，请检查网络"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)editAction{
    self.server.model.isEditing = !self.server.model.isEditing;
    
//    [self.mainView complishEdit];
    
    [self save];
}

- (void)save{
    [self showLoadingView];
    [self.mainView complishEdit];
    @weakify(self);
    [self.server saveMyServerParams:[self.mainView.editModel modelToJSONObject] finishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
//        [self.mainView doneLoading];
        if (isFinished) {
            [LKUtils showMessage:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [LKUtils showMessage:item.replyText];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
        [LKUtils showMessage:@"保存失败,请检查网络"];
    }];

}

#pragma mark -- LKMyServerMainViewDelegate

- (void)mainViewDidClickAdd:(NSInteger)addType {
    LKEditSceneViewController *vc = [[LKEditSceneViewController alloc] init];
//    LKSceneListViewController *vc = [[LKSceneListViewController alloc] init];
    vc.point_type = addType;
     @weakify(self);
    vc.successAddBlock = ^(NSDictionary *dict) {
        @strongify(self);
        [self.mainView editSceneFinishedType:addType data:dict];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
