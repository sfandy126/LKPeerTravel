//
//  LKTrackDetailHeaderView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailHeaderView.h"

@interface LKTrackDetailHeaderView ()
@property (nonatomic,strong) UIImageView *cycleView;

@property (nonatomic,strong) UILabel *countryLab;
@property (nonatomic,strong) UILabel *cityLab;
@property (nonatomic,strong) UIImageView *cityIcon;

@property (nonatomic,strong) UILabel *desLab;

@property (nonatomic,strong) LKTrackInfoModel *model;
@end

@implementation LKTrackDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //背景
        _cycleView = [[UIImageView alloc] initWithFrame:self.bounds];
        _cycleView.backgroundColor = [UIColor lightGrayColor];
        _cycleView.contentMode = UIViewContentModeScaleAspectFill;
        _cycleView.clipsToBounds = YES;
        [_cycleView g_addTapWithTarget:self action:@selector(headerTapAction)];
        [self addSubview:_cycleView];
        
        //城市
        _cityLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 0)];
        _cityLab.backgroundColor = [UIColor clearColor];
        _cityLab.text = @"";
        _cityLab.textColor = [UIColor whiteColor];
        _cityLab.font = [UIFont boldSystemFontOfSize:24.0];
        _cityLab.height = ceil(_cityLab.font.lineHeight);
        _cityLab.bottom = _cycleView.bottom -30;
        [_cycleView addSubview:_cityLab];
        
        //国家
        _countryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _countryLab.backgroundColor = [UIColor clearColor];
        _countryLab.text = @"";
        _countryLab.textColor = [UIColor whiteColor];
        _countryLab.font = [UIFont systemFontOfSize:16.0];
        _countryLab.left = _cityLab.left;
        _countryLab.height = ceil(_countryLab.font.lineHeight);
        _countryLab.bottom = _cityLab.top -5;
        [_cycleView addSubview:_countryLab];
        
        _cityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 16)];
        _cityIcon.backgroundColor = [UIColor clearColor];
        _cityIcon.image =[UIImage imageNamed:@"img_foot_position"];
        _cityIcon.bottom = _cityLab.bottom-5;
        [_cycleView addSubview:_cityIcon];
        
        //描述
        _desLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLab.backgroundColor = [UIColor clearColor];
        _desLab.text = @"";
        _desLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _desLab.font = [UIFont boldSystemFontOfSize:16.0];
        _desLab.numberOfLines = 2;
        [_cycleView addSubview:_desLab];
        
    }
    return self;
}

- (void)headerTapAction{
    if (self.clickedHeaderBlock) {
        self.clickedHeaderBlock(self.model);
    }
}

- (void)configData:(LKTrackInfoModel *)model{
    self.model = model;
    [_cycleView sd_setImageWithURL:[NSURL URLWithString:model.city_icon] placeholderImage:nil];
    
    _countryLab.text = [NSString stringValue:model.city_country];
    _cityLab.text = [NSString stringValue:model.city_name];
    _cityIcon.hidden = _cityLab.text.length==0;
    CGSize citySize = [LKUtils sizeFit:_cityLab.text withUIFont:_cityLab.font withFitWidth:100 withFitHeight:_cityLab.height];
    _cityLab.width = citySize.width;
    _cityIcon.left = _cityLab.right +5;
    
    //描述
    _desLab.text = [NSString stringValue:model.content];
    _desLab.left = _cityIcon.right +30;
    CGFloat maxW = kScreenWidth - _desLab.left - 30;
    CGSize desSize = [LKUtils sizeFit:_desLab.text withUIFont:_desLab.font withFitWidth:maxW withFitHeight:100];
    _desLab.width = desSize.width;
    //最多显示2行
    CGFloat singleH = ceil(_desLab.font.lineHeight);
    if (desSize.height>singleH*2) {
        _desLab.height = singleH*2+2;
    }else{
        _desLab.height = singleH;
    }
    _desLab.bottom = _cycleView.height - 30;
    _desLab.lineBreakMode = NSLineBreakByTruncatingTail;
}


@end
