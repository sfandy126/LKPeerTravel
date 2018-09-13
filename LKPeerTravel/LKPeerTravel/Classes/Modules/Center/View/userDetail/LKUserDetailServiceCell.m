//
//  LKUserDetailServiceCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailServiceCell.h"

@interface LKUserDetailServiceCell () <UITextFieldDelegate>

@end

@implementation LKUserDetailServiceCell

{
    UITextField *_tf;
    NSInteger _num;
    UILabel *_countLabel;
    UIButton *_addBtn;
    UIButton *_reduceBtn;
}

+ (CGFloat)heightWithModel:(LKServerModel *)model {
    NSInteger count = model.discounts.count-1;
    for (NSDictionary *dict in model.discounts) {
        NSString *discount = [NSString stringValue:dict[@"discountPost"]];
        if (discount.length==0 || [discount floatValue]==0) {
            count--;
        }
    }
    if (count<0) {
        count=0;
    }
    NSInteger index = 5;
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        index = 6;
    }
    CGFloat height = 15+ceil(kBFont(18).lineHeight)+30+(index+count)*(ceil(kBFont(14).lineHeight)+27);
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *title = [UILabel new];
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [UIColor colorWithHexString:@"#333333"];
    title.frame = CGRectMake(27, 15, 100, ceil(title.font.lineHeight));
    title.text = @"我的服务";
    [self.contentView addSubview:title];
    
    NSArray *titles = @[@"服务价格",@"折扣",@"同行人数限制",@"提供车辆",@"接机服务"];
    
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        titles = @[@"服务价格",@"折扣",@"同行人数限制",@"提供车辆",@"接机服务",@"出行人数"];
    }
    
    CGFloat originY = title.bottom+30;
    for (int i=0; i<titles.count; i++) {
        UILabel *label = [self cratetitleLabelTitle:titles[i] originY:originY];
        label.tag = 100+i;
        [self.contentView addSubview:label];
        
        UILabel *info = [self crateInfoLabelTitle:titles[i] originY:originY];
        info.right = kScreenWidth-27;
        info.tag = 200+i;
        [self.contentView addSubview:info];
        
        originY = label.bottom+27;
        
      
        
        if (i==titles.count-1) {
            
            if ([titles[i] isEqualToString:@"出行人数"]) {
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(0, 0, 16, 16);
                [addBtn setImage:[UIImage imageNamed:@"btn_visitor_plus_none"] forState:UIControlStateNormal];
                [addBtn setImage:[UIImage imageNamed:@"btn_visitor_plus_pressed"] forState:UIControlStateHighlighted];
                addBtn.right = kScreenWidth-23;
                addBtn.centerY = label.centerY;
                [addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:addBtn];
                _addBtn = addBtn;
                
                UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 44, 23)];
                tf.font = kBFont(11);
                tf.textColor = kColorGray1;
                tf.right = addBtn.left-7;
                tf.layer.cornerRadius = 3;
                tf.layer.masksToBounds = YES;
                tf.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
                tf.centerY = label.centerY;
                tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                tf.textAlignment = NSTextAlignmentCenter;
                tf.keyboardType = UIKeyboardTypeNumberPad;
                [self.contentView addSubview:tf];
                tf.delegate = self;
                _tf = tf;
                
                UILabel *countLabel = [UILabel new];
                countLabel.font = kBFont(11);
                countLabel.textColor = kColorGray1;
                countLabel.text = @"人";
                [countLabel sizeToFit];
                countLabel.centerY = addBtn.centerY;
                countLabel.right = tf.right;
                [self.contentView addSubview:countLabel];
                _countLabel = countLabel;
                countLabel.hidden = YES;
                
                UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                reduceBtn.frame = CGRectMake(0, 0, 16, 16);
                [reduceBtn setImage:[UIImage imageNamed:@"btn_visitor_min_none"] forState:UIControlStateNormal];
                [reduceBtn setImage:[UIImage imageNamed:@"btn_visitor_min_pressed"] forState:UIControlStateHighlighted];
                reduceBtn.right = tf.left-7;
                reduceBtn.centerY = label.centerY;
                [reduceBtn addTarget:self action:@selector(reduceAction) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:reduceBtn];
                _reduceBtn = reduceBtn;
            }
      
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(27, originY, kScreenWidth-27, 0.5)];
            line2.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
            line2.tag = 300;
            [self.contentView addSubview:line2];
        }
    }
}

- (void)addAction {
    if (_num==self.serverModel.pmax) {
        [LKUtils showMessage:@"超过最多同行人数"];
        return;
    }
    _num++;
    _tf.text = [NSString stringWithFormat:@"%ld",_num];
    [self adjustSize];
}

