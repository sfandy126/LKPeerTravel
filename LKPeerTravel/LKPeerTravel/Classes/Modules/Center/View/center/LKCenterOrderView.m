//
//  LKCenterOrderView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterOrderView.h"

#define orderBtnTag 100

#define orderBtnFont [UIFont systemFontOfSize:12]

@implementation LKCenterOrderView

{
    UIImageView *_bgIV;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景图
        _bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _bgIV.userInteractionEnabled = YES;
        _bgIV.image = [[UIImage imageNamed:@"img_block1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
        [self addSubview:_bgIV];
        
        UILabel *title = [UILabel new];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textColor = [UIColor hexColor333333];
        title.text = @"我的订单";
        title.frame = CGRectMake(17, 16, 100, ceil(title.font.lineHeight));
        [_bgIV addSubview:title];
        
        NSArray *titles = @[@"待支付",@"已支付",@"已完成",@"已取消"];
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            titles = @[@"全部订单",@"待服务",@"已服务",@"已取消"];
        }
        
        [_bgIV addSubview:[self orderBtnWithIcon:@"btn_my_order_all_none" highlightIcon:@"btn_my_order_all_pressed" title:titles[0] index:0 top:title.bottom+29]];
        [_bgIV addSubview:[self orderBtnWithIcon:@"btn_my_order_wait_none" highlightIcon:@"btn_my_order_wait_pressed" title:titles[1] index:1 top:title.bottom+29]];
        [_bgIV addSubview:[self orderBtnWithIcon:@"btn_my_order_already_none" highlightIcon:@"btn_my_order_already_pressed" title:titles[2] index:2 top:title.bottom+29]];
        [_bgIV addSubview:[self orderBtnWithIcon:@"btn_my_order_cancel_none" highlightIcon:@"btn_my_order_cancel_pressed" title:titles[3] index:3 top:title.bottom+29]];

    }
    return self;
}

- (LKCenterOrderBtn *)orderBtnWithIcon:(NSString *)icon highlightIcon:(NSString *)highlightIcon title:(NSString *)title index:(NSInteger)index top:(CGFloat)top{
    CGFloat width = self.width/4.0;
    LKCenterOrderBtn *btn = [LKCenterOrderBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(index*width, top, width, 32+10+ceil(orderBtnFont.lineHeight));
    btn.titleLabel.font = orderBtnFont;
    [btn setTitleColor:[UIColor hexColor333333] forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor hexColor333333] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];

    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightIcon] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.tag = index+orderBtnTag;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnAction:(LKCenterOrderBtn *)sender {
    if (self.selectedBlock) {
        self.selectedBlock(sender.tag - orderBtnTag);
    }
}


@end


@implementation LKCenterOrderBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = 32;
    CGFloat left = (CGRectGetWidth(contentRect)-width)/2.0;
    return CGRectMake(left, 0, width, width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, 32+10, CGRectGetWidth(contentRect), ceil(orderBtnFont.lineHeight));
}

@end
