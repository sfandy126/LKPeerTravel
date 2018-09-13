//
//  LKSendTrackInputCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackInputCell.h"

#import "LKSelectCityViewController.h"

@interface LKSendTrackInputCell ()<UITextFieldDelegate>
@property (nonatomic,strong) UIView *bgView;

///标题
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UITextField *titleTF;

///目的地
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UITextField *addressTF;
@property (nonatomic,strong) UIButton *addressBtn;

///出发时间
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UITextField *timeTF;

///人均消费
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UITextField *startPriceTF;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UITextField *endPriceTF;

///出行天数
@property (nonatomic,strong) UILabel *dayLab;
@property (nonatomic,strong) UITextField *dayTF;

///出行人数
@property (nonatomic,strong) UILabel *personLab;
@property (nonatomic,strong) UITextField *personTF;

@property (nonatomic,strong) LKSendTrackInfoModel *model;

@end

@implementation LKSendTrackInputCell

- (UILabel *)createTitleLab:(NSString *)title{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.text = title;
    lab.font =  kFont(12);
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.height = ceil(lab.font.lineHeight);
    CGSize size = [LKUtils sizeFit:@"出行时间" withUIFont:_titleLab.font withFitWidth:100 withFitHeight:_titleLab.height];
    lab.width = size.width;
    return lab;
}

- (UITextField *)createTextField{
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectZero];
    tf.text = @"";
    tf.textColor = [UIColor colorWithHexString:@"#333333"];
    tf.font = kBFont(12);
    tf.layer.cornerRadius = 4.0;
    tf.layer.masksToBounds = YES;
    tf.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [tf setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [tf setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    return tf;
}

- (UIButton *)createBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView =[[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 0)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        
        self.bgView.height = [[self class] getCellHeight:nil];
        [self.contentView addSubview:self.bgView];
        
        CGFloat invalX = 10;
        CGFloat invalYTextField = 8;
        CGFloat textFieldHeight = 30;
        ///标题
        _titleLab = [self createTitleLab:@"标题"];
        _titleLab.left = 20;
        
        _titleTF = [self createTextField];
        _titleTF.left = _titleLab.right + invalX;
        _titleTF.top = 17;
        _titleTF.width = self.bgView.width - _titleTF.left - _titleLab.left;
        _titleTF.height = textFieldHeight;
        _titleLab.centerY = _titleTF.centerY;
        [self.bgView addSubview:_titleLab];
        [self.bgView addSubview:_titleTF];
        
        ///目的地
        _addressLab = [self createTitleLab:@"目的地"];
        _addressLab.left = _titleLab.left;
        
        _addressTF = [self createTextField];
        _addressTF.height = textFieldHeight;
        _addressTF.left = _titleTF.left;
        _addressTF.width = (self.bgView.width - (_titleLab.width +invalX +_titleLab.left)*2 -10)/2.0;//88;
        _addressTF.top = _titleTF.bottom +invalYTextField;
        _addressLab.centerY = _addressTF.centerY;

        _addressBtn = [self createBtn];
        _addressBtn.frame = _addressTF.frame;
        
        [self.bgView addSubview:_addressLab];
        [self.bgView addSubview:_addressTF];
        [self addSubview:_addressBtn];
        
        ///出发时间
        _timeLab = [self createTitleLab:@"出发时间"];
        _timeLab.left = _titleLab.left;
        
        _timeTF = [self createTextField];
        _timeTF.height = _addressTF.height;
        _timeTF.left = _titleTF.left;
        _timeTF.width = _addressTF.width;
        _timeTF.top = _addressTF.bottom +invalYTextField;
        _timeLab.centerY = _timeTF.centerY;
        
        [self.bgView addSubview:_timeLab];
        [self.bgView addSubview:_timeTF];
        
        ///人均消费
        _priceLab = [self createTitleLab:@"人均消费"];
        _priceLab.left = _titleLab.left;
        
        _startPriceTF = [self createTextField];
        _startPriceTF.textAlignment = NSTextAlignmentCenter;
        _startPriceTF.height = _addressTF.height;
        _startPriceTF.left = _titleTF.left;
        _startPriceTF.width = (_timeTF.width - (8 +5 +5))/2.0;
        _startPriceTF.top = _timeTF.bottom +invalYTextField;
        _priceLab.centerY = _startPriceTF.centerY;
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 2)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _lineView.layer.cornerRadius = _lineView.height/2.0;
        _lineView.layer.masksToBounds = YES;
        _lineView.left = _startPriceTF.right + 5;
        _lineView.centerY = _startPriceTF.centerY;
        
        _endPriceTF = [self createTextField];
        _endPriceTF.height = _startPriceTF.height;
        _endPriceTF.textAlignment = NSTextAlignmentCenter;
        _endPriceTF.left = _lineView.right +5;
        _endPriceTF.width = _startPriceTF.width;
        _endPriceTF.centerY = _startPriceTF.centerY;
        
        [_startPriceTF setValue:[NSNumber numberWithInt:0] forKey:@"paddingLeft"];
        [_startPriceTF setValue:[NSNumber numberWithInt:0] forKey:@"paddingRight"];
        
        [_endPriceTF setValue:[NSNumber numberWithInt:0] forKey:@"paddingLeft"];
        [_endPriceTF setValue:[NSNumber numberWithInt:0] forKey:@"paddingRight"];
        
        [self.bgView addSubview:_priceLab];
        [self.bgView addSubview:_startPriceTF];
        [self.bgView addSubview:_lineView];
        [self.bgView addSubview:_endPriceTF];
        
        ///出行天数
        _dayLab = [self createTitleLab:@"出行天数"];
        
        _dayTF = [self createTextField];
        _dayTF.width = _timeTF.width;
        _dayTF.height = _addressTF.height;
        _dayTF.right = self.bgView.width -_titleLab.left;
        _dayTF.centerY = _timeTF.centerY;
        _dayLab.centerY = _dayTF.centerY;
        _dayLab.right = _dayTF.left - invalX;
        
        [self.bgView addSubview:_dayLab];
        [self.bgView addSubview:_dayTF];
        
        ///出行人数
        _personLab = [self createTitleLab:@"出行人数"];
        
        _personTF = [self createTextField];
        _personTF.width = _dayTF.width;
        _personTF.height = _dayTF.height;
        _personTF.right = _dayTF.right;
        _personTF.centerY = _startPriceTF.centerY;
        _personLab.centerY = _personTF.centerY;
        _personLab.right = _personTF.left - invalX;
        
        [self.bgView addSubview:_personLab];
        [self.bgView addSubview:_personTF];
        
    }
    return self;
}

