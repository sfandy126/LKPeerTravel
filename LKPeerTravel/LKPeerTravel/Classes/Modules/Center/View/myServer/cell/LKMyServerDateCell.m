//
//  LKMyServerDateCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerDateCell.h"
#import <FSCalendar.h>

static NSString *kLKMyServerDateCalendarCellIdentify = @"kLKMyServerDateCalendarCellIdentify";
@interface LKMyServerDateCalendarCell : FSCalendarCell
@property (nonatomic,strong) NSMutableDictionary *backgroundColors;
@property (nonatomic,strong) NSMutableDictionary *titleColors;
@property (nonatomic,strong) NSMutableDictionary *subtitleColors;

@end

@implementation LKMyServerDateCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //重新设置各种状态下的颜色
        _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _backgroundColors[@(FSCalendarCellStateNormal)]      = [UIColor clearColor];
        _backgroundColors[@(FSCalendarCellStateSelected)]    = [UIColor colorWithHexString:@"#FED648"];
        _backgroundColors[@(FSCalendarCellStateDisabled)]    = [UIColor clearColor];
        _backgroundColors[@(FSCalendarCellStatePlaceholder)] = [UIColor clearColor];
        _backgroundColors[@(FSCalendarCellStateToday)]       = [UIColor clearColor];
        
        _titleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _titleColors[@(FSCalendarCellStateNormal)]      = [UIColor colorWithHexString:@"#333333"];
        _titleColors[@(FSCalendarCellStateSelected)]    = [UIColor colorWithHexString:@"#333333"];
        _titleColors[@(FSCalendarCellStateDisabled)]    = [UIColor colorWithHexString:@"#dcdcdc"];
        _titleColors[@(FSCalendarCellStatePlaceholder)] = [UIColor colorWithHexString:@"#dcdcdc"];
        _titleColors[@(FSCalendarCellStateToday)]       = [UIColor colorWithHexString:@"#333333"];
        
        _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _subtitleColors[@(FSCalendarCellStateNormal)]      = [UIColor colorWithHexString:@"#333333"];
        _subtitleColors[@(FSCalendarCellStateSelected)]    = [UIColor colorWithHexString:@"#333333"];
        _subtitleColors[@(FSCalendarCellStateDisabled)]    = [UIColor colorWithHexString:@"#dcdcdc"];
        _subtitleColors[@(FSCalendarCellStatePlaceholder)] = [UIColor colorWithHexString:@"#dcdcdc"];
        _subtitleColors[@(FSCalendarCellStateToday)]       = [UIColor colorWithHexString:@"#333333"];
    }
    return self;
}

#pragma mark - 重新基类方法

- (UIColor *)colorForCellFill
{
    if (self.selected) {
        return self.preferredFillSelectionColor ?: [self colorForCurrentStateInDictionary:self.backgroundColors];
    }
    return self.preferredFillDefaultColor ?: [self colorForCurrentStateInDictionary:self.backgroundColors];
}

- (UIColor *)colorForTitleLabel
{
    if (self.selected) {
        return self.preferredTitleSelectionColor ?: [self colorForCurrentStateInDictionary:self.titleColors];
    }
    return self.preferredTitleDefaultColor ?: [self colorForCurrentStateInDictionary:self.titleColors];
}

- (UIColor *)colorForSubtitleLabel
{
    if (self.selected) {
        return self.preferredSubtitleSelectionColor ?: [self colorForCurrentStateInDictionary:self.subtitleColors];
    }
    return self.preferredSubtitleDefaultColor ?: [self colorForCurrentStateInDictionary:self.subtitleColors];
}

@end

@interface LKMyServerDateCell ()<FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) FSCalendar *calendar;
@property (nonatomic,strong) NSCalendar *gregorian;
@property (nonatomic,strong) UIButton *preBut;
@property (nonatomic,strong) UIButton *nextBut;

@end

@implementation LKMyServerDateCell
- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 100, 0)];
        _titleLab.text = @"日期安排";
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.textAlignment =  NSTextAlignmentLeft;
        _titleLab.font = kBFont(14);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (NSCalendar *)gregorian{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}

- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 344)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        
        _calendar.scrollEnabled =YES;
        _calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
        _calendar.pagingEnabled = YES;//是否分页
        _calendar.allowsMultipleSelection = YES;//是否可多选

        _calendar.appearance.headerTitleFont = kBFont(14.0);
        _calendar.appearance.weekdayFont =kBFont(14.0);
        _calendar.appearance.titleFont = kBFont(14.0);
        _calendar.appearance.subtitleFont = kFont(10.0);

        _calendar.appearance.headerTitleColor = [UIColor colorWithHexString:@"#333333"];
        _calendar.appearance.weekdayTextColor = [UIColor colorWithHexString:@"#333333"];
        _calendar.appearance.titleDefaultColor = [UIColor colorWithHexString:@"#333333"];
        _calendar.appearance.subtitleDefaultColor = [UIColor colorWithHexString:@"#333333"];
        
        
        _calendar.appearance.headerDateFormat = @"yyyy年MM月";
        _calendar.appearance.selectionColor = [UIColor colorWithHexString:@"#FED648"];
        _calendar.appearance.borderRadius = 0.25;//设置当前选择是圆形,0.0是正方形(0-1.0)
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;//设置日、一、二、三、、
        _calendar.clipsToBounds = YES;//隐藏顶部顶部线条，因为topBorder.y=-1.

        _calendar.appearance.subtitleOffset = CGPointMake(0, 5);
        _calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
        
        [_calendar registerClass:[LKMyServerDateCalendarCell class] forCellReuseIdentifier:kLKMyServerDateCalendarCellIdentify];
        
        
        //创建点击跳转显示上一月和下一月button
        [_calendar addSubview:self.preBut];
        [_calendar addSubview:self.nextBut];

    }
    return _calendar;
}

- (UIButton *)preBut{
    if (!_preBut) {
        _preBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _preBut.frame = CGRectMake(0, 0, 40, 30);
        _preBut.imageView.size = CGSizeMake(10, 10);
        [_preBut setImage:[UIImage imageNamed:@"btn_calendar_last_none"] forState:UIControlStateNormal];
        [_preBut addTarget:self action:@selector(previousClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preBut;
}

- (UIButton *)nextBut{
    if (!_nextBut) {
        _nextBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBut.frame = CGRectMake(0, 0, 40, 30);
        _nextBut.imageView.size = CGSizeMake(10, 10);
        [_nextBut setImage:[UIImage imageNamed:@"btn_calendar_next_none"] forState:UIControlStateNormal];
        [_nextBut addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBut;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLab];
    self.calendar.top = self.titleLab.bottom +20;
    [self.contentView addSubview:self.calendar];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.preBut.right = _calendar.calendarHeaderView.width/2-30;
        self.preBut.centerY =_calendar.calendarHeaderView.height/2.0+3;
        
        self.nextBut.left = _calendar.calendarHeaderView.width/2+30;
        self.nextBut.centerY = self.preBut.centerY;
    });
}

- (void)configData:(LKMyServerModel *)model  indexPath:(NSIndexPath *)indexPath{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];;
    NSDate *minimumDate = [NSDate date];
    NSDate *maximumDate = [LKUtils stringToDate:@"2099-12-31" withDateFormat:@"yyyy-MM-dd"];

    for (NSDictionary *dict in model.dateSets) {
        NSString *dateStr = [NSString stringValue:[dict valueForKey:@"dateOff"]];
        NSDate *date = [LKUtils stringToDate:dateStr withDateFormat:@"yyyy-MM-dd"];
        BOOL valid = YES;
        NSInteger minOffset = [calendar components:NSCalendarUnitDay fromDate:minimumDate toDate:date options:0].day;
        valid &= minOffset >= 0;
        if (valid) {
            NSInteger maxOffset = [calendar components:NSCalendarUnitDay fromDate:maximumDate toDate:date options:0].day;
            valid &= maxOffset <= 0;
        }
        if (valid) {
            [self.calendar selectDate:[LKUtils stringToDate:dateStr withDateFormat:@"yyyy-MM-dd"]];
        }
    }
}

- (NSArray *)getDateOffs {
    NSArray *dates = self.calendar.selectedDates;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDate *date in dates) {
        [temp addObject:@{@"dateOff":[LKUtils dateToString:date withDateFormat:@"yyyy-MM-dd"]}];
    }
    return [NSArray arrayWithArray:temp];
}

+ (CGFloat)getCellHeight:(LKMyServerModel *)model indexPath:(NSIndexPath *)indexPath{
    return 50 +344.0;
}

#pragma mark - - Action

- (void)previousClicked{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:NSCalendarWrapComponents];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:NSCalendarWrapComponents];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}



#pragma mark --FSCalendarDataSource
//最小时间
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [NSDate date];
}
//最大时间(1年之后)
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:NSCalendarWrapComponents];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
    return nil;
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    //判断是否为选择的日期
    if ([self.calendar.selectedDates containsObject:date]) {
        return @"休息";
    }
     return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    LKMyServerDateCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:kLKMyServerDateCalendarCellIdentify forDate:date atMonthPosition:position];
    return cell;
}

//- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//    [self configure:cell date:date position:monthPosition];
//}

#pragma mark --FSCalendarDelegate
//是否可以选择时间
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    return monthPosition = FSCalendarMonthPositionCurrent;
}
//选择了时间
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSLog(@"选择的时间 %@",date);
    [self.calendar reloadData];
}
//是否可以取消选择时间
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//    if ([self.gregorian isDateInToday:date]) {
//        //判断是否为今天
//        return NO;
//    }
    return YES;
}
//取消了选择的时间
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSLog(@"取消选择的时间 %@",date);
    [self.calendar reloadData];
}

#pragma mark - - FSCalendarDelegateAppearance


@end







