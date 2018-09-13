//
//  LKActionSheetDelegate.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKActionSheetDelegate.h"

#import "LKPresentationController.h"

@implementation LKActionSheetDelegate

- (instancetype)init {
    self = [super init];
    _animationDuration = 0.3f;
    _showDismissAmination = YES;
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    LKPresentationController *pc = [[LKPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    pc.presentFrame = _presentFrame;
    pc.isEffect = _isEffect;
    pc.unClickDismiss = _unClickDismiss;
    pc.showDismissAmination = _showDismissAmination;
    return pc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isPresent = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isPresent = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_isPresent) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        [[transitionContext containerView] addSubview:toView];
        toView.top = kScreenHeight;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.top = kScreenHeight - toView.height;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.top = kScreenHeight;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
