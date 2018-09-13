//
//  MOKORecorderButton.m
//  MOKORecorder
//
//  Created by Spring on 2017/4/27.
//  Copyright © 2017年 Spring. All rights reserved.
//

#import "MOKORecordButton.h"

@implementation MOKORecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(recordTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(recordTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(recordTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(recordTouchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(recordTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(recordTouchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
        [self addTarget:self action:@selector(recordTouchDragExit) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (void)setButtonStateWithRecording
{
    self.backgroundColor = [UIColor lightGrayColor];
    [self setTitle:@"松开结束" forState:UIControlStateNormal];
}

- (void)setButtonStateWithNormal
{
    self.backgroundColor = [UIColor colorWithHexString:@"#007cdf"];
    [self setTitle:@"按住说话" forState:UIControlStateNormal];
}

#pragma mark -- 事件方法回调
- (void)recordTouchDown
{
    if (self.recordTouchDownAction) {
        self.recordTouchDownAction(self);
    }
}

- (void)recordTouchUpOutside
{
    if (self.recordTouchUpOutsideAction) {
        self.recordTouchUpOutsideAction(self);
    }
}

- (void)recordTouchUpInside
{
    if (self.recordTouchUpInsideAction) {
        self.recordTouchUpInsideAction(self);
    }
}

- (void)recordTouchDragEnter
{
    if (self.recordTouchDragEnterAction) {
        self.recordTouchDragEnterAction(self);
    }
}

- (void)recordTouchDragInside
{
    if (self.recordTouchDragInsideAction) {
        self.recordTouchDragInsideAction(self);
    }
}

- (void)recordTouchDragOutside
{
    if (self.recordTouchDragOutsideAction) {
        self.recordTouchDragOutsideAction(self);
    }
}

- (void)recordTouchDragExit
{
    if (self.recordTouchDragExitAction) {
        self.recordTouchDragExitAction(self);
    }
}

@end
