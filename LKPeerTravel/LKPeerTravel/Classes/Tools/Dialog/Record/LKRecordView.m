//
//  LKRecordView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/21.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKRecordView.h"

#import "MOKORecordButton.h"

@implementation LKRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorWhite;
        
        UILabel *label = [UILabel new];
        label.font = kFont(16);
        label.textColor = kColorGray1;
        label.frame = CGRectMake(20, 20, self.width-40, ceil(label.font.lineHeight));
        label.text = @"更新录音介绍";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        MOKORecordButton *recordBtn = [MOKORecordButton buttonWithType:UIButtonTypeCustom];
        recordBtn.frame = CGRectMake(0, label.bottom+48, 120, 120);
        recordBtn.layer.cornerRadius = recordBtn.height*0.5;
        recordBtn.layer.masksToBounds = YES;
        recordBtn.backgroundColor = [UIColor colorWithHexString:@"#007cff"];
        [recordBtn setTitle:@"长按录音" forState:UIControlStateNormal];
        [recordBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        recordBtn.titleLabel.font = kBFont(18);
        recordBtn.centerX = self.width*0.5;
        [self addSubview:recordBtn];
    }
    return self;
}

@end
