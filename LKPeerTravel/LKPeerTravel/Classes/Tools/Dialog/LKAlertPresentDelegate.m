//
//  LKAlertPresentDelegate.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAlertPresentDelegate.h"

@implementation LKAlertPresentDelegate

- (instancetype)init {
    self = [super init];
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    LKAlertPresentationController *pc = [[LKAlertPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    return pc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresent = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresent = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresent) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame = [UIScreen mainScreen].bounds;
        [toView layoutIfNeeded];
        [[transitionContext containerView] addSubview:toView];
        [transitionContext completeTransition:YES];
    } else {
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [[transitionContext containerView] willRemoveSubview:fromView];
        [transitionContext completeTransition:YES];
    }
}

@end
