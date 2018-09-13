//
//  LKTrackCityCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackCityCell.h"

@class LKTrackUserView;
@interface LKTrackCityCell ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) LKTrackUserView *userView;

@end

@implementation LKTrackCityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        [self createView];
    }
    return self;
}

- (void)createView{
    //icon
    _iconIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconIV.backgroundColor = [UIColor lightGrayColor];
    _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    _iconIV.clipsToBounds = YES;
    [self.contentView addSubview:_iconIV];
    
    //内容
    _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.text = @"";
    _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_contentLab];
    
    //用户信息
    _userView = [[LKTrackUserView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userView];
}


- (void)configData:(LKTrackCityModel *)model{
    //icon
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:model.city_icon] placeholderImage:nil];
    _iconIV.width = self.width;//model.iconFrame.width;
    _iconIV.height = model.iconFrame.height;
    
    //正文
    _contentLab.text = [NSString stringValue:model.content];
    _contentLab.attributedText = model.contentAttri;
    _contentLab.font = model.contentFrame.font;
    _contentLab.top = _iconIV.bottom + model.contentFrame.topInval;
    _contentLab.left = model.contentFrame.leftInval;
    _contentLab.width = model.contentFrame.width;
    _contentLab.height = model.contentFrame.height;
    _contentLab.numberOfLines = model.contentFrame.rowCount;
    _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //用户信息
    _userView.top = _contentLab.bottom +model.userFrame.topInval;
    _userView.left = model.userFrame.leftInval;
    _userView.width = model.userFrame.width;
    _userView.height = model.userFrame.height;
    [_userView configData:model];

}

@end


@interface LKTrackUserView ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UIImageView *lookIcon;
@property (nonatomic,strong) UILabel *lookLab;

@property (nonatomic,strong) UIImageView *commentIcon;
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation LKTrackUserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    //头像
    _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _iconIV.backgroundColor = [UIColor lightGrayColor];
    _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    _iconIV.layer.cornerRadius = _iconIV.width/2.0;
    _iconIV.layer.masksToBounds = YES;
    _iconIV.clipsToBounds = YES;
    [self addSubview:_iconIV];
    
    //昵称
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 0)];
    _nameLab.backgroundColor = [UIColor clearColor];
    _nameLab.text = @"";
    _nameLab.font = [UIFont systemFontOfSize:10.0];
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLab.height = ceil(_nameLab.font.lineHeight);
    _nameLab.left = _iconIV.right +6;
    [self addSubview:_nameLab];
    
    //查看
    _lookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _lookIcon.image = [UIImage imageNamed:@"img_foot_look"];
    [self addSubview:_lookIcon];
    
    _lookLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _lookLab.backgroundColor = [UIColor clearColor];
    _lookLab.text = @"";
    _lookLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:_lookLab];
    
    //回复
    _commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _commentIcon.image = [UIImage imageNamed:@"img_foot_talk"];
    [self addSubview:_commentIcon];
    
    _commentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLab.backgroundColor = [UIColor clearColor];
    _commentLab.text = @"";
    _commentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:_commentLab];
}


- (void)configData:(LKTrackCityModel *)model{
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:model.face]] placeholderImage:nil];
    _nameLab.text = [NSString stringValue:model.nick_name];
    
    //回复
    _commentLab.text = [NSString stringValue:model.comments];
    _commentLab.font = model.commentFrame.font;
    _commentLab.width = model.commentFrame.width;
    _commentLab.height = model.commentFrame.height;
    _commentLab.right = self.width;
    
    _commentIcon.right = _commentLab.left - model.commentFrame.leftInval;
    
    //查看
    _lookLab.text = [NSString stringValue:model.looks];
    _lookLab.font = model.lookFrame.font;
    _lookLab.width = model.lookFrame.width;
    _lookLab.height = model.lookFrame.height;
    _lookLab.right = _commentIcon.left -4.0;
    
    _lookIcon.right = _lookLab.left - model.lookFrame.leftInval;
    
    _iconIV.centerY = _nameLab.centerY = self.height/2.0;
    _commentIcon.centerY = _commentLab.centerY = self.height/2.0;
    _lookIcon.centerY = _lookLab.centerY = self.height/2.0;;
    
}

@end





