//
//  LKAnswerDetailHeaderView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerDetailHeaderView.h"

@implementation LKAnswerDetailHeaderView

{
    UILabel *_titleLabel;
    
    UILabel *_locationLab;
    UIImageView *_locationIcon;
    
    UILabel *_contentLabel;
    UIImageView *_avaterIV;
    UILabel *_nicknameLabel;
    UILabel *_timeLabel;
    
    UILabel *_commentLabel;
    UIImageView *_commentIV;
    
    UILabel *_seeLabel;
    UIImageView *_seeIV;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = kBFont(18);
        _titleLabel.textColor = kColorGray1;
        _titleLabel.frame = CGRectMake(20, 50, self.width-40, ceil(_titleLabel.font.lineHeight));
        _titleLabel.text = @"";
        [self addSubview:_titleLabel];
        
        //定位
        _locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationLab.text = @"";
        _locationLab.backgroundColor = [UIColor clearColor];
        _locationLab.font = kBFont(14);
        _locationLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _locationLab.height = ceil(_locationLab.font.lineHeight);
        _locationLab.top = 50;
        [self addSubview:_locationLab];
        
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 13)];
        _locationIcon.image = [UIImage imageNamed:@"img_guide_position"];
        [self addSubview:_locationIcon];
        
        _contentLabel = [UILabel new];
        _contentLabel.font = kFont(14);
        _contentLabel.textColor = kColorGray1;
        _contentLabel.frame = CGRectMake(20, _titleLabel.bottom+24, self.width-40, ceil(_contentLabel.font.lineHeight));
        _contentLabel.text = @"";
        [self addSubview:_contentLabel];
        
        _avaterIV = [UIImageView new];
        _avaterIV.frame = CGRectMake(20, _contentLabel.bottom+40, 40, 40);
        _avaterIV.layer.cornerRadius = _avaterIV.height*0.5;
        _avaterIV.layer.masksToBounds = YES;
        _avaterIV.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_avaterIV];
        
        _nicknameLabel = [UILabel new];
        _nicknameLabel.font = kFont(14);
        _nicknameLabel.textColor = kColorGray1;
        _nicknameLabel.frame = CGRectMake(_avaterIV.right+10, _avaterIV.top, self.width-100, ceil(_nicknameLabel.font.lineHeight));
        _nicknameLabel.text = @"";
        [self addSubview:_nicknameLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = kFont(10);
        _timeLabel.textColor = kColorGray3;
        _timeLabel.frame = CGRectMake(_nicknameLabel.left, _nicknameLabel.bottom+10, self.width-100, ceil(_timeLabel.font.lineHeight));
        _timeLabel.text = @"";
        [self addSubview:_timeLabel];
        
 
        
        //回复
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.text = @"";
        _commentLabel.font = kFont(10);
        _commentLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _commentLabel.height = ceil(_commentLabel.font.lineHeight);
        [self addSubview:_commentLabel];
        
        _commentIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _commentIV.image = [UIImage imageNamed:@"img_foot_talk"];
        [self addSubview:_commentIV];
        
    
        
        //查看
        _seeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _seeLabel.backgroundColor = [UIColor clearColor];
        _seeLabel.text = @"";
        _seeLabel.font = kFont(10);
        _seeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _seeLabel.height = ceil(_seeLabel.font.lineHeight);
        [self addSubview:_seeLabel];
        
        _seeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _seeIV.image = [UIImage imageNamed:@"img_foot_look"];
        [self addSubview:_seeIV];
        
        _seeIV.centerY = _seeLabel.centerY = _commentIV.centerY = _commentLabel.centerY = _timeLabel.centerY;
        
        self.height = _timeLabel.bottom+20;
    }
    return self;
}

- (void)configData:(LKAnswerSingleModel *)model{
    _titleLabel.text = model.title;
    
    _locationLab.text = model.location;
    _locationIcon.hidden = (_locationLab.text.length==0);
    if (!_locationLab.hidden) {
        CGSize locationSize = [LKUtils sizeFit:_locationLab.text withUIFont:_locationLab.font withFitWidth:100 withFitHeight:_locationLab.height];
        _locationLab.width = locationSize.width;
        _locationLab.right = kScreenWidth - 20;
        _locationIcon.right = _locationLab.left-5;
        _locationIcon.centerY = _locationLab.centerY;
    }
    
    _contentLabel.text = model.content;
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3.0;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
        [attri addAttributes:@{NSFontAttributeName : _contentLabel.font,
                               NSParagraphStyleAttributeName:style
                               } range:NSMakeRange(0, attri.length)];
        _contentLabel.attributedText = attri;
    }
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];

    [_avaterIV sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:nil];
    
    _nicknameLabel.text = model.nick_name;
    
    _timeLabel.text = model.datCreate;
    
    _commentLabel.text = model.comments.length==0?@"0":model.comments;
    CGSize commentSize = [LKUtils sizeFit:_commentLabel.text withUIFont:_commentLabel.font withFitWidth:80 withFitHeight:_commentLabel.height];
    _commentLabel.width = commentSize.width;
    _commentLabel.right = kScreenWidth-20;
    _commentIV.right = _commentLabel.left-5;
    
    _seeLabel.text = model.looks.length==0?@"0":model.looks;
    CGSize seeSize = [LKUtils sizeFit:_seeLabel.text withUIFont:_seeLabel.font withFitWidth:80 withFitHeight:_seeLabel.height];
    _seeLabel.width = seeSize.width;
    _seeLabel.right = _commentIV.left -10;
    _seeIV.right = _seeLabel.left-5;

}


@end
