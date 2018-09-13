//
//  LKCodeMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCodeMainView.h"
#import "LKCodeInputView.h"

@interface LKCodeMainView ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKCodeInputView *codeView;

@property (nonatomic,strong) UIButton *sureBut;
@property (nonatomic,strong) UIButton *skipBut;

@end

@implementation LKCodeMainView

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, self.width, 0)];
        _titleLab.text = @"填写邀请码";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont boldSystemFontOfSize:24.0];
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (LKCodeInputView *)codeView{
    if (!_codeView) {
        _codeView = [[LKCodeInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    }
    return _codeView;
}

- (UIButton *)sureBut{
    if (!_sureBut) {
        _sureBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBut.frame = CGRectMake(0, 0, 0,50);
        [_sureBut setTitle:@"确认" forState:UIControlStateNormal];
        _sureBut.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_sureBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_sureBut addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_get_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
        [_sureBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_sureBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
    return _sureBut;
}

- (UIButton *)skipBut{
    if (!_skipBut) {
        _skipBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipBut.frame = CGRectMake(0, 0, 0,50);
        [_skipBut setTitle:@"跳过" forState:UIControlStateNormal];
        _skipBut.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_skipBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_skipBut addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_skip_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
        [_skipBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_skipBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
    return _skipBut;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{

    [self addSubview:self.titleLab];
    
    self.codeView.top = self.titleLab.bottom +68;
    [self addSubview:self.codeView];
    
    self.skipBut.left = 42;
    self.skipBut.bottom = self.height -20;
    self.skipBut.width = self.width - self.skipBut.left*2;
    [self addSubview:self.skipBut];
    
    self.sureBut.left = self.skipBut.left;
    self.sureBut.width = self.skipBut.width;
    self.sureBut.bottom = self.skipBut.top -20;
    [self addSubview:self.sureBut];
}

- (void)sureAction{
    if (self.codeView.code.length==0) {
        [LKUtils showMessage:@"请输入邀请码"];
        return;
    }
    if (self.codeView.code.length<CODECOUNT) {
        [LKUtils showMessage:@"请输入正确的邀请码"];
        return;
    }
    if (self.sureBlock) {
        self.sureBlock(self.codeView.code);
    }
}

- (void)skipAction{
    if (self.skipBlock) {
        self.skipBlock();
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.codeView resignResponder];
}



@end




