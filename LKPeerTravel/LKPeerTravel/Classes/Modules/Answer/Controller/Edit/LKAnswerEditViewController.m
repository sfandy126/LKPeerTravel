//
//  LKAnswerEditViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerEditViewController.h"
#import "LKAnswerEditServer.h"
#import "LKTextView.h"
#import "LKAnswerEditRowView.h"

#import "LKSelectCityViewController.h"

@interface LKAnswerEditViewController ()

@property (nonatomic,strong) LKAnswerEditServer *server;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LKTextView *titleTextView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) LKTextView *contentTextView;
@property (nonatomic, strong) LKAnswerEditRowView *cityView;
@property (nonatomic, strong) LKAnswerEditRowView *nameView;


@end

@implementation LKAnswerEditViewController

- (LKAnswerEditServer *)server{
    if (!_server) {
        _server = [[LKAnswerEditServer alloc] init];
    }
    return _server;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-kNavigationHeight-10)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (LKTextView *)titleTextView {
    if (!_titleTextView) {
        _titleTextView = [[LKTextView alloc] initWithFrame:CGRectMake(20, 18, kScreenWidth-40, 30)];
        _titleTextView.placehoder = @"点击输入问答标题";
        _titleTextView.font = kFont(14);
        _titleTextView.textColor = kColorGray1;
        _titleTextView.placehoderColor = kColorGray2;
    }
    return _titleTextView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 0.5)];
        _line.backgroundColor = kColorLine1;
    }
    return _line;
}

- (LKTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[LKTextView alloc] initWithFrame:CGRectMake(20, 18, kScreenWidth-40, 230)];
        _contentTextView.placehoder = @"点击输入问答内容";
        _contentTextView.font = kFont(14);
        _contentTextView.textColor = kColorGray1;
        _contentTextView.placehoderColor = kColorGray2;
    }
    return _contentTextView;
}

- (LKAnswerEditRowView *)cityView {
    if (!_cityView) {
        _cityView = [[LKAnswerEditRowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _cityView.title = @"选择城市";
        _cityView.desc = @"香港";
        _cityView.showSwitch = NO;
         @weakify(self);
        [_cityView lk_addTapGestureRecognizerWithBlock:^(UIGestureRecognizer *gestureRecognizer) {
            @strongify(self);
            [self selectCityAction];
        }];
    }
    return _cityView;
}

- (LKAnswerEditRowView *)nameView {
    if (!_nameView) {
        _nameView = [[LKAnswerEditRowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _nameView.title = @"是否匿名";
        _nameView.desc = @"香港";
        _nameView.showSwitch = YES;
    }
    return _nameView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableBackgroundColor;
    self.title = @"问答编辑";
    
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 44, 44);
    rightBut.titleLabel.font = kFont(16);
    [rightBut setTitle:@"广播" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self prepareUI];
}

- (void)prepareUI {

    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.titleTextView];
    
    [self.scrollView addSubview:self.line];
    self.line.top = self.titleTextView.bottom+18;

    [self.scrollView addSubview:self.contentTextView];
    self.contentTextView.top = self.line.bottom+18;

    [self.scrollView addSubview:self.cityView];
    self.cityView.top = self.contentTextView.bottom;

    [self.scrollView addSubview:self.nameView];
    self.nameView.top = self.cityView.bottom;
    @weakify(self);
    self.nameView.switchBlock = ^(BOOL isOn) {
        @strongify(self);
        self.server.model.isAnonymity = isOn;
    };

}

- (void)resignResponder{
    [self.titleTextView resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignResponder];
}

#pragma mark - - Action

- (void)selectCityAction {
    LKSelectCityViewController *vc = [[LKSelectCityViewController alloc] init];
    vc.isChoose = YES;
     @weakify(self);
    vc.selectCityBlock = ^(NSString *city_id, NSString *city_name) {
        @strongify(self);
        if (city_id.length>0) {
            self.cityView.desc = city_name;
            self.server.model.city_id = city_id;
            self.cityView.showSwitch = NO;
        }
    };
    [LKMediator pushViewController:vc animated:YES];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction{
    [self resignResponder];
    self.server.model.title = self.titleTextView.text;
    self.server.model.content = self.contentTextView.text;
    self.server.model.city_id = @"2121";
    
    if (self.server.model.title.length==0) {
        [LKUtils showMessage:@"请输入标题"];
        return;
    }
    if (self.server.model.content.length==0) {
        [LKUtils showMessage:@"请输入内容"];
        return;
    }
    if (self.server.model.city_id.length==0) {
        [LKUtils showMessage:@"请选择城市"];
        return;
    }
    
    [self showLoadingView];
    @weakify(self);
    [self.server obtainAnswerEditDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        if (isFinished) {
            [LKUtils showMessage:item.replyText];
            [self backAction];
        }else{
            [LKUtils showMessage:item.replyText];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
        [LKUtils showMessage:@"问答编辑失败，请检查网络"];
    }];
}

@end
