//
//  LKDatePickerView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKDatePickerView.h"

static CGFloat animationDruation = 0.25;

@interface LKDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView   * titleLine;
@property (nonatomic ,strong) UIView   * titleBackgroundView;/**< 标题栏背景*/
@property (nonatomic ,strong) UIButton * cancelBtn;/**< 取消按钮*/
@property (nonatomic, strong) UIButton * sureBtn;/**< 完成按钮*/
@property (nonatomic, strong) UILabel * titleLabel;/**< 标题*/
@property (nonatomic, strong) UIView * contentView;/**< 内容视图*/

@property (nonatomic, strong) UIPickerView *datePickerView;
@property (nonatomic, strong) NSMutableArray *yearArr;//2004-1918
@property (nonatomic, strong) NSMutableArray *monthArr;//1-12
@property (nonatomic, strong) NSMutableArray *dayArr;//1-31

@end

@implementation LKDatePickerView

{
    NSInteger _yearNum;
    NSInteger _defaultYear;
    NSInteger _monthNum;
    NSInteger _dayNum;
}

#pragma mark -- getter

- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [[NSMutableArray alloc] init];
        for (int i = 1918; i < 2005; i++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d年", i]];
        }
    }
    return _yearArr;
}

- (NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [[NSMutableArray alloc] init];
        for (int i = 1; i < 13; i++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d月", i]];
        }
    }
    return _monthArr;
}

- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [[NSMutableArray alloc] init];
        for (int i = 1; i < 32; i++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d日", i]];
        }
    }
    return _dayArr;
}

- (UIPickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 ,54, self.width,210)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        //_datePickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _datePickerView.delegate = self;
        _datePickerView.dataSource =  self;
        [_datePickerView selectRow:82 inComponent:0 animated:NO];
    }
    return _datePickerView;
}

- (UIView *)titleLine {
    if (!_titleLine) {
        _titleLine = [[UIView alloc]initWithFrame:CGRectMake(0, 53.5, self.width, 0.5)];
        _titleLine.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    }
    return _titleLine;
}

- (UIView *)titleBackgroundView{
    if (!_titleBackgroundView) {
        _titleBackgroundView = [[UIView alloc]initWithFrame:
                                CGRectMake(0, 0, self.width, 54)];
        _titleBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return _titleBackgroundView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:
                      CGRectMake(0, 0, 75, 54)];
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#b4b4b4"]
                         forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClicked)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:
                    CGRectMake(self.width - 75, 0, 75, 54)];
        [_sureBtn setTitle:@"确定"
                  forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#4a90e2"]
                       forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClicked)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 54)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择出生年月";
        _titleLabel.centerX = self.width*0.5;
    }
    return _titleLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    }
    return _contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.height = kScreenHeight;
    frame.size.width = kScreenWidth;
    
    self = [super initWithFrame:frame];
    if (self) {
        // 获取不同时间字段的信息
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate *dt = [NSDate date];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |  NSCalendarUnitDay |
        NSCalendarUnitHour |  NSCalendarUnitMinute |
        NSCalendarUnitSecond | NSCalendarUnitWeekday;
        NSDateComponents *comp = [gregorian components: unitFlags fromDate:dt];
        _defaultYear = comp.year;
    }
    return self;
}

#pragma mark - 加载标题栏
- (void)loadTitle{
    [self.contentView addSubview:self.titleBackgroundView];
    [self.titleBackgroundView addSubview:self.cancelBtn];
    [self.titleBackgroundView addSubview:self.sureBtn];
    [self.titleBackgroundView addSubview:self.titleLine];
    [self.titleBackgroundView addSubview:self.titleLabel];
}

#pragma mark  加载PickerView
- (void)loadPickerView{
    [self.contentView addSubview:self.datePickerView];
}

