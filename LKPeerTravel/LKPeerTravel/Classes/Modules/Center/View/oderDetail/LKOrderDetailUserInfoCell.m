//
//  LKOrderDetailUserInfoCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailUserInfoCell.h"

@implementation LKOrderDetailUserInfoCell

{
    UILabel *_usernameLabel;
    UILabel *_phoneLabel;
    UILabel *_timeLabel;
    UILabel *_destinationLabel;
    UILabel *_languageLabel;
    
    UIImageView *_stateIcon;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];

        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat originY = 17;
    
    NSArray *titles = @[@"私人助手",@"电话",@"出行时间",@"出游城市",@"语言要求"];
    if ([LKUserInfoUtils getUserType] ==LKUserType_Guide) {
        titles = @[@"用户姓名",@"电话",@"出行时间",@"出游城市",@"语言要求"];
    }
    NSArray *infos = @[@"",@"",@"",@"",@""];
    
    for (int i = 0; i < titles.count; i ++) {
        NSString *title = titles[i];
        UILabel *name = [self cratetitleLabelTitle:title originY:originY];
        [self.contentView addSubview:name];
        
        UILabel *infoLabel = [self crateInfoLabelTitle:infos[i] originY:originY];
        [self.contentView addSubview:infoLabel];
        originY = name.bottom+14;
        if (i==0) {
            _usernameLabel = infoLabel;
        } else if (i==1) {
            _phoneLabel = infoLabel;
        } else if (i==2) {
            _timeLabel = infoLabel;
        } else if (i==3) {
            _destinationLabel = infoLabel;
        } else if (i==4) {
            _languageLabel = infoLabel;
            
            if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
                UIButton *phone = [UIButton buttonWithType:UIButtonTypeCustom];
                [phone setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [phone setTitle:@"立即联系" forState:UIControlStateNormal];
                
            }
        }
    }
    
    _stateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 203/3, 172/3)];
    _stateIcon.image = [UIImage imageNamed:@"img_visitor_completed"];
    _stateIcon.right = kScreenWidth - 20;
    _stateIcon.hidden = YES;
    [self.contentView addSubview:_stateIcon];
}

- (UILabel *)cratetitleLabelTitle:(NSString *)title originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(20, originY, 80, ceil(label.font.lineHeight));
    label.text = title;
    return label;
}

- (UILabel *)crateInfoLabelTitle:(NSString *)info originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(87, originY, 250, ceil(label.font.lineHeight));
    label.text = info;
    return label;
}

- (void)configData:(LKOrderDetailModel *)model{
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        _usernameLabel.text = model.guideName;
    } else {
        _usernameLabel.text = [NSString stringValue:model.userName];
    }
    _phoneLabel.text = [NSString stringValue:model.phone];
    _timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",model.dateStart,model.dateEnd];
    _destinationLabel.text = [NSString stringValue:model.cityName];
    _languageLabel.text = [NSString stringValue:model.jobs];
    
    _stateIcon.hidden = [model.codOrderStatus isEqualToString:@"2"]?NO:YES;

}

@end
