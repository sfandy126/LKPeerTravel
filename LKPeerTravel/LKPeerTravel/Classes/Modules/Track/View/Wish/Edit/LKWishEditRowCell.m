//
//  LKWishEditRowCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishEditRowCell.h"
#import "SevenSwitch.h"

@implementation LKWishEditRowCell

{
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UIImageView *_arrowIV;
    SevenSwitch *_sevenSwitch;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(20, 0, 200, 50);
    [self.contentView addSubview:_titleLabel];
    
    _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_into_none"]];
    _arrowIV.right = kScreenWidth-16;
    _arrowIV.centerY = 50*0.5;
    [self.contentView addSubview:_arrowIV];
    
    _descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:14];
    _descLabel.textColor = kColorGray2;
    _descLabel.frame = CGRectMake(20, 0, 200, 50);
    _descLabel.right = _arrowIV.left-13;
    _descLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_descLabel];
    
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
    [self.contentView addSubview:offerEnableSwitch];
    _sevenSwitch = offerEnableSwitch;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.left, 0, kScreenWidth-_titleLabel.left, 0.5)];
    line.backgroundColor = kColorLine1;
    [self.contentView addSubview:line];
    line.bottom = 50;
}

- (void)setModel:(LKWishEditRowModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _descLabel.text = model.desc;
    
    if (model.showSwitch) {
        _sevenSwitch.hidden = NO;
        _sevenSwitch.on = model.switchState;
        
        _arrowIV.hidden = YES;
        _descLabel.hidden = YES;
    }
    
    if (model.showArrow) {
        _sevenSwitch.hidden = YES;
        
        _descLabel.hidden = NO;
        _arrowIV.hidden = NO;
    }
    
    if (!model.showArrow && !model.showSwitch) {
        _sevenSwitch.hidden = YES;
        
        _descLabel.hidden = YES;
        _arrowIV.hidden = YES;
    }
}

- (void)switchValueDidChanged:(SevenSwitch *)sender {
    if (self.switchValueChanged) {
        self.switchValueChanged(sender.on,self.model);
    }
}

@end
