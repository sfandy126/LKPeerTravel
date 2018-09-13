//
//  LKSendTrackAddCollectionViewCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackAddCollectionViewCell.h"

@interface LKSendTrackAddCollectionViewCell ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *contentLab;

@property (nonatomic,strong) UIImageView *addIcon;
@property (nonatomic,strong) UILabel *addLab;


@end

@implementation LKSendTrackAddCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        //图片
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconIV.backgroundColor = [UIColor clearColor];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        
        
        //内容
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_contentLab];
        
        _addIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _addIcon.backgroundColor = [UIColor clearColor];
        _addIcon.image = [UIImage imageNamed:@"btn_foot_plus_none"];
        _addIcon.contentMode = UIViewContentModeScaleAspectFill;
        _addIcon.clipsToBounds = YES;
        [self.contentView addSubview:_addIcon];
        
        _addLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _addLab.backgroundColor = [UIColor clearColor];
        _addLab.text = @"添加图片";
        _addLab.font = kBFont(12);
        _addLab.textColor = [UIColor colorWithHexString:@"#dcdcdc"];
        _addLab.textAlignment = NSTextAlignmentCenter;
        _addLab.width = 60;
        _addLab.height = ceil(_addLab.font.lineHeight);
        [self.contentView addSubview:_addLab];
        
    }
    return self;
}

- (void)configData:(LKSendTrackAddModel *)item{
    _iconIV.hidden = YES;
    _contentLab.hidden = YES;
    _addIcon.hidden = YES;
    _addLab.hidden = YES;
    if (item.is_add) {
        _addIcon.hidden = NO;
        _addLab.hidden = NO;

        _addIcon.top = 45;
        _addIcon.centerX = self.width/2.0;
        _addLab.top = _addIcon.bottom +15;
        _addLab.centerX = _addIcon.centerX;
        
    }else{
        //icon
        _iconIV.hidden = NO;
        if (item.city_image) {
            _iconIV.image = item.city_image;
        }else{
            [_iconIV sd_setImageWithURL:[NSURL URLWithString:item.city_icon] placeholderImage:nil];
        }
        _iconIV.width = self.width;//model.iconFrame.width;
        _iconIV.height = item.iconFrame.height;
        
        //正文
        _contentLab.hidden = NO;
        _contentLab.text = [NSString stringValue:item.content];
        _contentLab.attributedText = item.contentAttri;
        _contentLab.font = item.contentFrame.font;
        _contentLab.top = _iconIV.bottom + item.contentFrame.topInval;
        _contentLab.left = item.contentFrame.leftInval;
        _contentLab.width = item.contentFrame.width;
        _contentLab.height = item.contentFrame.height;
        _contentLab.numberOfLines = item.contentFrame.rowCount;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
}

@end
