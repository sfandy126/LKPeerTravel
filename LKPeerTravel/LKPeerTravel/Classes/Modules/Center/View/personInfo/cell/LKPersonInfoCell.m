//
//  LKPersonInfoCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPersonInfoCell.h"
#import "LKAudioManager.h"

@interface LKPersonInfoCell ()
@property (nonatomic,strong) UIView *topLine;

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *arrowIcon;

///头像
@property (nonatomic,strong) UIImageView *faceIcon;

///内容
@property (nonatomic,strong) UILabel *contentLab;

///语音
@property (nonatomic,strong) UIImageView *voiceIcon;

///自我介绍
@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) LKCenterModel *model;

@end

@implementation LKPersonInfoCell

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 0.5)];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    }
    return _topLine;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.text = @"";
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.font = kBFont(14);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
        _titleLab.left = 20;
    }
    return _titleLab;
}

- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_into_none"]];
        _arrowIcon.right = kScreenWidth - 16;
    }
    return _arrowIcon;
}

- (UIImageView *)faceIcon{
    if (!_faceIcon) {
        _faceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _faceIcon.backgroundColor = [UIColor lightGrayColor];
        _faceIcon.layer.cornerRadius = _faceIcon.width/2.0;
        _faceIcon.layer.masksToBounds = YES;
        _faceIcon.contentMode = UIViewContentModeScaleAspectFit;
        _faceIcon.clipsToBounds = YES;
    }
    return _faceIcon;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _contentLab.font = kFont(14);
        _contentLab.textAlignment = NSTextAlignmentRight;
        _contentLab.height = ceil(_contentLab.font.lineHeight);
    }
    return _contentLab;
}

- (UIImageView *)voiceIcon{
    if (!_voiceIcon) {
        _voiceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 18)];
        _voiceIcon.backgroundColor = [UIColor clearColor];
        _voiceIcon.image = [UIImage imageNamed:@"btn_guide_voice_none"];
        [_voiceIcon g_addTapWithTarget:self action:@selector(playVoice)];
    }
    return _voiceIcon;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20*2, 100)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.showsVerticalScrollIndicator = YES;
        _textView.editable = NO;
        _textView.text = @"";
        _textView.font = kFont(14);
        _textView.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _textView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =[UIColor colorWithHexString:@"#ffffff"];
        
        [self.contentView addSubview:self.topLine];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.arrowIcon];
        [self.contentView addSubview:self.faceIcon];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.textView];
        [self.contentView addSubview:self.voiceIcon];
    }
    return self;
}

