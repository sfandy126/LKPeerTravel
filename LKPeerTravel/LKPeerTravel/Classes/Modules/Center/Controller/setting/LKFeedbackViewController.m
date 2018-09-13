//
//  LKFeedbackViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/9.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKFeedbackViewController.h"
#import <YYTextView.h>

@interface LKFeedbackViewController ()<YYTextViewDelegate>
@property (nonatomic,strong) YYTextView *textView;
@property (nonatomic,strong) LKBaseModel *model;

@end

@implementation LKFeedbackViewController

- (LKBaseModel *)model{
    if (!_model) {
        _model = [[LKBaseModel alloc] init];
    }
    return _model;
}

- (YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 240)];
        _textView.text = @"";
        _textView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _textView.font = kFont(16);
        _textView.placeholderFont =  _textView.font;
        _textView.placeholderText = @"请输入您要反馈的内容";
        _textView.delegate = self;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.contentInset = UIEdgeInsetsMake(20, 20, 0, 20);
        _textView.contentSize = CGSizeMake(kScreenWidth - 20*2, _textView.height);
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:@"意见反馈"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 44, 44);
    rightBut.titleLabel.font = kFont(16);
    [rightBut setTitle:@"提交" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [self.view addSubview:self.textView];

}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

- (void)submit{
    [self.textView resignFirstResponder];
    [self showLoadingView];
    
    //先过滤空格再判断
    NSString *realStr = self.textView.text;
    realStr = [realStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    realStr = [realStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (realStr.length==0) {
        [LKUtils showMessage:@"请输入反馈内容"];
        return;
    }

    @weakify(self);
    [self.model requestDataWithParams:@{@"feedbackContent":[NSString stringValue:self.textView.text]} forPath:@"tx/cif/feedback" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        [self hideLoadingView];
        [LKUtils showMessage:response.replyText];
        if (response.success) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
        }
    } failed:^(LKBaseModel *item, NSError *error) {
        @strongify(self);
        [self hideLoadingView];
        [LKUtils showMessage:@"提交失败，请检查网络"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
