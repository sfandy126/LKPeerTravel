//
//  LKSceneListCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/27.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSceneListCell.h"

@implementation LKSceneListCell

{
    UIView *_bgView;
    UIImageView *_picIV;
    UILabel *_titleLabel;
    UILabel *_descLabel;
    UIImageView *_footIV;
    UILabel *_footLabel;
    UIImageView *_selectIV;
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
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 116)];
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = kColorWhite;
    [self addSubview:_bgView];
    
//    [_bgView g_addTapWithTarget:self action:@selector(selectedAction)];
 
    
    _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 71, 71)];
    _picIV.layer.cornerRadius = 5;
    _picIV.layer.masksToBounds = YES;
    [_picIV sd_setImageWithURL:[NSURL URLWithString:@"http://b3-q.mafengwo.net/s5/M00/70/8B/wKgB3FEOOQqAZJedABM1IX8coHE28.jpeg"]];
    [_bgView addSubview:_picIV];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = kBFont(16);
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(_picIV.right+12, 15, _bgView.width-_picIV.right-120, ceil(_titleLabel.font.lineHeight));
    _titleLabel.text = @"维多利亚爱你";
    [_bgView addSubview:_titleLabel];
    
    _descLabel = [UILabel new];
    _descLabel.font = kFont(12);
    _descLabel.textColor = kColorGray1;
    _descLabel.frame = CGRectMake(_picIV.right+12, _titleLabel.bottom+13, _bgView.width-_picIV.right-12-62, ceil(_descLabel.font.lineHeight));
    _descLabel.text = @"维多利亚爱你维多利亚爱你维多利亚爱你维多利亚爱你维多利亚爱你维多利亚爱你维多利亚爱你维多利亚爱你多利亚爱你多利亚爱你";
    _descLabel.numberOfLines = 3;
    [_descLabel sizeToFit];
    [_bgView addSubview:_descLabel];
    
    _selectIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 18, 18)];
    _selectIV.image = [UIImage imageNamed:@"btn_service_determine_none"];
    _selectIV.right = _bgView.width-24;
    [_bgView addSubview:_selectIV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    btn.center = _selectIV.center;
    [btn addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:btn];
    
    _footLabel = [UILabel new];
    _footLabel.font = kBFont(12);
    _footLabel.textColor = kColorGray1;
    _footLabel.frame = CGRectMake(_picIV.right+12, 15, _bgView.width-_picIV.right-120, ceil(_footLabel.font.lineHeight));
    _footLabel.text = @"12";
    [_footLabel sizeToFit];
    _footLabel.right = _bgView.width-62;
    [_bgView addSubview:_footLabel];
    
    _footIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 12, 12)];
    _footIV.image = [UIImage imageNamed:@"img_service_foot"];
    _footIV.right = _footLabel.left-4;
    [_bgView addSubview:_footIV];
    _footIV.centerY = _footLabel.centerY = _titleLabel.centerY;
}

- (void)selectedAction {
    self.model.selectedState = !self.model.selectedState;
    
    _selectIV.image = [UIImage imageNamed:_model.selectedState?@"btn_service_determine_pressed":@"btn_service_determine_none"];
    
    if (self.selectSceneBlock) {
        self.selectSceneBlock(self.model);
    }
}

- (void)setModel:(LKSceneListModel *)model {
    _model = model;
    
    [_picIV sd_setImageWithURL:[NSURL URLWithString:model.codDestinationPointLogo]];
    _titleLabel.text = model.codDestinationPointName;
    _descLabel.text = model.txtDestinationPointDesc;
    
    _footLabel.text = [NSString stringWithFormat:@"%zd",model.footprint];
    
    _selectIV.image = [UIImage imageNamed:_model.selectedState?@"btn_service_determine_pressed":@"btn_service_determine_none"];

}

@end