- (void)configData:(LKCenterModel *)model indexPath:(NSIndexPath *)indexPath{
    self.model = model;
    CGFloat cellHeight = [[self class] getCellHeight:model indexPath:indexPath];
    NSArray *titles = @[@[@"头像",@"姓名",@"性别",@"年龄",@"职业",@"语言",@"城市"],@[@"特长爱好",@"语音介绍",@"自我介绍"]];
    if (model.customerType.integerValue==1) { // 下游
        titles = @[@[@"头像",@"姓名",@"性别",@"年龄",@"语言",@"城市"]];
    }
    NSArray *sections = [titles objectAt:indexPath.section];
    self.titleLab.text = [NSString stringValue:[sections objectAt:indexPath.row]];
    CGSize titleSize = [LKUtils sizeFit:self.titleLab.text withUIFont:self.titleLab.font withFitWidth:100 withFitHeight:self.titleLab.height];
    self.titleLab.width = titleSize.width;
    self.titleLab.centerY = cellHeight/2.0;
    
    self.arrowIcon.centerY = self.titleLab.centerY;
    
    self.faceIcon.hidden = YES;
    self.contentLab.hidden = YES;
    self.textView.hidden = YES;
    self.topLine.hidden = indexPath.row==0;
    self.voiceIcon.hidden = YES;
    
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                self.faceIcon.hidden = NO;
                if (model.gender.integerValue==1) {
                    [self.faceIcon sd_setImageWithURL:[NSURL URLWithString:model.portraitPic] placeholderImage:kDefaultFemaleHead];
                } else {
                     [self.faceIcon sd_setImageWithURL:[NSURL URLWithString:model.portraitPic] placeholderImage:kDefaultManHead];
                }
                self.faceIcon.right = self.arrowIcon.left - 13;
                self.faceIcon.centerY = self.arrowIcon.centerY;
            }
                break;
            case 1:
                self.contentLab.hidden = NO;
                if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
                    self.contentLab.text = model.customerName;
                } else {
                    self.contentLab.text = model.customerNm;
                }
                break;
            case 2:
                self.contentLab.hidden = NO;
                if (model.gender.integerValue==1) {
                    self.contentLab.text = @"女";
                } else if (model.gender.integerValue==2){
                    self.contentLab.text = @"男";
                } else {
                    self.contentLab.text = @"";
                    
                }
                break;
            case 3:
                self.contentLab.hidden = NO;
                self.contentLab.text = [NSString stringWithFormat:@"%zd",model.age];
                break;
            case 4:
                self.contentLab.hidden = NO;
                if (self.model.customerType.integerValue==1) {
                    self.contentLab.text = [self stringWithArray:model.language];
                } else {
                    self.contentLab.text = [self stringWithArray:model.job];
                }
                //self.contentLab.text = model.job;
                break;
            case 5:
                self.contentLab.hidden = NO;
                if (self.model.customerType.integerValue==1) {
                    self.contentLab.text = model.cityName;
                } else {
                    self.contentLab.text = [self stringWithArray:model.language];
                }
                //self.contentLab.text = model.language;
                break;
            case 6:
                self.contentLab.hidden = NO;
                self.contentLab.text = model.cityName;
                break;
        }
    }
    if (indexPath.section==1) {
        switch (indexPath.row) {
            case 0:
                self.contentLab.hidden = NO;
                self.contentLab.text = [self stringWithArray:model.hobby];
                //self.contentLab.text = model.hobby;
                break;
            case 1:
                self.voiceIcon.hidden = [NSString isEmptyStirng:model.speechIntroduction];
                self.voiceIcon.right = self.arrowIcon.left - 13;
                self.voiceIcon.centerY = self.arrowIcon.centerY;
                break;
            case 2:
                self.titleLab.top =17;
                self.arrowIcon.centerY = self.titleLab.centerY;
                self.textView.hidden = NO;
//                self.textView.attributedText = model.txtDesc;
                self.textView.text = model.txtDesc;
                self.textView.top = self.titleLab.bottom + 10;
                break;
        }
    }
    //section=0,row=0，section=1,row!=1就计算contentLab
    if ((indexPath.section==0 && indexPath.row >0) || (indexPath.section==1 && indexPath.row==0)) {
        CGFloat maxW = self.arrowIcon.left -13 - self.titleLab.right-10;
        CGSize contentSize = [LKUtils sizeFit:self.contentLab.text withUIFont:self.contentLab.font withFitWidth:maxW withFitHeight:self.contentLab.height];
        self.contentLab.width = contentSize.width;
        self.contentLab.right = self.arrowIcon.left -13;
        self.contentLab.centerY = self.arrowIcon.centerY;
    }
    
}

- (NSString *)stringWithArray:(NSArray *)array {
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        NSString *labelname = [NSString stringValue:dict[@"labelName"]];
        if (labelname.length>0) {
            [temp addObject:labelname];
        } else {
            [temp addObject:[NSString stringValue:dict[@"codLabelName"]]];
            
        }
    }
    return [temp componentsJoinedByString:@","];
}

+ (CGFloat)getCellHeight:(LKPersonInfoModel *)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 80;
        }
        return 50;
    }
    if (indexPath.section==1) {
        if (indexPath.row==2) {
            
            return 150;
        }
        return 50;
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
    [LKAudioManager share].audioArray = @[[NSString stringValue:self.model.speechIntroduction]];
    [[LKAudioManager share] play];
    [LKAudioManager share].preparePlayBlock = ^{
        [self startAnimation];
    };
    [LKAudioManager share].playOverBlock = ^{
        [self stopAnimation];
    };
}

@end
