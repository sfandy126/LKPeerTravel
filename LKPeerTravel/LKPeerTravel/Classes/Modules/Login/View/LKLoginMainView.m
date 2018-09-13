//
//  LKLoginMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKLoginMainView.h"
#import "LKThirdLoginView.h"
#import "LKCodeViewController.h"

///倒计时
#define timeCount 10

@interface LKLoginMainView ()<UITextFieldDelegate>
///标题
@property (nonatomic,strong) UILabel *titleLab;
///区域按钮
@property (nonatomic,strong) UIButton *zoneBut;
///手机号码输入框
@property (nonatomic,strong) UITextField *iphoneTextField;
///验证码/密码输入框
@property (nonatomic,strong) UITextField *codeTextField;
///验证码倒计时
@property (nonatomic,strong) UIButton *codeTimeBut;
@property (nonatomic,strong) NSTimer *codeTimer;
@property (nonatomic,assign) NSInteger timeNum;

///登录按钮
@property (nonatomic,strong) UIButton *loginBut;
@property (nonatomic,assign) BOOL isCanLogin;
///忘记密码
@property (nonatomic,strong) UIButton *forgetBut;
///手机登录切换按钮
@property (nonatomic,strong) UIButton *switchBut;
///是否为短信验证码登录，默认为密码登录
@property (nonatomic,assign) BOOL isLoginWithCode;

///第三方登录
@property (nonatomic,strong) LKThirdLoginView *thirdLoginView;

//test
@property (nonatomic,strong) UIButton *unLoginBut;

@end

@implementation LKLoginMainView

- (void)dealloc{
    [self.codeTimer invalidate];
    self.codeTimer = nil;
    
    [self removeObserver:self forKeyPath:@"isCanLogin"];
    [self removeObserver:self forKeyPath:@"isLoginWithCode"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"isCanLogin" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"isLoginWithCode" options:NSKeyValueObservingOptionNew context:nil];

        self.isLoginWithCode = NO;
        self.isCanLogin = NO;
        [self createView];
    }
    return self;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 82, kScreenWidth, 0)];
        _titleLab.text = LKLocalizedString(@"LKLogin_title");
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = [UIFont boldSystemFontOfSize:24.0];
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (UIButton *)zoneBut{
    if (!_zoneBut) {
        _zoneBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoneBut.frame = CGRectMake(42, 0, 70,40);
        [_zoneBut setTitle:@"+86" forState:UIControlStateNormal];
        _zoneBut.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_zoneBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_zoneBut setImage:[UIImage imageNamed:@"btn_loading_number_none"] forState:UIControlStateNormal];
        [_zoneBut addTarget:self action:@selector(zoneAction) forControlEvents:UIControlEventTouchUpInside];
        _zoneBut.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        _zoneBut.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    }
    return _zoneBut;
}

- (UITextField *)iphoneTextField{
    if (!_iphoneTextField) {
        _iphoneTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _iphoneTextField.font = [UIFont systemFontOfSize:18.0];
        _iphoneTextField.placeholder = LKLocalizedString(@"LKLogin_iphone_prompt");
        _iphoneTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_iphoneTextField.placeholder];
        [attri addAttributes:@{NSFontAttributeName:_iphoneTextField.font,
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"]
                               } range:NSMakeRange(0, attri.length)];
        _iphoneTextField.attributedPlaceholder = attri;
        _iphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _iphoneTextField.delegate = self;
    }
    return _iphoneTextField;
}

- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _codeTextField.font = [UIFont systemFontOfSize:18.0];
        _codeTextField.textColor = [UIColor colorWithHexString:@"#333333"];
        _codeTextField.delegate = self;
        _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _codeTextField;
}

- (UIView *)setLineViewWithY:(CGFloat)oriY{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.zoneBut.left, oriY, kScreenWidth - self.zoneBut.left*2, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#c8c8c8"];
    return line;
}

- (UIButton *)codeTimeBut{
    if (!_codeTimeBut) {
        _codeTimeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeTimeBut addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
        _codeTimeBut.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _codeTimeBut.frame = CGRectMake(0, 0, 80, 32);
    }
    return _codeTimeBut;
}

- (UIButton *)loginBut{
    if (!_loginBut) {
        _loginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBut addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        _loginBut.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _loginBut.frame = CGRectMake(0, 0,0, 50);
        [_loginBut setTitle:LKLocalizedString(@"LKLogin_login_title") forState:UIControlStateNormal];
    }
    return _loginBut;
}

- (UIButton *)forgetBut{
    if (!_forgetBut) {
        _forgetBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetBut addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
        _forgetBut.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_forgetBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _forgetBut.frame = CGRectMake(0, 0, 0, 20);
        [_forgetBut setTitle:LKLocalizedString(@"LKLogin_foget_title") forState:UIControlStateNormal];
        CGSize size = [LKUtils sizeFit:_forgetBut.titleLabel.text withUIFont:_forgetBut.titleLabel.font withFitWidth:100 withFitHeight:_forgetBut.height];
        _forgetBut.width = size.width+10;
    }
    return _forgetBut;
}

