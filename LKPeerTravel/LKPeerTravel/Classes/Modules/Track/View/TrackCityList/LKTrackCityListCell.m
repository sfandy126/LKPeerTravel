//
//  LKTrackCityListCell.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackCityListCell.h"

@class LKTrackCityLooksView;

@interface LKTrackCityListCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *cityLab;
@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) LKTrackCityLooksView *looksView;

@property (nonatomic,strong) UIImageView *alpheView;

@end

@implementation LKTrackCityListCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth -20, 156)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 156, 156)];
        _icon.backgroundColor = [UIColor lightGrayColor];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
    }
    return _icon;
}

- (UILabel *)cityLab{
    if (!_cityLab) {
        _cityLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _cityLab.backgroundColor = [UIColor clearColor];
        _cityLab.text = @"";
        _cityLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _cityLab.font = kBFont(18);
        _cityLab.height = ceil(_cityLab.font.lineHeight);
        _cityLab.width = 100;
    }
    return _cityLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _contentLab.font = kFont(12);
        _contentLab.numberOfLines = 2;
    }
    return _contentLab;
}

- (LKTrackCityLooksView *)looksView{
    if (!_looksView) {
        _looksView = [[LKTrackCityLooksView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width - self.icon.right, 15)];
    }
    return _looksView;
}

- (UIImageView *)alpheView{
    if (!_alpheView) {
        _alpheView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.bgView.height)];
        UIImage *image = [UIImage imageNamed:@"img_city_pic_block2"];
        _alpheView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 15, 10)];
    }
    return _alpheView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.bgView];
        
        [self.bgView addSubview:self.icon];
        
        self.cityLab.left = self.icon.right +5;
        self.cityLab.top = 15;
        [self.bgView addSubview:self.cityLab];
        
        self.contentLab.left = self.cityLab.left;
        self.contentLab.top = self.cityLab.bottom +17;
        [self.bgView addSubview:self.contentLab];
        
        //用户头像
        CGFloat inval = 3;
        CGFloat faceWidth = 20;
        for (int i=0; i<5 ; i++) {
            UIImageView *faceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, faceWidth, faceWidth)];
            faceIcon.backgroundColor = [UIColor lightGrayColor];
            faceIcon.contentMode = UIViewContentModeScaleAspectFit;
            faceIcon.clipsToBounds = YES;
            faceIcon.layer.cornerRadius = faceIcon.width/2.0;
            faceIcon.layer.masksToBounds = YES;
            faceIcon.right = self.bgView.width-10 -(faceWidth +inval)*i;
            faceIcon.centerY = self.cityLab.centerY;
            faceIcon.tag = 1000+i;
            faceIcon.hidden = YES;
            [self.bgView addSubview:faceIcon];
        }
        
        self.looksView.right = self.bgView.width -10;
        self.looksView.bottom = self.bgView.height-10;
        [self.bgView addSubview:self.looksView];
        
        self.alpheView.right = self.icon.right;
        [self.bgView addSubview:self.alpheView];
    }
    return self;
}

- (void)configData:(LKTrackCityListItemModel *)item{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.cityImagesUrl] placeholderImage:nil];
    self.cityLab.text = item.cityNm;
    self.contentLab.text = item.cityDesc;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:item.cityDesc];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attri addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attri.length)];
    self.contentLab.attributedText = attri;
    self.contentLab.width = self.bgView.width - self.contentLab.left-5;
    CGSize contentSize = [LKUtils sizeAttributedString:attri withUIFont:self.contentLab.font withFitWidth:self.contentLab.width withFitHeight:1000];
    self.contentLab.height = ceil(self.contentLab.font.lineHeight);
    if (contentSize.height>self.contentLab.height+style.lineSpacing) {
        self.contentLab.height = ceil(self.contentLab.font.lineHeight)*2 +style.lineSpacing;
    }
    
    NSArray *users = [NSArray getArray:item.userFaces];
    NSInteger index=0;
    for (NSString *face in users) {
        UIImageView *faceIcon = [self.bgView viewWithTag:1000+index];
        if (faceIcon) {
            faceIcon.hidden = NO;
            [faceIcon sd_setImageWithURL:[NSURL URLWithString:face] placeholderImage:nil];
        }
        index++;
    }
    
    [self.looksView configData:item];
}

@end

@interface LKTrackCityLooksView ()

@property (nonatomic,strong) UIImageView *footIcon;
@property (nonatomic,strong) UILabel *footLab;

@property (nonatomic,strong) UIImageView *lookIcon;
@property (nonatomic,strong) UILabel *lookLab;

@property (nonatomic,strong) UIImageView *commentIcon;
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation LKTrackCityLooksView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //足迹
        _footIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _footIcon.image = [UIImage imageNamed:@"img_city_foot"];
        _footIcon.contentMode = UIViewContentModeScaleAspectFit;
        _footIcon.clipsToBounds = YES;
        [self addSubview:_footIcon];
        
        _footLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _footLab.backgroundColor = [UIColor clearColor];
        _footLab.text = @"";
        _footLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _footLab.font = kFont(10);
        _footLab.height = ceil(_footLab.font.lineHeight);
        [self addSubview:_footLab];
        
        //查看
        _lookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        _lookIcon.image = [UIImage imageNamed:@"img_foot_look"];
        _lookIcon.contentMode = UIViewContentModeScaleAspectFit;
        _lookIcon.clipsToBounds = YES;
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
        _commentIcon.contentMode = UIViewContentModeScaleAspectFit;
        _commentIcon.clipsToBounds = YES;
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

- (void)configData:(LKTrackCityListItemModel *)model{
    CGFloat inval = 3;//回复数量与回复icon之间的间隙
    CGFloat iconInval = 4;//回复与查看之间的间隙
    //回复
    _commentLab.text = [NSString stringValue:model.comments];
    CGSize commentSize = [LKUtils sizeFit:_commentLab.text withUIFont:_commentLab.font withFitWidth:60 withFitHeight:_commentLab.height];
    _commentLab.width = commentSize.width;
    _commentLab.right = self.width;
    
    _commentIcon.right = _commentLab.left - inval;
    
    //查看
    _lookLab.text = [NSString stringValue:model.looks];
    CGSize lookSize = [LKUtils sizeFit:_lookLab.text withUIFont:_lookLab.font withFitWidth:60 withFitHeight:_lookLab.height];
    _lookLab.width = lookSize.width;
    _lookLab.right = _commentIcon.left -iconInval;
    
    _lookIcon.right = _lookLab.left - inval;
    
    //足迹
    _footLab.text = [NSString stringValue:model.footNum];
    CGSize footSize = [LKUtils sizeFit:_footLab.text withUIFont:_footLab.font withFitWidth:60 withFitHeight:_footLab.height];
    _footLab.width = footSize.width;
    _footLab.right = _lookIcon.left -iconInval;
    
    _footIcon.right = _footLab.left - inval;
    
    _commentIcon.centerY = _commentLab.centerY = self.height/2.0;
    _lookIcon.centerY = _lookLab.centerY = self.height/2.0;;
    _footIcon.centerY = _footLab.centerY = self.height/2.0;;

}

@end
