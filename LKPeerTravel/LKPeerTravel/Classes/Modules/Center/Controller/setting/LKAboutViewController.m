//
//  LKAboutViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/9.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAboutViewController.h"

@interface LKAboutViewController ()
@property (nonatomic,strong) LKBaseModel *model;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *htmlContent;
@end

@implementation LKAboutViewController

- (LKBaseModel *)model{
    if (!_model) {
        _model = [[LKBaseModel alloc] init];
    }
    return _model;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationHeight)];
        _webView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    }
    return _webView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"关于我们"];
    [self.view addSubview:self.webView];
    
    [self showLoadingView];
    [self loadData];
}

- (void)loadData{
    @weakify(self);
    [self.model requestDataWithParams:@{} forPath:@"tx/cif/about/us" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            NSDictionary *data = [NSDictionary getDictonary:response.data];
            self.htmlContent = [NSString stringValue:[data valueForKey:@"htmlContent"]];
        }
        [self doneLoading];
    } failed:^(LKBaseModel *item, NSError *error) {
        @strongify(self);
        [self doneLoading];

    }];
}

- (void)doneLoading{
    [self hideLoadingView];
    [self.webView loadHTMLString:self.htmlContent baseURL:nil];
}

@end
