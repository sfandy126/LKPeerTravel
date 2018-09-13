//
//  LKPresentationController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPresentationController.h"

@interface LKPresentationController ()

@property (nonatomic, strong) UIView *corverView;
@property (nonatomic, strong) UIImageView *maskImageView;

@end


@implementation LKPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    return self;
}

- (void)containerViewWillLayoutSubviews {
    self.presentedView.frame = _presentFrame;
    if (_isEffect) return;
    //    [self.containerView insertSubview:self.maskImageView atIndex:0];
    //    self.presentedViewController.view.hidden = YES;
    //    self.maskImageView.image = [[[UIApplication sharedApplication].keyWindow snapshotImage] jkr_Blur];
    //    [self.containerView insertSubview:self.corverView aboveSubview:self.maskImageView];
    //    self.presentedViewController.view.hidden = NO;
    [self.containerView insertSubview:self.corverView atIndex:0];
}

- (UIView *)corverView {
    if (!_corverView) {
        _corverView = [[UIView alloc] init];
        _corverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.62];
        _corverView.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        if (!_unClickDismiss) [_corverView addGestureRecognizer:tap];
    }
    return _corverView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.contentMode = UIViewContentModeScaleAspectFill;
        _maskImageView.frame = [UIScreen mainScreen].bounds;
        _maskImageView.userInteractionEnabled = NO;
    }
    return _maskImageView;
}

- (void)close {
    [self.presentedViewController dismissViewControllerAnimated:_showDismissAmination completion:nil];
}

@end
