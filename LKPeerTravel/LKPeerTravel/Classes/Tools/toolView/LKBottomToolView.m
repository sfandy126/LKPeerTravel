//
//  LKBottomToolView.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBottomToolView.h"

@interface  LKCommentView :UIView
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation LKCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 8, 12)];
        _icon.centerY = self.height/2.0;
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.clipsToBounds = YES;
        [self addSubview:_icon];
        
        CGFloat inval = 10;
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _contentLab.left = _icon.right  +inval;
        _contentLab.centerY = self.height/2.0;
        _contentLab.text = @"我要评论...";
        _contentLab.font = kFont(12);
        [self addSubview:_contentLab];
    }
    return self;
}

@end


@interface LKBottomToolView ()
@property (nonatomic,strong) UIImageView *backIcon;
@property (nonatomic,strong) UIControl *backControl;

@property (nonatomic,strong) LKCommentView *commentView;
@property (nonatomic,strong) UIButton *shareBut;
@end

@implementation LKBottomToolView

- (UIImageView *)backIcon{
    if (!_backIcon) {
        _backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    }
    return _backIcon;
}

- (UIControl *)backControl{
    if (!_backControl) {
        _backControl = [[UIControl alloc] initWithFrame:CGRectZero];
        [_backControl addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backControl;
}

- (LKCommentView *)commentView{
    if (!_commentView) {
        _commentView = [[LKCommentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth -60*2, 25)];
        [_commentView g_addTapWithTarget:self action:@selector(commentAction)];
    }
    return _commentView;
}

- (UIButton *)shareBut{
    if (!_shareBut) {
        _shareBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBut.frame = CGRectMake(0, 0, 18, 18);
        [_shareBut addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shareBut;
}

- (void)backAction{
    if (self.clickedBlcok) {
        self.clickedBlcok(LKBottomToolViewType_back);
    }
}

- (void)commentAction{
    if (self.clickedBlcok) {
        self.clickedBlcok(LKBottomToolViewType_comment);
    }
}
- (void)shareAction{
    if (self.clickedBlcok) {
        self.clickedBlcok(LKBottomToolViewType_share);
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = LKBottomToolViewStyle_black;
        
        self.backIcon.left = 20;
        self.backIcon.centerY = self.height/2.0;
        [self addSubview:self.backIcon];

        self.backControl.width = self.backIcon.right+20;
        self.backControl.height = self.height;
//        self.backControl.backgroundColor = [UIColor redColor];
        [self addSubview:self.backControl];
        
        self.commentView.centerY = self.height/2.0;
        self.commentView.centerX = self.width/2.0;
        [self addSubview:self.commentView];
        
        self.shareBut.right = self.width -20;
        self.shareBut.centerY = self.height/2.0;
        [self addSubview:self.shareBut];
        
    }
    return self;
}

- (void)setStyle:(LKBottomToolViewStyle)style{
    _style = style;
    
    if (style == LKBottomToolViewStyle_white) {
        self.backIcon.image = [UIImage imageNamed:@"btn_title_return_none"];
        
        self.commentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.commentView.contentLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        self.commentView.icon.image = [UIImage imageNamed:@"img_foot_write1"];
        
        [self.shareBut setBackgroundImage:[UIImage imageNamed:@"btn_foot_share1_none"] forState:UIControlStateNormal];
        
    }else{
        //默认样式
        self.backIcon.image = [UIImage imageNamed:@"btn_title_return_none"];

        self.commentView.backgroundColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.1];
        self.commentView.contentLab.textColor = [UIColor colorWithHexString:@"#646464"];
        self.commentView.icon.image = [UIImage imageNamed:@"img_foot_write2"];
        
        [self.shareBut setBackgroundImage:[UIImage imageNamed:@"btn_foot_share1_none"] forState:UIControlStateNormal];

    }
}



@end
