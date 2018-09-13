//
//  LKTrackOrderListCell.m
//  LKPeerTravel
//
//  Created by LK on 2018/8/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackOrderListCell.h"

@interface LKTrackOrderInfoView : UIView
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *valueLab;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *value;

@end

@implementation LKTrackOrderInfoView

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.text = @"";
        _titleLab.font = kFont(12);
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.height = ceil(_titleLab.font.lineHeight);
        CGSize size = [LKUtils sizeFit:@"出行时间" withUIFont:_titleLab.font withFitWidth:100 withFitHeight:_titleLab.height];
        _titleLab.width = size.width;
        _titleLab.centerY = self.height/2.0;
        _titleLab.left = 20;
    }
    return _titleLab;
}

- (UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLab.text = @"";
        _valueLab.font = kBFont(12);
        _valueLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _valueLab.height = ceil(_valueLab.font.lineHeight);
        _valueLab.centerY = self.height/2.0;
    }
    return _valueLab;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setValue:(NSString *)value{
    _value = value;
    self.valueLab.text = value;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        
        self.valueLab.left = self.titleLab.right + 20;
        self.valueLab.width = self.width -self.valueLab.left -80;
        [self addSubview:self.valueLab];
    }
    return self;
}

@end

@interface LKTrackOrderListCell ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSArray *infoViews;
@property (nonatomic,strong) UIImageView *arrowIcon;

@end

@implementation LKTrackOrderListCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView =[[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 0)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _arrowIcon.contentMode = UIViewContentModeScaleAspectFit;
        _arrowIcon.clipsToBounds = YES;
    }
    return _arrowIcon;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        
        self.bgView.height = [[self class] getCellHeight:nil];
        [self.contentView addSubview:self.bgView];
        
        self.arrowIcon.right = self.bgView.width - 18;
        self.arrowIcon.centerY = self.bgView.height/2.0;
        [self updateSelectedState:NO];
        [self.bgView addSubview:self.arrowIcon];
        
        NSArray *titles = @[@"订单编号",@"私人助理",@"出游时间",@"出游城市"];
        NSInteger index =0;
        CGFloat topY = 17;
        CGFloat invalY = 8;
        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *title in titles) {
            LKTrackOrderInfoView *view = [[LKTrackOrderInfoView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, ceil(kBFont(12).lineHeight))];
            view.top = topY +(view.height+invalY) *index;
            view.title = title;
            [self.bgView addSubview:view];
            [temp addObject:view];
            index++;
        }
        self.infoViews = [temp copy];
    }
    return self;
}

- (void)updateSelectedState:(BOOL)isSelected{
    self.arrowIcon.image = isSelected?[UIImage imageNamed:@"btn_loading_determine_pressed"]:[UIImage imageNamed:@"btn_loading_determine_none"];
}


- (void)configData:(LKTrackOrderListItemModel *)data{
    
    NSArray *values = @[[NSString stringValue:data.orderNo],[NSString stringValue:data.guider],[NSString stringValue:data.travelTime],[NSString stringValue:data.travelCity]];
    NSInteger index = 0;
    for (LKTrackOrderInfoView *view in self.infoViews) {
        view.value = [values objectAt:index];
        index++;
    }
    
    [self updateSelectedState:data.isSelected];
}

+ (CGFloat)getCellHeight:(id)data{
    return 120;
}

@end
