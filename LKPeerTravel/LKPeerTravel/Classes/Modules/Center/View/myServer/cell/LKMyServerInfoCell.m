//
//  LKMyServerInfoCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerInfoCell.h"

@class LKSwitch;
@class LKMyServerDiscountView;
@interface LKMyServerInfoCell ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subTitleLab;
@property (nonatomic,strong) UIImageView *arrowIcon;
@property (nonatomic,strong) LKSwitch *switchBut;
@property (nonatomic,strong) LKMyServerDiscountView *discountView;
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) LKMyServerModel *serverModel;

@end

@implementation LKMyServerInfoCell

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _titleLab.text = @"";
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.textAlignment =  NSTextAlignmentLeft;
        _titleLab.font = kBFont(14);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (UILabel *)subTitleLab{
    if (!_subTitleLab){
        _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        _subTitleLab.text = @"";
        _subTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTitleLab.textAlignment =  NSTextAlignmentRight;
        _subTitleLab.font = kFont(14);
        _subTitleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _subTitleLab;
}

- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_home_into_none"]];
    }
    return _arrowIcon;
}

- (LKSwitch *)switchBut{
    if (!_switchBut) {
        _switchBut = [[LKSwitch alloc] initWithOnImage:[UIImage imageNamed:@"btn_service_switch_on"] offImage:[UIImage imageNamed:@"btn_service_switch_off"] frame:CGRectMake(0, 0, 55, 32)];
        [_switchBut addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBut;
}

- (LKMyServerDiscountView *)discountView{
    if (!_discountView) {
        _discountView = [[LKMyServerDiscountView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130) withRowCount:3];
    }
    return _discountView;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    }
    return _bottomLine;
}

- (void)valueChanged:(LKSwitch *)sender {
    if (self.indexPath.row==2) { // 提供车辆
        self.serverModel.flagCar = sender.isOn;
    } else if (self.indexPath.row==3) { // 提供接机
        self.serverModel.flagPlane = sender.isOn;
    }
 
}

- (NSArray *)obtainDiscoutData {
    return [self.discountView obtainEditData];
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
    [self.contentView addSubview:self.subTitleLab];
    [self.contentView addSubview:self.arrowIcon];
    [self.contentView addSubview:self.switchBut];
    [self.contentView addSubview:self.discountView];
    [self.contentView addSubview:self.bottomLine];
}

- (void)configData:(LKMyServerModel *)model  indexPath:(NSIndexPath *)indexPath{
    NSArray *titles = @[@"价格",@"服务人员上限",@"提供车辆",@"提供接机",@"折扣"];
    self.titleLab.left = 20;
    self.titleLab.centerY = self.height/2.0;
    self.titleLab.text = [NSString stringValue:[titles objectAt:indexPath.row]];
    
    self.arrowIcon.right = kScreenWidth - 16;
    self.arrowIcon.centerY = self.titleLab.centerY;
    self.arrowIcon.hidden = !(indexPath.row ==0 || indexPath.row ==1);
    
    self.indexPath = indexPath;
    self.serverModel = model;
    
    if (indexPath.row==0) {
        self.subTitleLab.text = [NSString stringWithFormat:@"¥%@人/天",model.point];
    }else{
        self.subTitleLab.text = [NSString stringWithFormat:@"%@人",model.pmax];
    }
    self.subTitleLab.centerY = self.titleLab.centerY;
    self.subTitleLab.right = self.arrowIcon.left - 13;
    self.subTitleLab.hidden = self.arrowIcon.hidden;
    
    if (indexPath.row==2) {//是否提供车辆
        self.switchBut.isOn = model.flagCar;
    }
    if (indexPath.row==3) {//是否接机
        self.switchBut.isOn = model.flagPlane;
    }
    self.switchBut.right = kScreenWidth - 15;
    self.switchBut.centerY = self.titleLab.centerY;
    self.switchBut.hidden = !self.arrowIcon.hidden;
    if (indexPath.row==4) {//折扣
        self.switchBut.hidden = YES;
        self.titleLab.top = 18;
        self.discountView.top = self.titleLab.bottom + 20;
        self.discountView.hidden = NO;
        
        [self.discountView configData:[NSArray getArray:model.discounts]];

    }else{
        self.discountView.hidden = YES;
    }
    
 
    self.bottomLine.bottom = self.height;
    self.bottomLine.hidden = (indexPath.row==4);
}


+ (CGFloat)getCellHeight:(LKMyServerModel *)model indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==4) {
        return 50+130+30;
    }
    return 50;
}


@end

@interface LKSwitch ()
@property(nonatomic,strong) UIImage *onImage;
@property(nonatomic,strong) UIImage *offImage;

@end

@implementation LKSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用 -initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage frame:(CGRect)frame 初始化");
    return nil;
}

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage frame:(CGRect)frame{
    NSAssert(onImage&&offImage, @"onImage & offImage 不能为空");
    frame.size = onImage.size;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _onImage = onImage;
        _offImage = offImage;
        [self addTarget:self action:@selector(switchClicked) forControlEvents:UIControlEventTouchUpInside];
        self.isOn = NO;
    }
    return self;
}

