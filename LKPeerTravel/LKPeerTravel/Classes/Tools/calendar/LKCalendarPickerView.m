//
//  LKCalendarPickerView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCalendarPickerView.h"


static NSString *kLKCalendarPickerCellReuserIdentifier = @"kLKCalendarPickerCellReuserIdentifier";

@interface LKCalendarPickerCell : FSCalendarCell

@property (nonatomic,strong) NSMutableDictionary *backgroundColors;
@property (nonatomic,strong) NSMutableDictionary *titleColors;
@property (nonatomic,strong) NSMutableDictionary *subtitleColors;

@end

@implementation LKCalendarPickerCell

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

@interface LKCalendarPickerView () <FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (nonatomic,strong) UIButton *preBut;
@property (nonatomic,strong) UIButton *nextBut;
@property (nonatomic,strong) NSCalendar *gregorian;

//添加 开始时间,结束时间. 选择状态



@property(nonatomic,assign)BOOL SelectAction;


@end

@implementation LKCalendarPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.calendar];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.preBut.right = self.width/2-30;
            self.preBut.centerY = 43/2.0+3;

            self.nextBut.left = self.width/2+30;
            self.nextBut.centerY = self.preBut.centerY;
            
            NSLog(@"%@",NSStringFromCGRect(_calendar.calendarHeaderView.frame));
        });
    }
    return self;
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
        
        [_calendar registerClass:[LKCalendarPickerCell class] forCellReuseIdentifier:kLKCalendarPickerCellReuserIdentifier];
        
        _calendar.allowsMultipleSelection = YES;
        
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

- (NSCalendar *)gregorian{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
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
    
    if (self.SelectAction) {
        
        if ([[[LKUtils customDateFromatter] stringFromDate:self.BeginDate] isEqualToString:[[LKUtils customDateFromatter] stringFromDate:date]]) {
            
            return @"开始";
            
        }else{ return nil; }
        
    }else{
        
        if ([[[LKUtils customDateFromatter] stringFromDate:self.BeginDate] isEqualToString:[[LKUtils customDateFromatter] stringFromDate:date]]) {
            
            return @"开始";
            
        }else if ([[[LKUtils customDateFromatter] stringFromDate:self.EndDate] isEqualToString:[[LKUtils customDateFromatter] stringFromDate:date]]){
            
            return @"结束";
            
        }else{
            
            return nil;
            
        }
        
    }
    
}

//选中某一天进行相关操作

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    if (!self.SelectAction) {
        
        NSArray *selectArrray =[calendar selectedDates];
        
        for (NSDate *select in selectArrray) {
            
            [calendar deselectDate:select];
            
        }
        
        [_calendar selectDate:date];
        
        self.SelectAction=YES;
        
        self.BeginDate=date;
        
        self.EndDate=nil;
        
        [_calendar reloadData];
        
    }else
        
    {
        
        NSInteger number =[self numberOfDaysWithFromDate:self.BeginDate    toDate:date];
        
        NSLog(@"%ld",number);
        
        if (number<0) {
            
            self.SelectAction=YES;
            
            [LKUtils showMessage:@"小于开始日期,请重新选择"];
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1* NSEC_PER_SEC);
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_after(time, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [calendar deselectDate:date];
                });
                
            });
            
        }else
            
        {
            
            self.SelectAction=NO;
            
            self.EndDate=date;
            
            for (int i = 0; i<number; i++) {
                
                [_calendar selectDate:[date dateByAddingTimeInterval:-i*60*60*24]];
                
            }
            if (self.selectedCalendarBlock) {
                self.selectedCalendarBlock(number);
            }
            [_calendar reloadData];
            
        }}}

//点击选择中范围

-(void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition

{
    
    NSArray *selectArrray =[calendar selectedDates];
    
    for (NSDate *select in selectArrray) {
        
        [calendar deselectDate:select];
        
    }
    
    [_calendar selectDate:date];
    
    self.SelectAction=YES;
    
    self.BeginDate=date;
    
    self.EndDate=nil;
    
    [_calendar reloadData];
    
}

#pragma -mark 计算日期差的方法

-(NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents    * comp = [calendar components:NSCalendarUnitDay
                                  
                                             fromDate:fromDate
                                  
                                               toDate:toDate
                                  
                                              options:NSCalendarWrapComponents];
    
    return comp.day;
    
}


- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    if ([self.dateSets containsObject:date]) {
        return @"休息";
    }
    //判断是否为选择的日期
    if ([self.calendar.selectedDates containsObject:date]) {
        return nil;
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    LKCalendarPickerCell *cell = [calendar dequeueReusableCellWithIdentifier:kLKCalendarPickerCellReuserIdentifier forDate:date atMonthPosition:position];
    return cell;
}

//- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//    [self configure:cell date:date position:monthPosition];
//}

#pragma mark --FSCalendarDelegate
////是否可以选择时间
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    if ([self.dateSets containsObject:date]) {
        return NO;
    }
    return monthPosition = FSCalendarMonthPositionCurrent;
}
////选择了时间
//- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//    NSLog(@"选择的时间 %@",date);
//    [self.calendar reloadData];
//}
////是否可以取消选择时间
//- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//    //    if ([self.gregorian isDateInToday:date]) {
//    //        //判断是否为今天
//    //        return NO;
//    //    }
//    return YES;
//}




@end
