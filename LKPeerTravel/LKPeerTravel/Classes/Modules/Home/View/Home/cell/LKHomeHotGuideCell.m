//
//  LKHomeHotGuideCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeHotGuideCell.h"
#import "LKAudioManager.h"
#import "LKHomeRightButView.h"
#import "LKVoiceView.h"

@class LKHomeHotGuideTagView,LKHomeHotGuideBottomView;
@interface LKHomeHotGuideCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *nickLab;
@property (nonatomic,strong) LKVoiceView *voiceView;

@property (nonatomic,strong) UIImageView *voiceIcon;
@property (nonatomic,strong) UILabel *voiceTimeLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) LKHomeHotGuideTagView *tagView;
@property (nonatomic,strong) LKHomeHotGuideBottomView *bottomView;

@property (nonatomic,strong) LKHomeGuideModel *model;
@end

@implementation LKHomeHotGuideCell

- (void)createView{
    [super createView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _bgView.layer.cornerRadius = 10.0;
    _bgView.layer.masksToBounds = YES;
    _bgView.clipsToBounds = YES;
    [self.contentView addSubview:_bgView];
    
    //头像
    _iconIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconIV.backgroundColor = [UIColor lightGrayColor];
    _iconIV.contentMode = UIViewContentModeScaleAspectFill;
    _iconIV.clipsToBounds = YES;
    [_bgView addSubview:_iconIV];
    
    //昵称
    _nickLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLab.backgroundColor = [UIColor clearColor];
    _nickLab.text = @"";
    _nickLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _nickLab.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_nickLab];
    
    //语音按钮
    _voiceView = [[LKVoiceView alloc] initWithFrame:CGRectMake(0, 0, 58, 18)];
    [_bgView addSubview:_voiceView];
        
    //内容
    _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLab.backgroundColor = [UIColor clearColor];
    _contentLab.text = @"";
    _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _contentLab.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_contentLab];
    
    //标签视图
    _tagView = [[LKHomeHotGuideTagView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_tagView];
    
    //底部试图(服务、评价、星级)
    _bottomView = [[LKHomeHotGuideBottomView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_bottomView];
}

- (void)configData:(id)data{
    [super configData:data];
    
    LKHomeGuideModel *model = (LKHomeGuideModel *)data;
    _model = model;
    
    _bgView.left = model.bgFrame.leftInval;
    _bgView.width = model.bgFrame.width;
    _bgView.height = model.bgFrame.height;
    
    //头像
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:model.face]] placeholderImage:nil];
    _iconIV.left = model.iconFrame.leftInval;
    _iconIV.top = model.iconFrame.topInval;
    _iconIV.width = _iconIV.height = model.iconFrame.width;
    _iconIV.layer.cornerRadius = _iconIV.width/2.0;
    _iconIV.layer.masksToBounds = YES;
    
    //昵称
    _nickLab.font = model.nameFrame.font;
    _nickLab.text = [NSString stringValue:model.nick_name];
    _nickLab.left = _iconIV.right + model.nameFrame.leftInval;
    _nickLab.top = model.nameFrame.topInval;
    _nickLab.height = model.nameFrame.height;
    _nickLab.width = model.nameFrame.width;
    
    //语音
    _voiceView.hidden = !model.isVoice;
    _voiceView.left = _nickLab.right+7;
    _voiceView.centerY = _nickLab.centerY;
    _voiceView.voiceUrl = model.voiceUrl;
    



    //正文(最多4行)
    _contentLab.text = [NSString stringValue:model.content];
    _contentLab.attributedText = model.contentAttri;
    _contentLab.font = model.contentFrame.font;
    _contentLab.left = _nickLab.left;
    _contentLab.top = _nickLab.bottom + model.contentFrame.topInval;
    _contentLab.width = model.contentFrame.width;
    _contentLab.height = model.contentFrame.height;
    _contentLab.numberOfLines = model.contentFrame.rowCount;
    _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //标签视图
    _tagView.hidden = [NSArray getArray:model.tags].count==0;
    _tagView.left = _contentLab.left;
    _tagView.top = _contentLab.bottom+ model.tagFrame.topInval;
    _tagView.width = model.tagFrame.width;
    _tagView.height = model.tagFrame.height;
    [_tagView configData:model.tags];
    
    ////底部试图(服务、评价、星级)
    _bottomView.left = _contentLab.left;
    _bottomView.top = _tagView.bottom +model.bottomFrame.topInval;
    _bottomView.width = model.bottomFrame.width;
    _bottomView.height = model.bottomFrame.height;
    [_bottomView configData:model];

    
}

