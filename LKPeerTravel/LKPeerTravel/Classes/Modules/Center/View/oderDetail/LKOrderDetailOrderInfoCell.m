//
//  LKOrderDetailOrderInfoCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailOrderInfoCell.h"

@implementation LKOrderDetailOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSArray *group1 = @[@"订单编号",@"购买时间",@"截止时间"];
    NSArray *group2 = @[@"提供车辆",@"提供接机"];
    NSArray *group3 = @[@"同行人数",@"单价",@"出行天数",@"折扣"];
    NSArray *group4 = @[@"总价",@"实收"];
    
    NSArray *titles = @[group1,group2,group3,group4];
    CGFloat originY = 17;
    for (int i=0; i<titles.count; i++) {
        NSArray *group = titles[i];
        NSInteger groupTag = 1000;
        if (i==1) {
            groupTag=2000;
        }
        if (i==2) {
            groupTag=3000;
        }
        if (i==3) {
            groupTag=4000;
        }
        for (int j=0; j<group.count; j++) {
            UILabel *label = [self cratetitleLabelTitle:group[j] originY:originY];
            [self.contentView addSubview:label];
            UILabel *info = [self crateInfoLabelTitle:@" " originY:originY];
            [self.contentView addSubview:info];
            originY = label.bottom+14;
            info.tag = groupTag+j;
        }
        
        if (i!=titles.count-1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, originY, kScreenWidth-40, 0.5)];
            line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
            [self.contentView addSubview:line];
            
            originY = line.bottom+17;
        }
    }
}


- (UILabel *)cratetitleLabelTitle:(NSString *)title originY:(CGFloat)originY {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(20, originY, 60, ceil(label.font.lineHeight));
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
    //@"订单编号",@"购买时间",@"截止时间"
    {
        UILabel *label = [self.contentView viewWithTag:1000];
        label.text = [NSString stringValue:model.orderNo];
    }
    {
        UILabel *label = [self.contentView viewWithTag:1001];
        label.text = [NSString stringValue:model.datCreate];
    }
    {
        UILabel *label = [self.contentView viewWithTag:1002];
        label.text = [NSString stringValue:model.datEffective];
    }
    
    //@"提供车辆",@"提供接机"
    {
        UILabel *label = [self.contentView viewWithTag:2000];
        label.text = model.flagCar ? @"是":@"否";
    }
    {
        UILabel *label = [self.contentView viewWithTag:2001];
        label.text = model.flagPlane ? @"是":@"否";
    }
    //@"同行人数",@"单价",@"出行天数",@"折扣"
    {
        UILabel *label = [self.contentView viewWithTag:3000];
        label.text = [NSString stringWithFormat:@"%@人",[NSString stringValue:model.pNum]];
    }
    {
        UILabel *label = [self.contentView viewWithTag:3001];
        label.text = [NSString stringWithFormat:@"%@元",[NSString stringValue:model.point]];
    }
    {
        UILabel *label = [self.contentView viewWithTag:3002];
        label.text = [NSString stringWithFormat:@"%@天",[NSString stringValue:model.dNum]];
    }
    {
        UILabel *label = [self.contentView viewWithTag:3003];
        label.text = [NSString stringWithFormat:@"%@折",[NSString stringValue:model.discount]];
    }
    
    //@"总价",@"实收"
    {
        UILabel *label = [self.contentView viewWithTag:4000];
        label.text = [NSString stringWithFormat:@"¥%@",[NSString stringValue:model.amtOrderProcess]];
    }
    {
        UILabel *label = [self.contentView viewWithTag:4001];
        label.text = [NSString stringWithFormat:@"¥%@",[NSString stringValue:model.amtOrderCharge]];
    }
    
}

@end