#pragma mark UIPickerView DataSource Method 数据源方法
//指定pickerview有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;//第一个展示字母、第二个展示数字
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = self.yearArr.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = self.monthArr.count;
            break;
        case 2:
            if (_monthNum == 2) { //二月特殊处理
                if (_yearNum % 4 == 0) { //闰年29天
                    result = self.dayArr.count - 2;
                } else { //其他28天
                    result = self.dayArr.count - 3;
                }
            } else if (_monthNum == 1 ||
                       _monthNum == 3 ||
                       _monthNum == 5 ||
                       _monthNum == 7 ||
                       _monthNum == 8 ||
                       _monthNum == 10||
                       _monthNum == 12) { // 31天
                result = self.dayArr.count;
            } else { //30天
                result = self.dayArr.count - 1;
            }
            break;
        default:
            break;
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"didSelectRow  %ld--%ld", row, component);
    if (component == 0) { //年
        _yearNum = [self.yearArr[row] integerValue];
    } else if (component == 1) { //月
        _monthNum = [self.monthArr[row] integerValue];
    } else if (component == 2) { //日
        _dayNum = [self.dayArr[row] integerValue];
    }
    if (component == 1 && _monthNum == 2) {
        if (_yearNum % 4 == 0) {
            if (_dayNum > 29) {
                [pickerView selectRow:28 inComponent:2 animated:YES];
            }
        } else {
            if (_dayNum > 28) {
                [pickerView selectRow:27 inComponent:2 animated:YES];
            }
        }
    }
    [pickerView reloadComponent:2];
    NSLog(@"%ld-%ld-%ld", _yearNum, _monthNum, _dayNum);
    //    self.constellationLbl.text = [self getConstellationWithMonth:_monthNum day:_dayNum];
    //    self.ageLbl.text = [NSString stringWithFormat:@"%ld岁", _defaultYear - _yearNum];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    switch (component) {
        case 0:
            title = self.yearArr[row];
            break;
        case 1:
            title = self.monthArr[row];
            break;
        case 2:
            title = self.dayArr[row];
            break;
        default:
            break;
    }
    return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSString *)getConstellationWithMonth:(NSInteger)m_ day:(NSInteger)d_ {
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    return [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m_*3-(d_ < [[astroFormat substringWithRange:NSMakeRange((m_-1), 1)] intValue] - (-19))*3, 3)]];
}

#pragma mark -- public

- (void)show{
    [self customOriginalSetting];
    
    [self showSetting];
}

- (void)hide{
    [UIView animateWithDuration:animationDruation animations:^(void){
        self.backgroundColor = [UIColor clearColor];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = animationDruation;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
        [self.contentView.layer addAnimation:transition forKey:@"cancel"];
        self.contentView.hidden = YES;
        
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    
}

- (void)customOriginalSetting {
    _yearNum = 2000;
    _monthNum = 1;
    _dayNum = 1;
    if (self.birthday.length>0) {
        NSArray *temp = [self.birthday componentsSeparatedByString:@"-"];
        if (temp.count==3) {
            _yearNum = [temp[0] integerValue];
            _monthNum = [temp[1] integerValue];
            _dayNum = [temp[2] integerValue];
            
            for (int i = 0; i < self.yearArr.count; i++) {
                if (_yearNum == [self.yearArr[i] integerValue]) {
                    [self.datePickerView selectRow:i inComponent:0 animated:YES];
                    [self.datePickerView reloadComponent:0];
                }
            }
            for (int i = 0; i < self.monthArr.count; i++) {
                if (_monthNum == [self.monthArr[i] integerValue]) {
                    [self.datePickerView selectRow:i inComponent:1 animated:YES];
                    [self.datePickerView reloadComponent:0];
                }
            }
            for (int i = 0; i < self.dayArr.count; i++) {
                if (_dayNum == [self.dayArr[i] integerValue]) {
                    [self.datePickerView selectRow:i inComponent:2 animated:YES];
                    [self.datePickerView reloadComponent:0];
                }
            }
        } else {
            
        }
    }
}

- (void)showSetting {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    
    //取消按键
    UIControl *cancel = [[UIControl alloc] initWithFrame:self.bounds];
    [cancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    
    [UIView animateWithDuration:animationDruation animations:^(void){
        self.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.62f];
    } completion:^(BOOL finished){
    }];
    
    [window addSubview:self];
    
    [self addSubview:self.contentView];
    [self loadTitle];
    [self loadPickerView];
    self.contentView.height = self.titleBackgroundView.height+self.datePickerView.height;
    
    self.contentView.bottom = self.height;
    self.contentView.hidden = NO;
    
    CATransition *transition = [CATransition animation];
    transition.duration = animationDruation;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = @"moveIn";
    transition.subtype = kCATransitionFromTop;
    [self.contentView.layer addAnimation:transition forKey:nil];
}

- (void)showAnimation {
    
}

- (void)cancelBtnClicked{
    [self hide];
}

- (void)sureBtnClicked{
    NSString *age = [NSString stringWithFormat:@"%ld岁", _defaultYear - _yearNum];
    NSString *constellation = [self getConstellationWithMonth:_monthNum day:_dayNum];
    NSString *birthday = [NSString stringWithFormat:@"%d-%d-%d",_yearNum,_monthNum,_dayNum];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSureBtn:constellation:birthday:)]) {
        [self.delegate clickSureBtn:age constellation:constellation birthday:birthday];
    }
}

@end