- (void)switchClicked {
    self.isOn = !self.isOn;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.fromValue = self.layer.contents;
    animation.toValue = (id)(_isOn ? _onImage.CGImage: _offImage.CGImage);
    animation.duration = .3;
    [self.layer addAnimation: animation forKey: @"animation"];
    
    self.layer.contents = (id)(_isOn ? _onImage.CGImage: _offImage.CGImage);
}

- (void)setFrame:(CGRect)frame {
    if (_onImage) {
        frame.size = _onImage.size;
    }
    super.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return _onImage.size;
}


@end


@interface LKMyServerDiscountView ()

@end

@class LKMyServerDiscountSingleView;
@implementation LKMyServerDiscountView

- (instancetype)initWithFrame:(CGRect)frame withRowCount:(NSInteger )rowCount
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat inval = 20;
        for (int i=0; i<rowCount; i++) {
            LKMyServerDiscountSingleView *singleView = [[LKMyServerDiscountSingleView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
            singleView.top = (singleView.height + inval)*i;
            singleView.tag = 3000+i;
            [self addSubview:singleView];
        }
        
    }
    return self;
}

- (void)configData:(NSArray *)data{
    
    NSInteger index=0;
    for (NSDictionary *dict in data) {
        LKMyServerDiscountSingleView *singleView = [self viewWithTag:3000+index];
        if (singleView) {
            [singleView configData:[NSDictionary getDictonary:dict]];
        }
        index++;
    }
}

- (NSArray *)obtainEditData {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        LKMyServerDiscountSingleView *view = [self viewWithTag:3000+i];
        [temp addObject:[[view obtainEditData] modelToJSONObject]];
    }
    return [NSArray arrayWithArray:temp];
}


@end

@interface LKMyServerDiscountSingleView ()
@property (nonatomic,strong) UITextField *textView1;
@property (nonatomic,strong) UITextField *textView2;
@property (nonatomic,strong) UITextField *textView3;
@property (nonatomic,strong) NSDictionary *data;

@end

@implementation LKMyServerDiscountSingleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UITextField *tf_1 = [self createTextField];
        tf_1.tag = 101;
        tf_1.text = @"";
        tf_1.left = 20;
        [self addSubview:tf_1];
        _textView1 = tf_1;
        
        UILabel *lab_1 = [self createLabel];
        lab_1.tag = 102;
        lab_1.text = @"-";
        lab_1.left = tf_1.right+7;
        lab_1.centerY = tf_1.centerY;
        [self addSubview:lab_1];
        
        UITextField *tf_2 = [self createTextField];
        tf_2.tag = 103;
        tf_2.text = @"";
        tf_2.left = lab_1.right+7;
        tf_2.centerY = tf_1.centerY;
        [self addSubview:tf_2];
        _textView2 = tf_2;
        
        UILabel *lab_2 = [self createLabel];
        lab_2.tag = 104;
        lab_2.text = @"人";
        lab_2.left = tf_2.right+10;
        lab_2.centerY = tf_1.centerY;
        [self addSubview:lab_2];
        
        UILabel *lab_3 = [self createLabel];
        lab_3.tag =106;
        lab_3.text = @"折";
        lab_3.right = self.width - 20;
        lab_3.centerY = tf_1.centerY;
        [self addSubview:lab_3];
        
        UITextField *tf_3 = [self createTextField];
        tf_3.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        tf_3.tag = 105;
        tf_3.text = @"";
        tf_3.right = lab_3.left - 10;
        tf_3.centerY = tf_1.centerY;
        [self addSubview:tf_3];
        _textView3 = tf_3;
        
    }
    return self;
}

- (UITextField *)createTextField{
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 60, self.height)];
    tf.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    tf.layer.cornerRadius = 3.0;
    tf.layer.masksToBounds = YES;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.text = @"";
    tf.font = kBFont(14);
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.textColor = [UIColor colorWithHexString:@"#333333"];
    return tf;
}

- (UILabel *)createLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.text = @"";
    lb.textColor = [UIColor colorWithHexString:@"#333333"];
    lb.textAlignment=NSTextAlignmentCenter;
    lb.font = kBFont(14);
    lb.height = ceil(lb.font.lineHeight);
    CGSize size = [LKUtils sizeFit:@"人" withUIFont:lb.font withFitWidth:100 withFitHeight:lb.height];
    lb.width = size.width;
    return lb;
}

- (void)configData:(NSDictionary *)data{
    self.textView1.text = [NSString  stringValue:[data valueForKey:@"minNum"]];
    self.textView2.text = [NSString  stringValue:[data valueForKey:@"maxNum"]];
    self.textView3.text = [NSString  stringValue:[data valueForKey:@"discountPost"]];
    self.data = [NSDictionary getDictonary:data];
}

- (NSDictionary *)obtainEditData {
    return @{@"minNum":@([self.textView1.text integerValue]),@"maxNum":@([self.textView2.text integerValue]),@"discountPost":[NSString stringValue:self.textView3.text],@"discountNo":[NSString stringValue:self.data[@"discountNo"]]};
}

@end
