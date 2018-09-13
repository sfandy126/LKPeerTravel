//
//  LKEditSceneToolView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditSceneToolView.h"


@implementation LKEditSceneToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn1 = [self buttonWithIcon:@"img_service_picture" title:@"添加图片" tag:1];
        UIButton *btn2 = [self buttonWithIcon:@"img_service_word" title:@"添加文字" tag:2];
        [self addSubview:btn1];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 1, self.height-16)];
        line.backgroundColor = kColorLine2;
        line.right = btn1.right;
        [self addSubview:line];
        
        btn2.left = line.right;
        [self addSubview:btn2];
        
        self.backgroundColor = kColorGray6;
    }
    return self;
}

- (UIButton *)buttonWithIcon:(NSString *)icon title:(NSString *)title tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kColorGray2 forState:UIControlStateNormal];
    btn.titleLabel.font = kFont(12);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.frame = CGRectMake(0, 0, self.width*0.5, self.height);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}

- (void)btnClick:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender.tag);
    }
}

@end