- (void)resignTextFieldFirstResponder{
    [_titleTF resignFirstResponder];
    [_addressTF resignFirstResponder];
    [_timeLab resignFirstResponder];
    [_startPriceTF resignFirstResponder];
    [_endPriceTF resignFirstResponder];
    [_dayTF resignFirstResponder];
    [_personTF resignFirstResponder];
}

- (void)configData:(LKSendTrackInfoModel *)data{
    self.model = data;
}

+ (CGFloat)getCellHeight:(id)data{
    return 180;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignTextFieldFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField==_addressTF) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField== _titleTF) {
        self.model.footprintTitle = textField.text;
    }
    if (textField== _addressTF) {
        self.model.cityNo = textField.text;
    }
    if (textField== _timeTF) {
        self.model.datTravel = [LKUtils stringDateToString:textField.text withDateFormat:@"yyyy-MM-dd"];
    }
    if (textField== _dayTF) {
        self.model.days = textField.text.integerValue;
    }
    if (textField== _startPriceTF) {
        self.model.perCapital = textField.text;
    }
    if (textField== _endPriceTF) {
        self.model.perCapitalMax = textField.text;
    }
    if (textField== _startPriceTF) {
        self.model.perCapital = textField.text;
    }
    if (textField== _personTF) {
        self.model.peoples = textField.text.integerValue;
    }
}

#pragma mark - action

- (void)btnAction:(UIButton *)sender {
    LKSelectCityViewController *vc = [[LKSelectCityViewController alloc] init];
    vc.isChoose = YES;
    @weakify(self);
    vc.selectCityBlock = ^(NSString *city_id, NSString *city_name) {
        @strongify(self);
        self.model.cityNo = city_id;
        self.model.cityName = city_name;
        self.addressTF.text = city_name;
    };
    [self.lk_viewController.navigationController pushViewController:vc animated:YES];
}
@end
