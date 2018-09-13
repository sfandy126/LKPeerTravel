//
//  LKStateMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKStateMainView.h"

@class LKStateButView;
@interface LKStateMainView ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *desLab;

@property (nonatomic,strong) LKStateButView *guideBut;
@property (nonatomic,strong) LKStateButView *travlBut;
@property (nonatomic,assign) LKUserType selectedUserType;

@property (nonatomic,strong) UIButton *nextBut;

@end


@implementation LKStateMainView

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, self.width, 0)];
        _titleLab.text = @"选择用户类型";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont boldSystemFontOfSize:24.0];
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (UILabel *)desLab{
    if (!_desLab) {
        _desLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _desLab.text = @"*请谨慎选择用户类型，平台暂不支持更改用户类型";
        _desLab.textAlignment = NSTextAlignmentCenter;
        _desLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _desLab.font = [UIFont systemFontOfSize:16.0];
        _desLab.height = ceil(_titleLab.font.lineHeight);
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_desLab.text];
        [attri addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 1)];
        _desLab.attributedText = attri;
    }
    return _desLab;
}

- (LKStateButView *)guideBut{
    if (!_guideBut) {
        _guideBut = [[LKStateButView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120)];
        _guideBut.tag = 1000;
        _guideBut.userType = LKUserType_Guide;
        [_guideBut g_addTapWithTarget:self action:@selector(stateButAction:)];
    }
    return _guideBut;
}

- (LKStateButView *)travlBut{
    if (!_travlBut) {
        _travlBut = [[LKStateButView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120)];
        _travlBut.tag = 1001;
        _travlBut.userType = LKUserType_Traveler;
        [_travlBut g_addTapWithTarget:self action:@selector(stateButAction:)];
    }
    return _travlBut;
}

- (UIButton *)nextBut{
    if (!_nextBut) {
        _nextBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBut.frame = CGRectMake(0, 0, 0,50);
        [_nextBut setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBut.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_nextBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_nextBut addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_get_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
        [_nextBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_nextBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
    return _nextBut;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedUserType = LKUserType_Default;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.titleLab];
    self.desLab.top = self.titleLab.bottom +20;
    [self addSubview:self.desLab];
    
    self.guideBut.top = self.desLab.bottom + 74;
    [self addSubview:self.guideBut];
    
    self.travlBut.top = self.guideBut.bottom + 45;
    [self addSubview:self.travlBut];
    
    self.nextBut.left = 42;
    self.nextBut.bottom = self.height -20;
    self.nextBut.width = self.width - self.nextBut.left*2;
    [self addSubview:self.nextBut];
}

- (void)stateButAction:(UITapGestureRecognizer *)tap{
    LKStateButView *view = (LKStateButView *)tap.view;
    NSInteger index = view.tag -1000;
    if (index==0) {
        view.isSelected = YES;
        self.selectedUserType = LKUserType_Guide;
        LKStateButView *tralView = [self viewWithTag:1001];
        tralView.isSelected = NO;
    }else{
        view.isSelected = YES;
        self.selectedUserType = LKUserType_Traveler;
        LKStateButView *guideView = [self viewWithTag:1000];
        guideView.isSelected = NO;
    }
}

- (void)nextAction{
    if (self.selectedUserType == LKUserType_Default) {
        [LKUtils showMessage:@"请选择类型"];
        return;
    }
    if (self.nextBlock) {
        self.nextBlock(self.selectedUserType);
    }
}

@end


@interface LKStateButView()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIImageView *selectIcon;
@property (nonatomic,strong) UILabel *titleLab;

@end

@implementation LKStateButView

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 104, 90)];
    }
    return _icon;
}

- (UIImageView *)selectIcon{
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _selectIcon;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70,20)];
        _titleLab.text = @"";
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.icon.centerX = self.width/2.0;
        
        self.titleLab.top = self.icon.bottom +10;
        self.titleLab.centerX = self.icon.centerX;
        
        self.selectIcon.right = self.titleLab.left -7;
        self.selectIcon.centerY = self.titleLab.centerY;
        
        self.isSelected = NO;
        [self addSubview:self.icon];
        [self addSubview:self.selectIcon];
        [self addSubview:self.titleLab];
    }
    return self;
}

- (void)setUserType:(LKUserType)userType{
    _userType = userType;
    
    if (userType== LKUserType_Guide) {
        self.titleLab.text = @"我是导游";
        self.icon.image = [UIImage imageNamed:@"img_loading_guide"];

    }else{
        self.titleLab.text = @"我是旅友";
        self.icon.image = [UIImage imageNamed:@"img_loading_visitor"];

    }
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.selectIcon.image = isSelected?[UIImage imageNamed:@"btn_loading_determine_pressed"]:[UIImage imageNamed:@"btn_loading_determine_none"];
}

@end