+ (CGFloat)getCellHeight:(id)data{
    LKHomeGuideModel *item = (LKHomeGuideModel *)data;
    if (item) {
        return item.cellFrame.height;
    }
    return CGFLOAT_MIN;
}

- (void)startAnimation{
    _voiceIcon.animationImages = @[[UIImage imageNamed:@"btn_guide_voice_cartoon1"],
                                            [UIImage imageNamed:@"btn_guide_voice_cartoon2"],
                                            [UIImage imageNamed:@"btn_guide_voice_cartoon3"],
                                            [UIImage imageNamed:@"btn_guide_voice_cartoon4"]];
    _voiceIcon.animationRepeatCount=-1;
    _voiceIcon.animationDuration = 0.8;
    [_voiceIcon startAnimating];
}

- (void)stopAnimation{
    [_voiceIcon stopAnimating];
}

//播放语音
- (void)playVoice{
    [LKAudioManager share].audioArray = @[[NSString stringValue:self.model.voiceUrl]];
    [[LKAudioManager share] play];
    [LKAudioManager share].preparePlayBlock = ^{
        [self startAnimation];
    };
    [LKAudioManager share].playOverBlock = ^{
        [self stopAnimation];
    };
}



@end

@interface LKHomeHotGuideSection ()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKHomeRightButView *selectButView;

@end

@implementation LKHomeHotGuideSection


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 45)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 45)];
        _titleLab.text = @"热门导游";
        _titleLab.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [_contentView addSubview:_titleLab];
        
        _selectButView = [[LKHomeRightButView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _selectButView.right = _contentView.width-15;
        _selectButView.centerY = _titleLab.height/2;
        _selectButView.title = @"选择城市";
        _selectButView.image = [UIImage imageNamed:@"btn_home_position_1_none"];
        _selectButView.imageSize = CGSizeMake(38/3, 38/3);
        _selectButView.inval = 3;
        @weakify(self);
        _selectButView.selectedBlock = ^{
            @strongify(self);
            [self selectedButAction];
        };
        [_contentView addSubview:_selectButView];
    }
    return self;
}

- (void)setCity_name:(NSString *)city_name {
    _city_name = city_name;
    
    if ([NSString isNotEmptyStirng:city_name]) {
        _selectButView.title = city_name;
    } else {
        _selectButView.title = @"选择城市";
    }
}

- (void)selectedButAction{
    if (self.selectedLoctionBlock) {
        self.selectedLoctionBlock();
    }
}

@end

///标签view
@implementation LKHomeHotGuideTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        for (int i=0; i<4; i++) {
            UILabel *tagLab = [[UILabel alloc] init];
            tagLab.tag = 1000+i;
            tagLab.text = @"";
            tagLab.textAlignment = NSTextAlignmentCenter;
            tagLab.font = [UIFont systemFontOfSize:12.0];
            tagLab.backgroundColor = [UIColor colorWithHexString:@"#C8C7C7"];
            tagLab.textColor = [UIColor whiteColor];
            tagLab.height = 15.0;
            tagLab.layer.cornerRadius = 2.0;
            tagLab.layer.masksToBounds = YES;
            [self addSubview:tagLab];
        }
    }
    return self;
}

- (void)configData:(NSArray *)tags{
    CGFloat inval = 4.0;
    CGFloat preLeft = 0.0;
    NSInteger index= 0;
    for (NSString *tagStr in tags) {
        UILabel *tagLab = [self viewWithTag:1000+index];
        tagLab.text = [NSString stringValue:tagStr];
        CGSize size = [LKUtils sizeFit:tagLab.text withUIFont:tagLab.font withFitWidth:80 withFitHeight:tagLab.height];
        tagLab.width = size.width+10;
        tagLab.left = preLeft;
        preLeft += tagLab.width+inval;
        index++;
    }
}