- (void)reduceAction {
    if (_num==1) {
        [LKUtils showMessage:@"至少需要一人"];
        return;
    }
    _num--;
    _tf.text = [NSString stringWithFormat:@"%ld",_num];
    [self adjustSize];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _num = [textField.text integerValue];
    if (_num > self.serverModel.pmax) {
        [LKUtils showMessage:@"超过最多同行人数，请重新输入"];
        textField.text = @"";
        _num = 0;
    }
    [self adjustSize];
}

- (void)adjustSize {
    _countLabel.hidden = NO;
//    CGSize size = [LKUtils sizeFit:_tf.text withUIFont:_tf.font withFitWidth:_tf.width withFitHeight:_tf.height];
//    _countLabel.centerX = _tf.centerX+size.width;
}

- (NSInteger)getPeopleNumber {
    return _num;
}
- (double)getPeopleDiscount {
    double discount = 9.0;
    NSInteger index;
    for (NSDictionary *dict in self.serverModel.discounts) {
        index = [self.serverModel.discounts indexOfObject:dict];
        NSInteger pMax = [dict[@"maxNum"] integerValue];
        NSInteger pMin = [dict[@"minNum"] integerValue];
        double discountPost = [dict[@"minNum"] doubleValue];
        if (_num<pMin && index==0) {
            discount = discountPost;
        }
        if (_num>pMin && _num<pMax) {
            discount = discountPost;
        }
        if (_num>pMax && index==self.serverModel.discounts.count-1) {
            discount = discountPost;
        }
    }
    return discount;
}

- (void)setServerModel:(LKServerModel *)serverModel {
    _serverModel = serverModel;
    
    // 价格
    UILabel *info0 = [self.contentView viewWithTag:200+0];
    info0.text = [NSString stringWithFormat:@"¥%.0f人/天",serverModel.point];
    // 折扣
    UILabel *info1 = [self.contentView viewWithTag:200+1];
    CGFloat originY = info1.bottom+27;
    NSInteger index = 0;
    for (NSDictionary *dict in serverModel.discounts) {
        // 不显示空折扣
        NSString *discountpost = [NSString stringValue:dict[@"discountPost"]];
        if (discountpost.length==0 || [discountpost floatValue]==0) {
            continue;
        }
        UILabel *info;
        if (index==0) {
            info = info1;
        } else {
            info = [self crateInfoLabelTitle:@"" originY:originY];
            [self.contentView addSubview:info];
        }
        info.text = [NSString stringWithFormat:@"%@ - %@ 人",dict[@"minNum"],dict[@"maxNum"]];
        [info sizeToFit];
        info.right = kScreenWidth-27;
        
        UIView *discount = [self discountViewWithDiscount:dict[@"discountPost"]];
        discount.centerY = info.centerY;
        discount.right = info.left-5;
        [self.contentView addSubview:discount];
        
        originY = info.bottom+27;
        
        index++;
    }
    
    // 同行人数限制 、 提供车辆 、 提供服务
    for (int i=2; i<5; i++) {
        UILabel *title = [self.contentView viewWithTag:100+i];
        title.top = originY;
        
        UILabel *desc = [self.contentView viewWithTag:200+i];
        desc.top = originY;
        if (i==2) {
            desc.text = [NSString stringWithFormat:@"%zd人",serverModel.pmax];
        } else if (i==3) {
            desc.text = [serverModel.flagCar integerValue]==1?@"有":@"无";
        } else {
            desc.text = [serverModel.flagPlane integerValue]==1?@"有":@"无";
        }
        
        originY = title.bottom+27;
        
        if (i==4) {
            UIView *line = [self.contentView viewWithTag:300];
            line.top = originY;
        }
    }
    // 选择人数 下游用户打开上游用户主页才有
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        UILabel *title = [self.contentView viewWithTag:100+5];
        title.top = originY;
        
        UILabel *desc = [self.contentView viewWithTag:200+5];
        desc.top = originY;
        desc.text = @"";
        
        _addBtn.centerY = _countLabel.centerY = _reduceBtn.centerY = _tf.centerY = title.centerY;
        
        UIView *line = [self.contentView viewWithTag:300];
        line.top = title.bottom+27;
    }
}

- (UILabel *)cratetitleLabelTitle:(NSString *)title originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(27, originY, 100, ceil(label.font.lineHeight));
    label.text = title;
    return label;
}

- (UILabel *)crateInfoLabelTitle:(NSString *)info originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(87, originY, 250, ceil(label.font.lineHeight));
    label.text = info;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (UIView *)discountViewWithDiscount:(NSString *)discount {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_calendar_discount_block"]];
    
    UILabel *label = [UILabel new];
    label.font = kBFont(12);
    label.textColor = [UIColor colorWithHexString:@"#ffffff"];
    label.frame = CGRectMake(0, 0, iv.width, iv.height);
    label.text = [NSString stringWithFormat:@"%@折",discount];
    label.textAlignment = NSTextAlignmentCenter;
    [iv addSubview:label];
    
    return iv;
}

@end
