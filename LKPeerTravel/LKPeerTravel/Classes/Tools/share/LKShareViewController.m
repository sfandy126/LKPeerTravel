//
//  LKShareViewController.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKShareViewController.h"
#import "LKAlertPresentDelegate.h"

@interface LKShareViewController ()
@property (nonatomic, strong) LKAlertPresentDelegate *presentDelegate;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic,assign) LKShareType shareType;
@end

@implementation LKShareViewController

- (void)dealloc{
    self.transitioningDelegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self.presentDelegate;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view g_addTapWithTarget:self action:@selector(dismissAction)];
    
    self.contentView.bottom = kScreenHeight;
    [self.view addSubview:self.contentView];
    
    self.titleLabel.top = 20;
    self.titleLabel.centerX = self.contentView.width/2.0;
    [self.contentView addSubview:self.titleLabel];

    self.cancelBtn.bottom = self.contentView.height -20;
    [self.contentView addSubview:self.cancelBtn];
    
    NSArray *items = @[@{@"title":@"weChat",@"image":@"btn_share_wechat"},
                       @{@"title":@"QQ",@"image":@"btn_share_qq"},
                       @{@"title":@"sina",@"image":@"btn_share_sina"},
                       @{@"title":@"facebook",@"image":@"btn_share_facebook"},
                       @{@"title":@"tSwiter",@"image":@"btn_share_twitter"},];
    NSInteger column = 4;//默认一行4个
    CGFloat itemWidth = 50;
    CGFloat inval = 40;
    CGFloat leftX = (self.contentView.width -(itemWidth*column +inval*(column-1)))/2.0;
    NSInteger index = 0;
    for (NSDictionary *dict in items) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 0, itemWidth, itemWidth);
        if (index<column) {
            but.left = leftX +(itemWidth+inval) *index;
            but.top = self.titleLabel.bottom+30;
        }else{
            but.left = leftX;
            but.top = self.titleLabel.bottom+30 +(but.height+30);
        }

        [but setBackgroundImage:[UIImage imageNamed:[dict valueForKey:@"image"]] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(itemButAction:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = 1000+index;
        [self.contentView addSubview:but];
        index++;
    }
}

- (void)itemButAction:(UIButton *)but{
    self.shareType = but.tag -1000;
    if (self.finishedBlock) {
        self.finishedBlock(self.shareType);
    }
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (LKAlertPresentDelegate *)presentDelegate {
    if (!_presentDelegate) {
        _presentDelegate = [[LKAlertPresentDelegate alloc] init];
        _presentDelegate.isPresent = YES;
    }
    return _presentDelegate;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"分享到";
        _titleLabel.font = kBFont(16);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.frame = CGRectMake(0, 0, _contentView.width, ceil(_titleLabel.font.lineHeight));
    }
    return _titleLabel;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = kFont(16);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#c8c8c8"] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(0, 0, _contentView.width, ceil(_cancelBtn.titleLabel.font.lineHeight));
        [_cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


@end
