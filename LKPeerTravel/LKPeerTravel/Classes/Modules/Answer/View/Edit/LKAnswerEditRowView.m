//
//  LKAnswerEditRowView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerEditRowView.h"

#import "SevenSwitch.h"

@implementation LKAnswerEditRowView

{
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UIImageView *_arrowIV;
    SevenSwitch *_sevenSwitch;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(20, 0, 100, 50);
    [self addSubview:_titleLabel];
    
    _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_into_none"]];
    _arrowIV.right = kScreenWidth-16;
    _arrowIV.centerY = 50*0.5;
    [self addSubview:_arrowIV];
    
    _descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.textColor = kColorGray2;
    _descLabel.frame = CGRectMake(20, 0, 200, 50);
    _descLabel.right = _arrowIV.left-13;
    _descLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_descLabel];
    
    SevenSwitch *offerEnableSwitch = [[SevenSwitch alloc] initWithFrame: CGRectMake(0,0, 55, 32)];
    offerEnableSwitch.thumbTintColor = [UIColor clearColor];
    offerEnableSwitch.activeColor = [UIColor clearColor];
    offerEnableSwitch.inactiveColor = [UIColor clearColor];
    offerEnableSwitch.onTintColor = [UIColor clearColor];
    offerEnableSwitch.borderColor = [UIColor clearColor];
    offerEnableSwitch.shadowColor = [UIColor clearColor];
    offerEnableSwitch.onImageView.image = [UIImage imageNamed:@"btn_service_switch_on"];
    offerEnableSwitch.onImageView.contentMode = UIViewContentModeScaleAspectFill;
    offerEnableSwitch.offImageView.image = [UIImage imageNamed:@"btn_service_switch_off"];
    offerEnableSwitch.offImageView.contentMode = UIViewContentModeScaleAspectFill;
    [offerEnableSwitch addTarget:self action:@selector(switchValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    offerEnableSwitch.right = kScreenWidth - 15;
    offerEnableSwitch.centerY = 50 * 0.5;
    [self addSubview:offerEnableSwitch];
    _sevenSwitch = offerEnableSwitch;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 0.5)];
    line.backgroundColor = kColorLine1;
    [self addSubview:line];
    line.bottom = 0;
}

- (void)setShowSwitch:(BOOL)showSwitch {
    _showSwitch = showSwitch;
    
    if (showSwitch) {
        _sevenSwitch.hidden = NO;
        
        _arrowIV.hidden = YES;
        _descLabel.hidden = YES;
    } else {
        _sevenSwitch.hidden = YES;
        
        _arrowIV.hidden = NO;
        _descLabel.hidden = NO;
    }
    
    _titleLabel.text = self.title;
    _descLabel.text = self.desc;
}

- (void)switchValueDidChanged:(SevenSwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

@end
