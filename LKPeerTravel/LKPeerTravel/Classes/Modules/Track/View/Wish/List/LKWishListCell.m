//
//  LKWishListCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishListCell.h"

#import "LKSevenSwitch.h"

@implementation LKWishListCell

{
    UIImageView *_bgIV;
    UILabel *_titleLabel; // 标题
    UILabel *_timeLabel; // 时间
    UILabel *_stateLabel; // 状态
    UIButton *_editBtn; // 重新编辑
    UIButton *_deleteBtn; // 删除
    
    UILabel *_markTitleLabel;
    NSMutableArray *_wishTags;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        [self setupUI];
    }
    return self;
}

+ (CGFloat)heightWithModel:(LKWishListModel *)model {
    CGFloat height = 12+17+ceil(kBFont(18).lineHeight)+25+6*(ceil(kFont(14).lineHeight)+18)+ceil(kFont(14).lineHeight);
    
    CGFloat left = 20;
    CGFloat wishHeight = 30;
    for (LKWishLabelInfo *info in model.wishLabelList) {
        CGSize size = [LKUtils sizeFit:info.codDestinationPointName withUIFont:kFont(14) withFitWidth:MAXFLOAT withFitHeight:30];
        if (left+size.width+20>kScreenWidth-12-20) {
            left = 20;
            wishHeight+=40;
        }
    }
    
    height += 18+(model.wishLabelList.count?wishHeight+65+10:10)  +34+27;
    return height;
}