- (UIButton *)switchBut{
    if (!_switchBut) {
        _switchBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBut addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
        _switchBut.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _switchBut.titleLabel.textAlignment = NSTextAlignmentRight;
        [_switchBut setTitleColor:[UIColor colorWithHexString:@"#3192fb"] forState:UIControlStateNormal];
        _switchBut.frame = CGRectMake(0, 0, 0, 20);
    }
    return _switchBut;
}

- (LKThirdLoginView *)thirdLoginView{
    if (!_thirdLoginView) {
        _thirdLoginView = [[LKThirdLoginView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 94)];
        _thirdLoginView.selectedLoginBlock = ^(LKLoginType selectedType) {
            
        };
    }
    return _thirdLoginView;
}

/**************************测试代码*************************/
- (UIButton *)unLoginBut{
    if (!_unLoginBut) {
        _unLoginBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unLoginBut addTarget:self action:@selector(unLoginAction) forControlEvents:UIControlEventTouchUpInside];
        _unLoginBut.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [_unLoginBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _unLoginBut.frame = CGRectMake(0, 0, 80, 40);
        [_unLoginBut setTitle:@"免登录" forState:UIControlStateNormal];
        _unLoginBut.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _unLoginBut;
}

- (void)unLoginAction{
    [LKMediator openTabBar];
}

/**********************************************************/

- (void)createView{
    [self addSubview:self.titleLab];
    
    self.zoneBut.top = self.titleLab.bottom +40;
    [self addSubview:self.zoneBut];
    self.iphoneTextField.left = self.zoneBut.right;
    self.iphoneTextField.height = self.zoneBut.height;
    self.iphoneTextField.width = kScreenWidth - self.iphoneTextField.left -self.zoneBut.left;
    self.iphoneTextField.centerY = self.zoneBut.centerY;
    [self addSubview:self.iphoneTextField];
    [self addSubview:[self setLineViewWithY:self.zoneBut.bottom]];
    
    self.codeTextField.left = self.zoneBut.left;
    self.codeTextField.top =  self.zoneBut.bottom +20;
    self.codeTextField.height = self.zoneBut.height;
    [self addSubview:self.codeTextField];
    [self addSubview:[self setLineViewWithY:self.codeTextField.bottom]];
    
    [self addSubview:self.codeTimeBut];
    
    self.loginBut.left = 40;
    self.loginBut.width = kScreenWidth - self.loginBut.left*2;
    self.loginBut.top = self.codeTextField.bottom + 35;
    [self addSubview:self.loginBut];
    
    self.switchBut.right = self.loginBut.right;
    self.switchBut.top = self.loginBut.bottom +15;
    [self addSubview:self.switchBut];
    
    self.forgetBut.left = self.loginBut.left;
    self.forgetBut.centerY = self.switchBut.centerY;
    [self addSubview:self.forgetBut];
    
    self.thirdLoginView.bottom = self.height;
    [self addSubview:self.thirdLoginView];
    
    //测试代码
    self.unLoginBut.centerX = self.width/2;
    self.unLoginBut.bottom = self.height - 150;
    [self addSubview:self.unLoginBut];
    
}

///是否重置倒计时界面
- (void)resetTime:(BOOL)isReset{
    NSString *bgImageStr = @"";
    if (isReset) {
        self.codeTimeBut.enabled = YES;
        [self.codeTimeBut setTitle:LKLocalizedString(@"LKLogin_getCode_title") forState:UIControlStateNormal];
        [self.codeTimeBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        bgImageStr = @"btn_loading_code_none";

    }else{
        self.codeTimeBut.enabled = NO;
        [self.codeTimeBut setTitle:[NSString stringWithFormat:@"%zds",_timeNum] forState:UIControlStateNormal];
        [self.codeTimeBut setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        bgImageStr = @"btn_loading_code_invalid";
    }
    
    UIImage *bgImage =[UIImage imageNamed:bgImageStr];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
    [self.codeTimeBut setBackgroundImage:bgImage forState:UIControlStateNormal];
}

///收缩键盘
- (void)resignResponder{
    [self.iphoneTextField resignFirstResponder];
    [self.codeTextField  resignFirstResponder];
}

- (void)settingCode:(NSString *)code {
    _codeTextField.text = code;
}

#pragma mark - - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isLoginWithCode"]) {
        //改变普通登录方式
        NSString *placeholderText = @"";
        if (self.isLoginWithCode) {
            placeholderText = LKLocalizedString(@"LKLogin_code_prompt");//@"请输入您的验证码";
            [self.switchBut setTitle:LKLocalizedString(@"LKLogin_password_title") forState:UIControlStateNormal];
            if (!self.codeTimer) {//正在倒计时时，切换不再重置倒计时界面
                self.codeTimeBut.enabled = YES;
                [self resetTime:YES];
            }
        }else{
            placeholderText = LKLocalizedString(@"LKLogin_password_prompt");//@"请输入您的密码";
            [self.switchBut setTitle:LKLocalizedString(@"LKLogin_code_title") forState:UIControlStateNormal];
        }
        CGSize size = [LKUtils sizeFit:_switchBut.titleLabel.text withUIFont:_switchBut.titleLabel.font withFitWidth:100 withFitHeight:_switchBut.height];
        self.switchBut.width = size.width+10;
        self.switchBut.right = self.loginBut.right;
        self.forgetBut.hidden = self.isLoginWithCode;

        self.codeTextField.placeholder = placeholderText;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.codeTextField.placeholder];
        [attri addAttributes:@{NSFontAttributeName:self.codeTextField.font,
                               NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"]
                               } range:NSMakeRange(0, attri.length)];
        self.codeTextField.attributedPlaceholder = attri;
        
        if (self.isLoginWithCode) {
            self.codeTimeBut.hidden = NO;
            self.codeTimeBut.centerY = self.codeTextField.centerY;
            self.codeTimeBut.right = kScreenWidth - self.zoneBut.left;
            self.codeTextField.width = self.codeTimeBut.left - self.codeTextField.left;
            
            self.codeTextField.secureTextEntry = NO;
            self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;

        }else{
            self.codeTimeBut.hidden = YES;
            self.codeTextField.width = kScreenWidth - self.zoneBut.left*2;
            
            self.codeTextField.secureTextEntry = YES;
            self.codeTextField.keyboardType = UIKeyboardTypeDefault;
        }
    }
    if ([keyPath isEqualToString:@"isCanLogin"]) {
        //改变是否可登录相关的UI
        NSString *bgImageStr = @"";
        if (self.isCanLogin) {
            self.loginBut.enabled = YES;
            [self.loginBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            bgImageStr = @"btn_loading_get_none";
        }else{
            self.loginBut.enabled = NO;
            [self.loginBut setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            bgImageStr = @"btn_loading_get_invalid";
        }
        UIImage *bgImage =[UIImage imageNamed:bgImageStr];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
        [self.loginBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self.loginBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    }
}

#pragma mark - - action

///手机号区域选择
- (void)zoneAction{
    [self resignResponder];
}

///获取验证码
- (void)getCodeAction{
    
    //校验
    if (_iphoneTextField.text.length==0) {
        [LKUtils showMessage:LKLocalizedString(@"LKLogin_iphone_prompt")];//@"请输入手机号码"
        return;
    }
    if (![LKUtils validatePhoneNumber:_iphoneTextField.text]) {
        [LKUtils showMessage:LKLocalizedString(@"LKLogin_EnterCorrectIphoneNumber")];//@"请输入正确的手机号码"
        return;
    }
    
    if (self.clickedGetCodeBlock) {
        self.clickedGetCodeBlock(_iphoneTextField.text);
    }
    
    _codeTimeBut.enabled = NO;
    
    _timeNum = timeCount;
    if (_codeTimer) {
        [_codeTimer invalidate];
        _codeTimer = nil;
    }
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [_codeTimer fire];
}

- (void)timeAction{
    if (_timeNum ==0) {
        _codeTimeBut.enabled = YES;
        [self resetTime:YES];
        if (_codeTimer) {
            [_codeTimer invalidate];
            _codeTimer = nil;
        }
    }else{
        [self resetTime:NO];
    }
    _timeNum--;
}

- (void)loginAction{
    [self resignResponder];
    
    //校验
    if (_iphoneTextField.text.length==0) {
        [LKUtils showMessage:LKLocalizedString(@"LKLogin_iphone_prompt")];//@"请输入手机号码"
        return;
    }
    if (![LKUtils validatePhoneNumber:_iphoneTextField.text]) {
        [LKUtils showMessage:LKLocalizedString(@"LKLogin_EnterCorrectIphoneNumber")];//@"请输入正确的手机号码"
        return;
    }
    
    if (_codeTextField.text.length==0) {
        [LKUtils showMessage:self.isLoginWithCode?LKLocalizedString(@"LKLogin_code_prompt"):LKLocalizedString(@"LKLogin_password_prompt")];
        return;
    }
    
    if (self.codeLogin) {
        self.codeLogin(_iphoneTextField.text, _codeTextField.text);
    }
}

- (void)forgetAction{
    [self resignResponder];
}

- (void)switchAction{
    [self resignResponder];
    //切换清空
    self.codeTextField.text = @"";
    self.isLoginWithCode = !self.isLoginWithCode;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignResponder];
}

#pragma mark - - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.iphoneTextField.text.length>1 && self.codeTextField.text.length>1) {
        self.isCanLogin = YES;
    }else{
        self.isCanLogin = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.iphoneTextField.text.length>1 && self.codeTextField.text.length>1) {
        self.isCanLogin = YES;
    }else{
        self.isCanLogin = NO;
    }

    return YES;
}


@end
