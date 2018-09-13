//
//  LKCalendarPickerViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCalendarPickerViewController.h"

#import "LKActionSheetDelegate.h"

#import "LKCalendarPickerView.h"

@interface LKCalendarPickerViewController ()

@property (nonatomic, strong) LKActionSheetDelegate *animator;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) LKCalendarPickerView *pickerView;

@property (nonatomic, strong) UIButton *sureBtn;


@end

@implementation LKCalendarPickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animator = [[LKActionSheetDelegate alloc] init];
        
        CGFloat x = 0;
        CGFloat height = 400;
        _animator.presentFrame = CGRectMake(x, kScreenHeight - height, kScreenWidth, height);
        _animator.unClickDismiss = NO;
        self.transitioningDelegate = self.animator;
        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.alphaView];
    [self.view addSubview:self.contentView];
    
    self.sureBtn.right = self.contentView.width-10;
    self.sureBtn.top = 10;
    [self.contentView addSubview:self.sureBtn];

    self.pickerView.bottom = self.contentView.height;
    [self.contentView addSubview:self.pickerView];
    
     @weakify(self);
    [self.alphaView lk_addTapGestureRecognizerWithBlock:^(UIGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (UIView *)alphaView{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-400)];
        _alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _alphaView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (LKCalendarPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[LKCalendarPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 344)];
    }
    return _pickerView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.titleLabel.font = kBFont(14);
        [_sureBtn setTitleColor:kColorYellow1 forState:UIControlStateNormal];
        [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        _sureBtn.frame = CGRectMake(0, 0, 44, 44);
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)sureAction{
    if (self.pickerView.BeginDate && self.pickerView.EndDate) {
        if (self.selectCalendarBlock) {
            self.selectCalendarBlock([LKUtils dateToString:self.pickerView.BeginDate withDateFormat:@"yyyy-MM-dd"], [LKUtils dateToString:self.pickerView.EndDate withDateFormat:@"yyyy-MM-dd"]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [LKUtils showMessage:@"请选择开始和结束时间"];
    }
}


@end
