//
//  LKUserDetailInfoCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailInfoCell.h"

#import "LKUserDetailMainView.h"

@implementation LKUserDetailInfoCell

{
    UIImageView *_bgIV; //圆角背景
    UILabel *_descLabel;
    UIView *_line2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        [self setupUI];
    }
    return self;
}

+ (CGFloat)heightWithModel:(LKUserDetailModel *)model {
    CGFloat height = 26+4*(ceil(kFont(14).lineHeight)+20);
    CGSize size = [LKUtils sizeFit:model.txtDesc withUIFont:kFont(14) withFitWidth:kScreenWidth-12-40 withFitHeight:MAXFLOAT];
    height += 20+size.height+26+18+13+18+5;
    return height;
}

- (void)setupUI {
    _bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 0, kScreenWidth-12, 0)];
    _bgIV.userInteractionEnabled = YES;
    _bgIV.image = [[UIImage imageNamed:@"img_block1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:_bgIV];
    
    NSArray *titles = @[@"学历",@"职业",@"入驻平台时间",@"语言"];
    NSArray *infos = @[@"大专",@"学生",@"2018年6月20日",@"中文 英语"];
    CGFloat originY = 26;
    for (int i=0; i<titles.count; i++) {
        NSString *title = titles[i];
        NSString *info = infos[i];
        UILabel *titleLabel = [self cratetitleLabelTitle:title originY:originY];
        UILabel *infoLabel = [self crateInfoLabelTitle:info originY:originY];
        infoLabel.right = _bgIV.width-20;
        infoLabel.tag = 100+i;
        [_bgIV addSubview:titleLabel];
        [_bgIV addSubview:infoLabel];
        originY = titleLabel.bottom+20;
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, originY, _bgIV.width-20, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [_bgIV addSubview:line];
    
    _descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:14.0f];
    _descLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _descLabel.text = @"这个 Session 主要介绍了图像渲染管线，缓存区，解码，图像来源，自定义绘制和离屏绘制。通过学习该 Session，能够对图像渲染流程有更清晰的认识，同时了解如何在开发中提高图像渲染的性能。";
    _descLabel.numberOfLines = 0;
    _descLabel.frame = CGRectMake(20, line.bottom+20, _bgIV.width-40, 0);
    [_descLabel sizeToFit];
    [_bgIV addSubview:_descLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, _descLabel.bottom+26, _bgIV.width-20, 0.5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [_bgIV addSubview:line2];
    _line2 = line2;
    
    NSArray *titles2 = @[@"实名认证",@"学校认证",@"考核上岗"];
    NSArray *icons = @[@"img_calendar_examine_name",@"img_calendar_examine_school",@"img_calendar_examine_guide"];
    CGFloat left = 20;
    for (int i=0; i<titles2.count; i++) {
        LKUserDetailInfoIconView *iconView = [[LKUserDetailInfoIconView alloc] initWithFrame:CGRectMake(left, line2.bottom, 100, 18+13+18) title:titles2[i] icon:icons[i]];
        iconView.tag = 200+i;
        [_bgIV addSubview:iconView];
        left = iconView.right+20;
        [iconView g_addTapWithTarget:self action:@selector(certifyClick)];
        if (i==titles2.count-1) {
            UIImageView *arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
            arrowIcon.image = [UIImage imageNamed:@"btn_home_into_none"];
            arrowIcon.centerY = iconView.centerY;
            arrowIcon.right = _bgIV.width-(kScreenWidth<375?5:20);
            arrowIcon.tag = 300;
            [_bgIV addSubview:arrowIcon];
            _bgIV.height = iconView.bottom+18;
        }
    }
}

- (void)setDetailModel:(LKUserDetailModel *)detailModel {
    _detailModel = detailModel;
    
    // 职业
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dict in detailModel.job) {
        [temp addObject:[NSString stringValue:dict[@"labelName"]]];
    }
    UILabel *label1 = [_bgIV viewWithTag:100+1];
    label1.text = [temp componentsJoinedByString:@","];
    
    // 平台入驻时间
    UILabel *label2 = [_bgIV viewWithTag:100+2];
    label2.text = detailModel.datCreate;
    
    // 语言
    NSMutableArray *temp2 = [NSMutableArray array];
    for (NSDictionary *dict in detailModel.language) {
        [temp2 addObject:[NSString stringValue:dict[@"labelName"]]];
    }
    UILabel *label3 = [_bgIV viewWithTag:100+3];
    label3.text = [temp2 componentsJoinedByString:@","];
    
    // 自我介绍
    _descLabel.text = detailModel.txtDesc;
     CGSize size = [LKUtils sizeFit:detailModel.txtDesc withUIFont:kFont(14) withFitWidth:kScreenWidth-12-40 withFitHeight:MAXFLOAT];
    _descLabel.height = size.height;
    
    _line2.top = _descLabel.bottom+26;
    
    // 认证
    for (int i=0; i<3; i++) {
        LKUserDetailInfoIconView *iconView = [_bgIV viewWithTag:200+i];
        iconView.top = _line2.bottom;
        if (i==2) {
            UIImageView *arrow = [_bgIV viewWithTag:300];
            arrow.centerY = iconView.centerY;
            _bgIV.height = iconView.bottom+5;
        }
    }
}

- (void)certifyClick {
    if ([self.mainView.delegate respondsToSelector:@selector(clickCertifyAtIndex:)]) {
        [self.mainView.delegate clickCertifyAtIndex:1];
    }
}

- (UILabel *)cratetitleLabelTitle:(NSString *)title originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(20, originY, 100, ceil(label.font.lineHeight));
    label.text = title;
    return label;
}

- (UILabel *)crateInfoLabelTitle:(NSString *)info originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#999999"];
    label.frame = CGRectMake(87, originY, 250, ceil(label.font.lineHeight));
    label.text = info;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

@end


@implementation LKUserDetailInfoIconView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon {
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        iconIV.top = 18;
        [self addSubview:iconIV];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.frame = CGRectMake(iconIV.right+5, 19, 100, ceil(label.font.lineHeight));
        label.text = title;
        [label sizeToFit];
        label.centerY = iconIV.centerY;
        [self addSubview:label];
        
        self.width = label.right;
    }
    return self;
}

@end
