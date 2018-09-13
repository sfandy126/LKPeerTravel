//
//  LKSearchAnswerCell.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSearchAnswerCell.h"

@class LKSearchAnswerUserView;
@interface LKSearchAnswerCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentab;
@property (nonatomic,strong) UILabel *locationLab;
@property (nonatomic,strong) UIImageView *locationIcon;
@property (nonatomic,strong) LKSearchAnswerUserView *userView;
@end

@implementation LKSearchAnswerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    
    //标题
    _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.text = @"";
    _titleLab.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_titleLab];
    
    //内容
    _contentab = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentab.text = @"";
    _contentab.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_contentab];
    
    //定位
    _locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _locationLab.text = @"";
    _locationLab.backgroundColor = [UIColor clearColor];
    _locationLab.font = [UIFont boldSystemFontOfSize:12.0];
    _locationLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _locationLab.height = ceil(_locationLab.font.lineHeight);
    _locationLab.hidden = YES;
    [_bgView addSubview:_locationLab];
    
    _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 13)];
    _locationIcon.image = [UIImage imageNamed:@"img_guide_position"];
    _locationIcon.hidden = _locationLab.hidden;
    [_bgView addSubview:_locationIcon];
    
    
    //用户信息
    _userView = [[LKSearchAnswerUserView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_userView];
}

- (void)configData:(LKSearchAnswerModel *)item{
    
    _bgView.left = item.newesBgFrame.leftInval;
    _bgView.width = item.newesBgFrame.width;
    _bgView.height = item.newesBgFrame.height;
    
    //标题
    _titleLab.font = item.newesTitleFrame.font;
    _titleLab.text = item.title;
    _titleLab.left = item.newesTitleFrame.leftInval;
    _titleLab.top = item.newesTitleFrame.topInval;
    _titleLab.width = item.newesTitleFrame.width;
    _titleLab.height = item.newesTitleFrame.height;
    
    //正文
    _contentab.font = item.newestContentFrame.font;
    _contentab.text = item.content;
    _contentab.attributedText = item.contentAttri;
    _contentab.left = item.newestContentFrame.leftInval;
    _contentab.top = _titleLab.bottom +item.newestContentFrame.topInval;
    _contentab.width = item.newestContentFrame.width;
    _contentab.height = item.newestContentFrame.height;
    _contentab.numberOfLines = item.newestContentFrame.rowCount;
    _contentab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //定位
    _locationLab.hidden = _locationIcon.hidden = item.location.length==0;
    _locationLab.text = item.location;
    CGSize locationSize = [LKUtils sizeFit:_locationLab.text withUIFont:_locationLab.font withFitWidth:100 withFitHeight:_locationLab.height];
    _locationLab.width = locationSize.width;
    _locationLab.right = _bgView.width - 17;
    _locationLab.bottom = _titleLab.bottom;
    
    _locationIcon.right = _locationLab.left -4;
    _locationIcon.bottom = _locationLab.bottom;
    
    //用户信息
    _userView.top = _contentab.bottom +item.newestUserFrame.topInval;
    _userView.width = item.newestUserFrame.width;
    _userView.height = item.newestUserFrame.height;
    [_userView configData:item];
    
}

+ (CGFloat)getCellHeight:(LKSearchAnswerModel *)item{
    if (item) {
        return item.newestCellFrame.height;
    }
    return CGFLOAT_MIN;
}

@end


@interface LKSearchAnswerUserView ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UIImageView *lookIcon;
@property (nonatomic,strong) UILabel *lookLab;

@property (nonatomic,strong) UIImageView *commentIcon;
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation LKSearchAnswerUserView

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
    _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
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


- (void)configData:(LKSearchAnswerModel *)model{
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:model.face]] placeholderImage:nil];
    _nameLab.text = [NSString stringValue:model.nick_name];
    
    //回复
    _commentLab.text = [NSString stringValue:model.comments];
    _commentLab.font = model.commentFrame.font;
    _commentLab.width = model.commentFrame.width;
    _commentLab.height = model.commentFrame.height;
    _commentLab.right = self.width-10;
    
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


