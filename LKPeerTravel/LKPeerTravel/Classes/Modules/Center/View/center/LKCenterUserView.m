//
//  LKCenterUserView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterUserView.h"

#import "LKPersonInfoViewController.h"

#import "LKVoiceView.h"

@implementation LKCenterUserView



{
    UIImageView *_bgIV;
    UIImageView *_avaterIV;
    UILabel *_usernameLabel;
    UIButton *_editBtn;
    LKVoiceView *_voiceView;
    UIImageView *_locationIcon;
    UILabel *_locationLabel;
    
    UIImageView *_integalView;
    UILabel *_integalLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景图
        _bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _bgIV.userInteractionEnabled = YES;
        _bgIV.image = [[UIImage imageNamed:@"img_block1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
        [self addSubview:_bgIV];
        
        // 头像
        _avaterIV = [[UIImageView alloc] initWithFrame:CGRectMake(21, 17, 70, 70)];
        _avaterIV.layer.cornerRadius = _avaterIV.height*0.5;
        _avaterIV.layer.masksToBounds =  YES;
        _avaterIV.image = kDefaultUserImage(0);
        _avaterIV.userInteractionEnabled = YES;
        [_avaterIV g_addTapWithTarget:self action:@selector(userDetail)];
        [_bgIV addSubview:_avaterIV];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.font = [UIFont systemFontOfSize:20];
        _usernameLabel.textColor = [UIColor hexColor333333];
        _usernameLabel.text = @"";
        _usernameLabel.frame = CGRectMake(_avaterIV.right+10, 22, 200, ceil(_usernameLabel.font.lineHeight));
        [_bgIV addSubview:_usernameLabel];
        
        //语音按钮
        _voiceView = [[LKVoiceView alloc] initWithFrame:CGRectMake(_usernameLabel.right+7, 22, 58, 18)];
        _voiceView.centerY = _usernameLabel.centerY;
        [_bgIV addSubview:_voiceView];
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_editBtn setTitle:@"查看或编辑个人资料" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor hexColorb4b4b4] forState:UIControlStateNormal];
        _editBtn.frame = CGRectMake(_usernameLabel.left, _usernameLabel.bottom+15, 200, ceil(_editBtn.titleLabel.font.lineHeight));
        [_editBtn addTarget:self action:@selector(editUserInfo) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_bgIV addSubview:_editBtn];
        
        // 上游位置信息
        _locationLabel = [UILabel new];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.textColor = [UIColor hexColor333333];
        _locationLabel.text = @"";
        _locationLabel.frame = CGRectMake(0, 26, 200, ceil(_locationLabel.font.lineHeight));
        _locationIcon.hidden = YES;
        [_bgIV addSubview:_locationLabel];
        
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 10, 13)];
        _locationIcon.backgroundColor = [UIColor clearColor];
        _locationIcon.image = [UIImage imageNamed:@"img_guide_position"];
        _locationIcon.hidden = _locationLabel.hidden;
        [_bgIV addSubview:_locationIcon];
        
        
        _integalView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_my_integral_block"]];
        _integalView.top = 22;
        _integalView.right = self.width-3;
        [_bgIV addSubview:_integalView];
        
        UIImageView *integalIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_my_integral_icon"]];
        integalIcon.left = 5;
        integalIcon.centerY = _integalView.height*0.5;
        [_integalView addSubview:integalIcon];
        
        _integalLabel = [UILabel new];
        _integalLabel.font = kBFont(12);
        _integalLabel.textColor = kColorWhite;
        _integalLabel.frame = CGRectMake(integalIcon.right+5, 0, 50, ceil(_integalLabel.font.lineHeight));
        _integalLabel.text = @"x42";
        _integalLabel.centerY = integalIcon.centerY;
        [_integalView addSubview:_integalLabel];
        _integalView.hidden = YES;
        
        
        CGFloat iconWidth = self.width/4.0;
        for (int i = 0; i<4; i++) {
            LKCenterUserIconView *iconView = [[LKCenterUserIconView alloc] initWithFrame:CGRectMake(i*iconWidth, _avaterIV.bottom+23, iconWidth, 0)];
            iconView.tag = 100+i;
            [_bgIV addSubview:iconView];
            _bgIV.height = iconView.bottom+18;
        }
        
    }
    return self;
}

