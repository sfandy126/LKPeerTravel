//
//  LKCityListCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCityListCell.h"



@implementation LKCityListCell

{
    UIView *_bgView;
    UIImageView *_picIV;
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UILabel *_numLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = TableBackgroundColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-12, 150)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    
    _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 158, 150)];
    _picIV.backgroundColor = [UIColor lightGrayColor];
    _picIV.contentMode = UIViewContentModeScaleToFill;
    [_bgView addSubview:_picIV];
    
    UIImageView *leftShare = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"img_city_pic_block"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    leftShare.frame = CGRectMake(0, 0, 50, 150);
    [_bgView addSubview:leftShare];
    
    UIImageView *rightShare = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"img_city_pic_block2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch]];
    rightShare.frame = CGRectMake(0, 0, 50, 150);
    rightShare.right = _picIV.width+15;
    [_bgView addSubview:rightShare];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = kBFont(18);
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(_picIV.right+8, 15, _bgView.width-_picIV.width-20, ceil(_titleLabel.font.lineHeight));
    _titleLabel.text = @"";
    [_bgView addSubview:_titleLabel];
    
    _descLabel = [UILabel new];
    _descLabel.font = kFont(12);
    _descLabel.textColor = kColorGray1;
    _descLabel.frame = CGRectMake(_picIV.right+8, _titleLabel.bottom+15, _bgView.width-_picIV.width-20, ceil(_descLabel.font.lineHeight));
    _descLabel.text = @"";
    _descLabel.numberOfLines = 3;
    [_descLabel sizeToFit];
    [_bgView addSubview:_descLabel];
    
    _numLabel = [UILabel new];
    _numLabel.font = kFont(10);
    _numLabel.textColor = kColorGray1;
    _numLabel.frame = CGRectMake(_picIV.right+8, 15, _bgView.width-_picIV.width-20, ceil(_numLabel.font.lineHeight));
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.text = @"";
    _numLabel.right = _bgView.width-18;
    _numLabel.bottom = _bgView.height-15;
    [_bgView addSubview:_numLabel];
}

- (void)configData:(LKHomeCityItemModel *)model{
    [_picIV sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    _titleLabel.text = model.cityName;
    _descLabel.text = model.cityDesc;
    _descLabel.width = _bgView.width-_picIV.width-20;
    [_descLabel sizeToFit];
    _numLabel.text = [NSString stringWithFormat:@"私人助手 %@  心愿单 %@",model.guideNum,model.wishNum];
}

@end
