//
//  LKSendTrackViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackViewController.h"
#import "LKSendTrackMainView.h"

@interface LKSendTrackViewController ()
@property (nonatomic,strong) LKSendTrackMainView *mainView;
@property (nonatomic,strong) LKSendTrackServer *server;
@end

@implementation LKSendTrackViewController

- (LKSendTrackMainView *)mainView{
    if (!_mainView) {
        _mainView = [[LKSendTrackMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight)];
    }
    return _mainView;
}

- (LKSendTrackServer *)server{
    if (!_server) {
        _server = [[LKSendTrackServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavigationBar];
    
    self.mainView.server = self.server;
    self.mainView.vc = self;
    [self.view addSubview:self.mainView];
    
    [self.mainView doneLoading];
    
}

- (void)createNavigationBar{
    
    [self.navigationItem setTitle:@"发布足迹"];
    
    UIButton *leftBut = [self setLeftButtonWithImageName:@"btn_title_return_none" hightlightedImageName:@"btn_title_return_pressed" title:@""];
    [leftBut addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 44, 44);
    rightBut.titleLabel.font = kFont(16);
    [rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)leftItemAction{
    [self.mainView resignTextFieldFirstResponder];
    
    if (self.server.model.infoModel.orderNo.length>0 || self.server.model.infoModel.footprintTitle.length>0||
        self.server.model.infoModel.cityNo.length>0 || self.server.model.infoModel.datTravel.length>0 || self.server.model.infoModel.days>0 || self.server.model.infoModel.peoples>0 || self.server.model.infoModel.perCapital.length>0 || self.server.model.infoModel.perCapitalMax.length>0 || self.server.model.infoModel.dataList.count>0 ) {
        [UIAlertView showButtonWithTitles:nil message:@"是否放弃发布足迹?" buttonTitles:@[@"是",@"否"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemAction{
    if (self.server.model.infoModel.footprintTitle.length==0) {
        [LKUtils showMessage:@"请填写标题"];
        return;
    }
    if (self.server.model.infoModel.cityNo.length==0) {
        [LKUtils showMessage:@"请填写目的地"];
        return;
    }
    if (self.server.model.infoModel.datTravel.length==0) {
        [LKUtils showMessage:@"请填写出发时间"];
        return;
    }
    if (self.server.model.infoModel.days==0) {
        [LKUtils showMessage:@"请填写出行天数"];
        return;
    }
    if (self.server.model.infoModel.peoples==0) {
        [LKUtils showMessage:@"请填写出行人数"];
        return;
    }
    if (self.server.model.infoModel.perCapital.length==0) {
        [LKUtils showMessage:@"请填写最低人均消费"];
        return;
    }
    if (self.server.model.infoModel.perCapitalMax.length==0) {
        [LKUtils showMessage:@"请填写最高人均消费"];
        return;
    }
    
    NSArray *arr = [NSArray getArray:self.server.model.addItems];
    for (LKSendTrackAddModel *imageItem in arr) {
        if (imageItem.uploadProcess == LKImageUploadProccess_uploading) {
            [LKUtils showMessage:@"图片正在上传中"];
            return;
        }
//        if (imageItem.uploadProcess == LKImageUploadProccess_failed) {
//            [LKUtils showMessage:@"图片上传失败，请重新上传"];
//            return;
//        }
    }
    
    if (self.server.model.infoModel.dataList.count==0) {
        [LKUtils showMessage:@"请添加旅游图片"];
        return;
    }
    
    [self showLoadingView];
    @weakify(self);
    [self.server sendFootprintDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        [LKUtils showMessage:item.replyText];
        if (isFinished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        [LKUtils showMessage:@"发布失败，请检查网络"];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