/// 编辑用户信息
- (void)editUserInfo {
    LKPersonInfoViewController *vc = [[LKPersonInfoViewController alloc] init];
    vc.model = self.model;
    [LKMediator pushViewController:vc animated:YES];
}

- (void)userDetail {
    [LKMediator openUserDetail:@""];
}

- (void)playVoice {
    
}

- (void)setModel:(LKCenterModel *)model {
    _model = model;
    
    UIImage *img = kDefaultManHead;
    if ([model.gender integerValue]==1) {
        img = kDefaultFemaleHead;
    }
    [_avaterIV sd_setImageWithURL:[NSURL URLWithString:model.portraitPic] placeholderImage:img];
    
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        _usernameLabel.text = model.customerName;
    } else {
        _usernameLabel.text = model.customerNm;
    }
    
    _voiceView.hidden = model.speechIntroduction.length==0;
    
    CGSize size = [LKUtils sizeFit:_usernameLabel.text withUIFont:_usernameLabel.font withFitWidth:_bgIV.width-_avaterIV.right-(_voiceView.hidden?60:140) withFitHeight:30];
    _usernameLabel.width = size.width;
    _voiceView.left = _usernameLabel.right+7;
    
    NSArray *titles = @[@"游记",@"问答"];
    NSArray *nums = @[[NSString stringWithFormat:@"%ld",model.travelsNum],[NSString stringWithFormat:@"%ld",model.answerNum]];
    // 下游
    if ([model.customerType integerValue]==1) {
        _voiceView.hidden = YES;
        _locationIcon.hidden = YES;
        _locationLabel.hidden = YES;
        
        _integalView.hidden = NO;
    } else {
        _locationLabel.text = model.cityName;
        _locationIcon.hidden = _locationLabel.text.length==0;
        [_locationLabel sizeToFit];
        _locationLabel.right = kScreenWidth-23-10;
        _locationIcon.centerY = _locationLabel.centerY;
        _locationIcon.right = _locationLabel.left-3;

        if (model.speechIntroduction.length>0) {
            _voiceView.voiceUrl = model.speechIntroduction;
        }
       
        _voiceView.hidden = model.speechIntroduction.length==0;

        titles = @[@"服务客户",@"服务评价",@"星级",@"收藏"];
        nums = @[[NSString stringWithFormat:@"%ld",model.serviceNum],[NSString stringWithFormat:@"%ld",model.commentNum],[NSString stringValue:model.starLevel],[NSString stringWithFormat:@"%ld",model.collectionNum]];
    }
    
    for (int i=0; i<4; i++) {
        LKCenterUserIconView *iconView = [_bgIV viewWithTag:100+i];
        NSString *title = [titles objectAt:i];
        NSString *num = [nums objectAt:i];
        if (title) {
            iconView.hidden = NO;
            iconView.title = title;
            iconView.num = num;
        } else {
            iconView.hidden = YES;
        }
    }
    
}

@end



@implementation LKCenterUserIconView

{
    UILabel *_topLabel;
    UILabel *_bottomLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _topLabel = [UILabel new];
        _topLabel.font = [UIFont boldSystemFontOfSize:18];
        _topLabel.textColor = [UIColor hexColor333333];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.frame = CGRectMake(0, 0, self.width, ceil(_topLabel.font.lineHeight));
        _topLabel.text = @"7123";
        [self addSubview:_topLabel];
        
        _bottomLabel = [UILabel new];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = [UIColor hexColorb4b4b4];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.frame = CGRectMake(0, _topLabel.bottom+13, self.width, ceil(_bottomLabel.font.lineHeight));
        _bottomLabel.text = @"服务客户";
        [self addSubview:_bottomLabel];
        
        self.height = _bottomLabel.bottom;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    _bottomLabel.text = title;
}

- (void)setNum:(NSString *)num {
    _num = num;
    
    _topLabel.text = num;
}

@end



