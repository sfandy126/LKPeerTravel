//
//  LKUserDetailUserView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailUserView.h"

#import "LKVoiceView.h"

@implementation LKUserDetailUserView

{
    UIImageView *_bgIV;
    UIImageView *_avaterIV;
    UILabel *_usernameLabel;
    LKVoiceView *_voiceView;
    UIImageView *_locationIcon;
    UILabel *_locationLabel;
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
        [_avaterIV g_addTapWithTarget:self action:@selector(openPersonInfo)];
        [_bgIV addSubview:_avaterIV];
        
        _usernameLabel = [UILabel new];
        _usernameLabel.font = [UIFont systemFontOfSize:20];
        _usernameLabel.textColor = [UIColor hexColor333333];
        _usernameLabel.text = @"";
        _usernameLabel.frame = CGRectMake(_avaterIV.right+10, 22, 200, ceil(_usernameLabel.font.lineHeight));
        [_bgIV addSubview:_usernameLabel];
        
        //语音按钮
        _voiceView = [[LKVoiceView alloc] initWithFrame:CGRectMake(0, 22, 58, 18)];
        _voiceView.centerY = _usernameLabel.centerY;
        [_bgIV addSubview:_voiceView];
        _voiceView.hidden = YES;
    
        
        // 上游位置信息
        _locationLabel = [UILabel new];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.textColor = [UIColor hexColor333333];
        _locationLabel.text = @"";
        _locationLabel.frame = CGRectMake(0, 26, 200, ceil(_locationLabel.font.lineHeight));
        [_locationLabel sizeToFit];
        _locationLabel.right = self.width-23;
        [_bgIV addSubview:_locationLabel];
        
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_usernameLabel.right+7, 16, 13, 13)];
        _locationIcon.backgroundColor = [UIColor clearColor];
        _locationIcon.image = [UIImage imageNamed:@"btn_home_position_1_none"];
        _locationIcon.centerY = _locationLabel.centerY;
        _locationIcon.right = _locationLabel.left-3;
        [_bgIV addSubview:_locationIcon];
        
        CGFloat iconWidth = self.width/4.0;
        NSArray *titles = @[@"服务客户",@"服务评价",@"星级",@"收藏"];
        for (int i = 0; i<4; i++) {
            LKUserDetailUserIconView *iconView = [[LKUserDetailUserIconView alloc] initWithFrame:CGRectMake(i*iconWidth, _avaterIV.bottom+23, iconWidth, 0)];
            iconView.title = titles[i];
            iconView.tag = 200+i;
            [_bgIV addSubview:iconView];
            _bgIV.height = iconView.bottom+18;
        }
        
    }
    return self;
}

- (void)setDetailModel:(LKUserDetailModel *)detailModel {
    _detailModel = detailModel;
    
    UIImage *img = kDefaultManHead;
    if ([detailModel.gender integerValue]==1) {
        img = kDefaultFemaleHead;
    }
    [_avaterIV sd_setImageWithURL:[NSURL URLWithString:detailModel.portraitPic] placeholderImage:img];
    
    _voiceView.hidden = detailModel.speechIntroduction.length==0;
    if (detailModel.speechIntroduction.length>0) {
        _voiceView.voiceUrl = detailModel.speechIntroduction;
    }
    _usernameLabel.text = detailModel.customerNm;
    CGSize nameSize = [LKUtils sizeFit:_usernameLabel.text withUIFont:_usernameLabel.font withFitWidth:_bgIV.width-_avaterIV.right-(_voiceView.hidden?60:140) withFitHeight:_usernameLabel.height];
    _usernameLabel.width = nameSize.width;
    _voiceView.left = _usernameLabel.right+7;
    
    _locationLabel.text = detailModel.cityName;
    
    
    NSArray *nums = @[[NSString stringWithFormat:@"%ld",detailModel.serviceNum],[NSString stringWithFormat:@"%ld",detailModel.commentNum],[NSString stringValue:detailModel.starLevel],[NSString stringWithFormat:@"%ld",detailModel.collectionNum]];
    
    for (int i=0; i<4; i++) {
        LKUserDetailUserIconView *iconView = [_bgIV viewWithTag:200+i];
        iconView.num = nums[i];
    }
}

- (void)openPersonInfo{
    if ([_detailModel.customerNumber isEqualToString:[LKUserInfoUtils getUserNumber]]) {
        [LKMediator openPersonInfo:@""];

    }
}

- (void)playVoice {
    
}

@end



@implementation LKUserDetailUserIconView

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
        _topLabel.text = @"";
        [self addSubview:_topLabel];
        
        _bottomLabel = [UILabel new];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = [UIColor hexColorb4b4b4];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.frame = CGRectMake(0, _topLabel.bottom+13, self.width, ceil(_bottomLabel.font.lineHeight));
        _bottomLabel.text = @"";
        [self addSubview:_bottomLabel];
        
        self.height = _bottomLabel.bottom;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _bottomLabel.text = title;
}

- (void)setNum:(NSString *)num {
    _topLabel.text = num;
}

@end


