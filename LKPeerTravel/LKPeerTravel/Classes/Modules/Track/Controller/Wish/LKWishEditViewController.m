//
//  LKWishEditViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishEditViewController.h"

#import "LKWishEditMainView.h"

@interface LKWishEditViewController ()

@property (nonatomic, strong) LKWishEditMainView *mainView;
@property (nonatomic, strong) LKWishEditModel *editModel;

@end

@implementation LKWishEditViewController

- (LKWishEditModel *)editModel {
    if (!_editModel) {
        _editModel = [[LKWishEditModel alloc] init];
        _editModel.customerNumber = [LKUserInfoUtils getUserNumber];
        _editModel.flgCar = @"0";
        _editModel.flagPickUp = @"0";
    }
    return _editModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑心愿单";
    [self.view addSubview:self.mainView];
    self.mainView.editModel = self.editModel;
    self.mainView.model = self.model;
    self.mainView.isReEdit = self.model?YES:NO;
    
    UIButton *leftBut = [self setLeftButtonWithImageName:@"btn_title_return_none" hightlightedImageName:@"btn_title_return_pressed" title:@""];
    [leftBut addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 44, 44);
    [rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBut.titleLabel.font = kBFont(14);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftItemAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)rightAction {
    NSString *msg = @"";
    if ([NSString isEmptyStirng:_editModel.codCityNo]) {
        msg = @"请选择目的地";
    }
    if ([NSString isEmptyStirng:_editModel.beginTime] && msg.length==0) {
        msg = @"请选择出行时间";
    }
    if ([NSString isEmptyStirng:_editModel.language] && msg.length==0) {
        msg = @"请选择语言要求";
    }
    if (_editModel.codPeopleCount==0 && msg.length==0) {
        msg = @"请输入出行人数";
    }
    if (_editModel.codBudgetAmount==0 && msg.length==0) {
        msg = @"请输入预算";
    }
    if ([NSArray isEmptyArray:self.mainView.selectedWishLabels] && msg.length==0) {
        msg = @"选择心愿标签";
    }
    if (msg.length>0) {
        [LKUtils showMessage:msg];
        return;
    }
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in self.mainView.selectedWishLabels) {
        [temp addObject:[NSString stringValue:dict[@"codDestinationPointNo"]]];
    }
    _editModel.wishLabel = [temp componentsJoinedByString:@","];
    NSDictionary *dict = [_editModel modelToJSONObject];
    [LKHttpClient POST:@"tx/cif/customer/wish/addOrUpdate" parameters:dict progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [LKUtils showMessage:@"添加成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
  
}

- (LKWishEditMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LKWishEditMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight)];
    }
    return _mainView;
}


@end