- (void)setupUI {
    // 背景图
    _bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, kScreenWidth-12, 0)];
    _bgIV.userInteractionEnabled = YES;
    _bgIV.image = [[UIImage imageNamed:@"img_block1"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [self.contentView addSubview:_bgIV];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = kBFont(18);
    _titleLabel.textColor = kColorGray1;
    _titleLabel.text = @"香港";
    _titleLabel.frame = CGRectMake(0, 17, 200, ceil(_titleLabel.font.lineHeight));
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.centerX = _bgIV.width*0.5;
    [_bgIV addSubview:_titleLabel];
    
    NSArray *titles = @[@"出行时间",@"语言要求",@"同行人数",@"预算",@"接机优先",@"有车优先"];
    CGFloat originY = 64;
    for (int i=0; i<titles.count; i++) {
        NSString *title = titles[i];
        
        UILabel *titleLabel = [self cratetitleLabelTitle:title originY:originY];
        [_bgIV addSubview:titleLabel];
        
        if ([title isEqualToString:@"接机优先"]||[title isEqualToString:@"有车优先"]) {
            LKSevenSwitch *sevenSwitch = [[LKSevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 55, 32)];
            sevenSwitch.tag = 100+i;
            sevenSwitch.right = _bgIV.width-10;
            sevenSwitch.centerY = titleLabel.centerY;
            sevenSwitch.enabled = NO;
            [_bgIV addSubview:sevenSwitch];
        } else {
            UILabel *info = [self crateInfoLabelTitle:@"心愿信息" originY:originY];
            [_bgIV addSubview:info];
            info.tag = 100+i;
        }
        originY = titleLabel.bottom+18;
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, originY, _bgIV.width-40, 0.5)];
    line.backgroundColor = kColorLine1;
    [_bgIV addSubview:line];
    originY = line.bottom+18;
    
    UILabel *label = [self cratetitleLabelTitle:@"心愿标签" originY:originY];
    [_bgIV addSubview:label];
    _markTitleLabel = label;
    originY = label.bottom+18;
    
    CGFloat top = originY;
    CGFloat left = 20;
    
    _wishTags = [NSMutableArray array];
    NSArray *tags = @[@"维多利亚湾",@"海港城",@"APM",@"铜锣湾",@"甘牌烧鹅",@"太古广场",@"海洋公园",@"旺角",@"迪士尼乐园",@"时代广场"];
    for (int i=0; i<tags.count; i++) {
        NSString *str = tags[i];
        CGSize size = [LKUtils sizeFit:str withUIFont:[UIFont systemFontOfSize:12] withFitWidth:MAXFLOAT withFitHeight:30];
        
        if (left+size.width+20>_bgIV.width-20) {
            left=20;
            top+=40;
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, size.width+20, 30)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = kColorGray1;
        titleLabel.backgroundColor = TableBackgroundColor;
        titleLabel.layer.cornerRadius = 3;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.masksToBounds = YES;
        [_bgIV addSubview:titleLabel];
        titleLabel.text = str;
        left = titleLabel.right+10;
        originY = titleLabel.bottom+65;
        
        [_wishTags addObject:titleLabel];
    }
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = kColorRed1;
    _timeLabel.frame = CGRectMake(20, originY, 100, ceil(_timeLabel.font.lineHeight));
    [_bgIV addSubview:_timeLabel];
    
    _stateLabel = [UILabel new];
    _stateLabel.font = [UIFont systemFontOfSize:12];
    _stateLabel.textColor = kColorRed1;
    _stateLabel.frame = CGRectMake(20, originY, 100, ceil(_stateLabel.font.lineHeight));
    _stateLabel.text = @"已失效";
    [_bgIV addSubview:_stateLabel];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, originY, 80, 34);
    _editBtn.backgroundColor = [UIColor yellowColor];
    [_editBtn setTitle:@"重新编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:kColorGray1 forState:UIControlStateNormal];
    _editBtn.layer.cornerRadius = 3;
    _editBtn.right = _bgIV.width-20;
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _editBtn.layer.masksToBounds = YES;
    [_editBtn addTarget:self action:@selector(reeditAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgIV addSubview:_editBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(0, originY, 80, 34);
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kColorGray2 forState:UIControlStateNormal];
    _deleteBtn.layer.cornerRadius = 3;
    _deleteBtn.layer.borderColor = kColorGray2.CGColor;
    _deleteBtn.layer.borderWidth = 0.5;
    _deleteBtn.right = _bgIV.width-20;
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _deleteBtn.layer.masksToBounds = YES;
    [_bgIV addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    _bgIV.height = _deleteBtn.bottom+27;
}

- (void)setModel:(LKWishListModel *)model {
    _model = model;
    
    _titleLabel.text = model.codCityName;
    
    // 出行时间
    UILabel *travelTime = [_bgIV viewWithTag:100+0];
    NSString *beginTime = [LKUtils dateToString:[NSDate dateWithTimeIntervalSince1970:model.beginTime/1000] withDateFormat:@"yyyy-MM-dd"];
    NSString *endTime = [LKUtils dateToString:[NSDate dateWithTimeIntervalSince1970:model.endTime/1000] withDateFormat:@"yyyy-MM-dd"];
    travelTime.text = [NSString stringWithFormat:@"%@~%@",beginTime,endTime];
    // 语言要求
    UILabel *languageLabel = [_bgIV viewWithTag:100+1];
    NSMutableArray *temp = [NSMutableArray array];
    for (LKWishLanguageInfo *info in model.languageList) {
        if (info.codLabelName.length>0) {
            [temp addObject:info.codLabelName];
        }
    }
    languageLabel.text = [temp componentsJoinedByString:@","];
    // 同行人数
    UILabel *numLabel = [_bgIV viewWithTag:100+2];
    numLabel.text = [NSString stringWithFormat:@"%ld",(long)model.codPeopleCount];
    // 预算
    UILabel *budgetLabel = [_bgIV viewWithTag:100+3];
    budgetLabel.text = [NSString stringWithFormat:@"%ld",(long)model.codBudgetAmount];
    
    // 接机优先
    LKSevenSwitch *planeSwitch = [_bgIV viewWithTag:100+4];
    planeSwitch.on = [model.flagPickUp isEqualToString:@"1"];
    
    // 接机优先
    LKSevenSwitch *carSwitch = [_bgIV viewWithTag:100+5];
    carSwitch.on = [model.flgCar isEqualToString:@"1"];
    
    // 心愿标签
    [_wishTags makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_wishTags removeAllObjects];
    
    CGFloat originY = _markTitleLabel.bottom+18;
    CGFloat top = originY;
    CGFloat left = 20;
    for (LKWishLabelInfo *info in model.wishLabelList) {
        NSString *str = info.codDestinationPointName;
        CGSize size = [LKUtils sizeFit:str withUIFont:[UIFont systemFontOfSize:12] withFitWidth:MAXFLOAT withFitHeight:30];
        
        if (left+size.width+20>_bgIV.width-20) {
            left=20;
            top+=40;
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, size.width+20, 30)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = kColorGray1;
        titleLabel.backgroundColor = TableBackgroundColor;
        titleLabel.layer.cornerRadius = 3;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.layer.masksToBounds = YES;
        [_bgIV addSubview:titleLabel];
        titleLabel.text = str;
        left = titleLabel.right+10;
        originY = titleLabel.bottom+65;
        
        [_wishTags addObject:titleLabel];
    }
    
    _editBtn.top = _deleteBtn.top = originY;
    _timeLabel.centerY = _stateLabel.centerY = _editBtn.centerY;
    
    _bgIV.height = _deleteBtn.bottom+27;
    
    _editBtn.hidden = YES;
    _deleteBtn.hidden = YES;
    _timeLabel.hidden = YES;
    _stateLabel.hidden = YES;
    
    if ([model.wishStatus isEqualToString:@"0"]) { // 正常状态
        _editBtn.hidden = NO;
        _timeLabel.hidden = NO;
        [self countDown];
    } else {
        _deleteBtn.hidden = NO;
        _stateLabel.hidden = NO;
    }
    
}

- (void)reeditAction {
    if (self.reEditBlock) {
        self.reEditBlock(self.model);
    }
}

- (void)deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock(self.model);
    }
}

- (void)countDown {
    if ([self.model.wishStatus isEqualToString:@"0"]) {
        NSDate *expdate = [NSDate dateWithTimeIntervalSince1970:self.model.expTime.integerValue/1000];
        
        NSInteger interval = [expdate timeIntervalSinceNow];
        if (interval<=0) {
            self.model.wishStatus = @"1";
            _editBtn.hidden = YES;
            _timeLabel.hidden = YES;
            
            _deleteBtn.hidden = NO;
            _stateLabel.hidden = NO;
        } else {
        _timeLabel.text = [NSString stringWithFormat:@"%ld:%ld后失效",interval/60,interval%60];
        }
    }
}



- (UILabel *)cratetitleLabelTitle:(NSString *)title originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(20, originY, 100, ceil(label.font.lineHeight));
    label.text = title;
    return label;
}

- (UILabel *)crateInfoLabelTitle:(NSString *)info originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(87, originY, 250, ceil(label.font.lineHeight));
    label.text = info;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

@end
