//
//  UIView+LKGesture.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIView+LKGesture.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) tapGestureRecognizerBlock tapBlock;

@end

@implementation UIView (LKGesture)

- (void)addControl_target:(id)target action:(SEL)action {
    UIControl* control = [[UIControl alloc] initWithFrame:self.bounds];
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
}

- (void)g_addTapWithTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}


- (void)addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    
}

- (void)removeAllTarget {
    for (UIGestureRecognizer* recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }
    self.userInteractionEnabled = NO;
}


static const char * TAP_BLOCK_KEY = "JKR_TAP_BLOCK_KEY";

- (void)lk_addTapGestureRecognizerWithBlock:(void (^)(UIGestureRecognizer *))block {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapBlock = block;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer {
    self.tapBlock(gestureRecognizer);
}

- (tapGestureRecognizerBlock)tapBlock {
    return objc_getAssociatedObject(self, TAP_BLOCK_KEY);
}

- (void)setTapBlock:(tapGestureRecognizerBlock)tapBlock {
    objc_setAssociatedObject(self, TAP_BLOCK_KEY, tapBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
