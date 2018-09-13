//
//  LKUserDetailCanlenderCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/21.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailCanlenderCell.h"

#import "LKCalendarPickerView.h"

@interface LKUserDetailCanlenderCell ()

@property (nonatomic, strong) LKCalendarPickerView *pickerView;

@end

@implementation LKUserDetailCanlenderCell

{
    UILabel *_selectedTimeLabel;
}

+ (CGFloat)heightWithModel:(LKServerModel *)model {
    CGFloat height = 10+kBFont(14).lineHeight+15+300+15+kFont(12).lineHeight+10+48+20;
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (LKCalendarPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[LKCalendarPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
         @weakify(self);
        _pickerView.selectedCalendarBlock = ^(NSInteger days) {
            @strongify(self);
            [self selectedDays:days];
        };
    }
    return _pickerView;
}

- (void)selectedDays:(NSInteger )days {
    if (_pickerView.BeginDate && _pickerView.EndDate) {
        self.beginDate = [LKUtils dateToString:_pickerView.BeginDate withDateFormat:@"yyyy-MM-dd"];
        self.endDate = [LKUtils dateToString:_pickerView.EndDate withDateFormat:@"yyyy-MM-dd"];
        self.days = days+1;
        _selectedTimeLabel.text = [NSString stringWithFormat:@"已选%@至%@，共%zd天",[LKUtils dateToString:_pickerView.BeginDate withDateFormat:@"yyyy-MM-dd"],[LKUtils dateToString:_pickerView.EndDate withDateFormat:@"yyyy-MM-dd"],days+1];
    }
}

- (void)setupUI {
    UILabel *label = [UILabel new];
    label.font = kBFont(14);
    label.textColor = kColorGray1;
    label.frame = CGRectMake(27, 15, 200, ceil(label.font.lineHeight));
    label.text = @"服务时间(当前时间)";
    [self.contentView addSubview:label];
    
    self.pickerView.top = label.bottom+15;
    [self.contentView addSubview:self.pickerView];
    
    UILabel *selectedTime = [UILabel new];
    selectedTime.font = kFont(12);
    selectedTime.textColor = kColorGray1;
    selectedTime.frame = CGRectMake(27, self.pickerView.bottom+15, 250, ceil(selectedTime.font.lineHeight));
    selectedTime.text = @"服务时间(当前时间)";
    selectedTime.textAlignment = NSTextAlignmentCenter;
    selectedTime.centerX = kScreenWidth*0.5;
    [self.contentView addSubview:selectedTime];
    _selectedTimeLabel = selectedTime;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"立即预约" forState:UIControlStateNormal];
    [btn setTitleColor:kColorGray1 forState:UIControlStateNormal];
    btn.backgroundColor = kColorYellow1;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = kBFont(14);
    btn.frame = CGRectMake(30, selectedTime.bottom+10, kScreenWidth-60, 48);
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(bookingAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bookingAction {
    if (_pickerView.BeginDate && _pickerView.EndDate) {
        if ([self.mainView.delegate respondsToSelector:@selector(clickImmediateBookingBtn)]) {
            [self.mainView.delegate clickImmediateBookingBtn];
        }
    } else {
        [LKUtils showMessage:@"请选择服务时间"];
    }
}

- (void)setServerModel:(LKServerModel *)serverModel {
    _serverModel = serverModel;
    
    NSMutableArray *temp = [NSMutableArray array];

    for (NSDictionary *dict in serverModel.dateSets) {
        NSString *dateStr = [NSString stringValue:[dict valueForKey:@"dateOff"]];
 
        [temp addObject:[LKUtils stringToDate:dateStr withDateFormat:@"yyyy-MM-dd"]];
      
    }
    
    self.pickerView.dateSets = [NSArray arrayWithArray:temp];
    [self.pickerView.calendar reloadData];
}

@end
