//
//  LKSceneDetailCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSceneDetailCell.h"

@implementation LKSceneDetailCell

{
    UILabel *_titleLabel;
    UIImageView *_picIV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 200)];
    _picIV.userInteractionEnabled = YES;
    [self.contentView addSubview:_picIV];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(20, _picIV.bottom+20, kScreenWidth-20, ceil(_titleLabel.font.lineHeight));
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
}

- (void)setPicModel:(LKSceneDetailPicModel *)picModel {
    _picModel = picModel;
    
    CGFloat top = 20;
    _picIV.hidden = YES;
    _titleLabel.hidden = YES;
    
    if (picModel.codImageUrl.length) {
        _picIV.height = (kScreenWidth-40)*picModel.pic_height / picModel.pic_width;
        [_picIV sd_setImageWithURL:[NSURL URLWithString:picModel.codImageUrl]];
        _picIV.hidden = NO;
        top = _picIV.bottom+20;
    }
    if (picModel.txtImageDesc.length) {
        _titleLabel.height = picModel.test_height;
        _titleLabel.top = top;
        _titleLabel.text = picModel.txtImageDesc;
        _titleLabel.hidden = NO;
    }
}


@end
