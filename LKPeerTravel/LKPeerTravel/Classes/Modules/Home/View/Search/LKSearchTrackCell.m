//
//  LKSearchTrackCell.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSearchTrackCell.h"

@interface LKSearchTrackUserView : UIView
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UIImageView *lookIcon;
@property (nonatomic,strong) UILabel *lookLab;

@property (nonatomic,strong) UIImageView *commentIcon;
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation LKSearchTrackUserView

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _icon.backgroundColor = [UIColor lightGrayColor];
        _icon.layer.cornerRadius = _icon.width/2.0;
        _icon.layer.masksToBounds = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)nameLab{
    if (!_nameLab){
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.text = @"";
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.font = kFont(10);
        _nameLab.width = 100;
        _nameLab.height = ceil(_nameLab.font.lineHeight);
    }
    return _nameLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.icon.left = 17;
        self.icon.centerY = self.height/2.0;
        [self addSubview:self.icon];
        
        self.nameLab.left = self.icon.right +6;
        self.nameLab.centerY = self.icon.centerY;
        [self addSubview:self.nameLab];
        
        //查看
        _lookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _lookIcon.image = [UIImage imageNamed:@"img_foot_look"];
        [self addSubview:_lookIcon];
        
        _lookLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _lookLab.backgroundColor = [UIColor clearColor];
        _lookLab.text = @"";
        _lookLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _lookLab.font = kFont(10);
        _lookLab.height = ceil(_lookLab.font.lineHeight);
        [self addSubview:_lookLab];
        
        //回复
        _commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _commentIcon.image = [UIImage imageNamed:@"img_foot_talk"];
        [self addSubview:_commentIcon];
        
        _commentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLab.backgroundColor = [UIColor clearColor];
        _commentLab.text = @"";
        _commentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _commentLab.font = kFont(10);
        _commentLab.height = ceil(_commentLab.font.lineHeight);
        [self addSubview:_commentLab];
        
    }
    return self;
}

- (void)configData:(LKSearchTrackModel *)item{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.portraitPic] placeholderImage:nil];
    self.nameLab.text = item.customerNm;
    
    self.lookIcon.left = self.nameLab.right + 5;
    self.lookLab.text = item.looks;
    CGSize lookSize = [LKUtils sizeFit:self.lookLab.text withUIFont:self.lookLab.font withFitWidth:100 withFitHeight:self.lookLab.height];
    self.lookLab.width = lookSize.width;
    self.lookLab.left = self.lookIcon.right +3;
    self.lookIcon.centerY = self.lookLab.centerY = self.icon.centerY;
    
    self.commentIcon.left = self.lookLab.right +4;
    self.commentLab.text=  item.comments;
    CGSize commentSize = [LKUtils sizeFit:self.commentLab.text withUIFont:self.commentLab.font withFitWidth:100 withFitHeight:self.commentLab.height];
    self.commentLab.width = commentSize.width;
    self.commentLab.left =self.commentIcon.right +3;
    self.commentIcon.centerY = self.commentLab.centerY = self.icon.centerY;
}


@end


@interface LKSearchTrackImageView : UIView

@end

@implementation LKSearchTrackImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat inval = 10;
        CGFloat iconWidth = 70;
        for (int i=0; i<4; i++) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
            icon.left = 17 +(iconWidth +inval)*i;
            icon.backgroundColor = [UIColor lightGrayColor];
            icon.contentMode = UIViewContentModeScaleAspectFill;
            icon.clipsToBounds = YES;
            icon.tag = 2000+i;
            [self addSubview:icon];
        }
    }
    return self;
}


- (void)configData:(LKSearchTrackModel *)item{
    NSArray *images = [NSArray getArray:item.cityImageList];
    for (int i=0; i<4; i++) {
        UIImageView *icon = [self viewWithTag:2000+i];
        NSDictionary *dic = [images objectAt:i];
        if ([NSDictionary isNotEmptyDict:dic]) {
            icon.hidden = NO;
            NSString *imageUrl = [NSString stringValue:[dic valueForKey:@"imageUrl"]];
            [icon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        }else{
            icon.hidden = YES;
        }
    }
}

@end

@interface LKSearchTrackCell ()
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKSearchTrackImageView *imageContentView;
@property (nonatomic,strong) LKSearchTrackUserView *userView;

@end


@implementation LKSearchTrackCell

- (UIView *)bgView{
    if (!_bgView) {
        CGFloat cellHeigth = [[self class] getCellHeight:nil];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth -20, cellHeigth)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.text = @"";
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = kBFont(16);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (LKSearchTrackImageView *)imageContentView{
    if (!_imageContentView) {
        _imageContentView = [[LKSearchTrackImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 70)];
    }
    return _imageContentView;
}

- (LKSearchTrackUserView *)userView{
    if (!_userView) {
        _userView = [[LKSearchTrackUserView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 20)];
    }
    return _userView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bgView];
        
        self.titleLab.top = 17;
        self.titleLab.left = 17;
        self.titleLab.width = self.bgView.width - 17*2;
        [self.bgView addSubview:self.titleLab];
        
        self.imageContentView.top = self.titleLab.bottom+10;
        [self.bgView addSubview:self.imageContentView];
        
        
        self.userView.bottom = self.bgView.height -16;
        [self.bgView addSubview:self.userView];
    }
    return self;
}


- (void)configData:(LKSearchTrackModel *)item{
    self.titleLab.text = item.footprintTitle;
    [self.imageContentView configData:item];
    [self.userView configData:item];
}

+(CGFloat)getCellHeight:(LKSearchTrackModel *)item{
    
    return 176;
}

@end
