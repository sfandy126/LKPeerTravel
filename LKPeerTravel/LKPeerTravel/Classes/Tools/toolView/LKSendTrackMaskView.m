//
//  LKSendTrackMaskView.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackMaskView.h"


@interface LKSendButView :UIView
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *titleLab;


@end

@implementation LKSendButView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.icon.centerX = self.width/2.0;
        [self addSubview:self.icon];

        self.titleLab.top = self.icon.bottom + 14;
        self.titleLab.centerX = self.icon.centerX;
        [self addSubview:self.titleLab];
    }
    return self;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 24)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _titleLab.text = @"";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = kBFont(12);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

@end

@interface LKSendTrackMaskView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *contentView;

@end

@implementation LKSendTrackMaskView

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    }
    return _bgView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgView.height-190, self.bgView.width, 190)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return _contentView;
}

- (void )removeAllSubView{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.bgView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setupUI{
    [self removeAllSubView];
    
    [self.bgView g_addTapWithTarget:self action:@selector(close:)];
    [self.bgView addSubview:self.contentView];
    
    LKSendButView *wishView = [[LKSendButView alloc] initWithFrame:CGRectMake(0, 0, 84, 50)];
    wishView.tag = 1000;
    wishView.icon.image = [UIImage imageNamed:@"btn_publish_wish_none"];
    wishView.titleLab.text = @"发布心愿单";
    [wishView g_addTapWithTarget:self action:@selector(butAction:)];
    [self.contentView addSubview:wishView];
    
    LKSendButView *trackView = [[LKSendButView alloc] initWithFrame:CGRectMake(0, 0, 84, 50)];
    trackView.tag = 1001;
    trackView.icon.image = [UIImage imageNamed:@"btn_publish_foot_none"];
    trackView.titleLab.text = @"发布足迹";
    [trackView g_addTapWithTarget:self action:@selector(butAction:)];
    [self.contentView addSubview:trackView];

    CGFloat inval = 40;
    
    CGFloat leftX = (self.contentView.width - (wishView.width + trackView.width +inval))/2.0;
    wishView.top = 42;
    wishView.left = leftX;
    
    trackView.top = wishView.top;
    trackView.left = wishView.right + inval;
    
    UIButton *closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBut.frame = CGRectMake(0, 0, 12, 12);
    closeBut.bottom = self.contentView.height - 20;
    closeBut.centerX = self.contentView.width/2.0;
    [closeBut setBackgroundImage:[UIImage imageNamed:@"btn_test_close_none"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBut];
}

- (void)butAction:(UIGestureRecognizer *)tap{
    UIView *view = tap.view;
    NSInteger index = view.tag - 1000;
    if (self.selectedBlock) {
        self.selectedBlock(index);
        [self hide];
    }
}

- (void)close:(UIGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.bgView];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        //contentView空白区域点击不做响应
        return;
    }
    [self hide];
}

- (void)show{
    [self setupUI];
    [[UIApplication sharedApplication].delegate.window addSubview:self.bgView];
}

- (void)hide{
    [self.bgView removeFromSuperview];
}


@end