@end

///底部view
@class LKHomeStarView;
@interface LKHomeHotGuideBottomView ()
@property (nonatomic,strong) UILabel *serverLab;
@property (nonatomic,strong) UILabel *evaluLab;
@property (nonatomic,strong) LKHomeStarView *starView;
@end

@implementation LKHomeHotGuideBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _serverLab = [[UILabel alloc] init];
        _serverLab.text = @"";
        _serverLab.font = [UIFont systemFontOfSize:10.0];
        _serverLab.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.6];
        _serverLab.height = ceil(_serverLab.font.lineHeight);
        [self addSubview:_serverLab];
        
        _evaluLab = [[UILabel alloc] init];
        _evaluLab.text = @"";
        _evaluLab.font = [UIFont systemFontOfSize:10.0];
        _evaluLab.textColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0.6];
        _evaluLab.height = ceil(_evaluLab.font.lineHeight);
        [self addSubview:_evaluLab];
        
        _starView = [[LKHomeStarView alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        [self addSubview:_starView];
    }
    return self;
}

- (void)configData:(LKHomeGuideModel *)model{
    _serverLab.text = [NSString stringWithFormat:@"已服务 %@",model.server_num];
    CGSize serSize = [LKUtils sizeFit:_serverLab.text withUIFont:_serverLab.font withFitWidth:100 withFitHeight:_serverLab.height];
    _serverLab.width = serSize.width;
    _serverLab.centerY = self.height/2.0;
    
    _evaluLab.text = [NSString stringWithFormat:@"评论 %@",model.comments];
    CGSize evlauSize = [LKUtils sizeFit:_evaluLab.text withUIFont:_evaluLab.font withFitWidth:100 withFitHeight:_evaluLab.height];
    _evaluLab.width = evlauSize.width;
    _evaluLab.centerY = _serverLab.centerY;
    _evaluLab.left = _serverLab.right +4;
    
    [_starView configData:model.star];
    _starView.centerY = self.height/2.0;
    _starView.right = self.width;
    
}

@end

@interface LKHomeStarView ()
@property (nonatomic,strong) UILabel *starLab;
@end

@implementation LKHomeStarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat lastLeft = 0;
        CGFloat inval = 2;
        for (int i=0; i<5; i++) {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 12)];
            icon.backgroundColor =[UIColor clearColor];
            icon.image = [self setIconState:0];
            icon.tag = 2000+i;
            icon.left = (icon.width+inval)*i;
            icon.centerY = self.height/2;
            [self addSubview:icon];
            lastLeft = icon.right;
        }
        
        _starLab = [[UILabel alloc] initWithFrame:CGRectMake(lastLeft+5, self.height/2, 25, 0)];
        _starLab.backgroundColor = [UIColor clearColor];
        _starLab.text = @"";
        _starLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _starLab.textAlignment = NSTextAlignmentCenter;
        _starLab.font = [UIFont boldSystemFontOfSize:12.0];
        _starLab.height = ceil(_starLab.font.lineHeight);
        [self addSubview:_starLab];
    }
    return self;
}

- (void)configData:(NSString *)star{
    CGFloat num = [[NSString stringValue:star] floatValue];
    if (num<=0) {
        return;
    }
    
    //每个为0.5,总计5分.
    for (int i=0; i<5; i++){
        UIImageView *icon = [self viewWithTag:2000+i];
        if (num<(i+1) && num>i) {
            icon.image = [self setIconState:0.5];
            break;
        }
        icon.image = [self setIconState:1];
    }
    
    _starLab.text = [NSString stringValue:[NSString stringWithFormat:@"%.1f",num]];
    _starLab.centerY = self.height/2;
}

- (UIImage *)setIconState:(CGFloat )state{
    UIImage *image =nil;
    if (state==1) {
        image = [UIImage imageNamed:@"img_guide_star1"];
    }else if (state==0.5) {
        image = [UIImage imageNamed:@"img_guide_star2"];
    }else{
        image = [UIImage imageNamed:@"img_guide_star_block"];
    }
    return image;
}

@end




