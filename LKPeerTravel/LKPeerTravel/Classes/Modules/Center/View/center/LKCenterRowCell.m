//
//  LKCenterRowCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterRowCell.h"

#import "LKCenterModel.h"

@implementation LKCenterRowCell

{
    UIImageView *_iconIV;
    UILabel *_titleLabel;
    UIImageView *_arrowIV;
    UILabel *_infoLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(24, 0, 22, 24)];
    _iconIV.image = [UIImage imageNamed:@"img_my_protocol"];
    _iconIV.centerY = 50*0.5;
    [self.contentView addSubview:_iconIV];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _titleLabel.textColor = [UIColor hexColor333333];
    _titleLabel.frame = CGRectMake(_iconIV.right+18, 0, 100, ceil(_titleLabel.font.lineHeight));
    _titleLabel.text = @"服务协议";
    _titleLabel.centerY = _iconIV.centerY;
    [self.contentView addSubview:_titleLabel];
    
    _arrowIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_into_none"]];
    _arrowIV.centerY = _iconIV.centerY;
    _arrowIV.right = self.width-15;
    [self.contentView addSubview:_arrowIV];
    
    _infoLabel = [UILabel new];
    _infoLabel.font = [UIFont systemFontOfSize:12.0];
    _infoLabel.textColor = [UIColor hexColorb4b4b4];
    _infoLabel.frame = CGRectMake(0, 0, 100, ceil(_titleLabel.font.lineHeight));
    _infoLabel.textAlignment = NSTextAlignmentRight;
    _infoLabel.text = @"去发布";
    _infoLabel.right = _arrowIV.left-6;
    _infoLabel.centerY = _iconIV.centerY;
    [self.contentView addSubview:_infoLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _arrowIV.right = self.width-15;
    _infoLabel.right= _arrowIV.left-6;
    
    if (_rowModel.rowType==LKCenterRowType_inviteCode) {
        _infoLabel.right = self.width-15;
    }
}

- (void)setRowModel:(LKCenterRowModel *)rowModel {
    _rowModel = rowModel;
    
    _iconIV.image = [UIImage imageNamed:rowModel.icon];
    _titleLabel.text = rowModel.title;
    _infoLabel.text = rowModel.desc;
    
    _arrowIV.hidden = NO;
    _infoLabel.textColor = [UIColor hexColorb4b4b4];
    
    if (rowModel.rowType==LKCenterRowType_inviteCode) {
        _arrowIV.hidden = YES;
        _infoLabel.textColor = kColorBlue1;
    }
}

@end
