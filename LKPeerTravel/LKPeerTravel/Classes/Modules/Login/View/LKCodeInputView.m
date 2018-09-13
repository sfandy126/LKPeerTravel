//
//  LKCodeInputView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCodeInputView.h"

@class LKCodeLabel;
@interface LKCodeInputView ()<UITextFieldDelegate>
@property (nonatomic,strong) LKCodeLabel *codeLab;
@property (nonatomic,strong) UITextField *textField;
@end

@implementation LKCodeInputView

- (LKCodeLabel *)codeLab{
    if (!_codeLab) {
        _codeLab = [[LKCodeLabel alloc] initWithFrame:CGRectZero];
        _codeLab.textAlignment =NSTextAlignmentCenter;
        _codeLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _codeLab.font = [UIFont systemFontOfSize:24.0];
        _codeLab.text = @"";
        _codeLab.codeCount = CODECOUNT;
        _codeLab.codeSize = CGSizeMake(34, 40);
        _codeLab.codeInval = 8.0;
    }
    return _codeLab;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.secureTextEntry = YES;
    }
    return _textField;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.codeLab.frame = self.bounds;
    self.textField.frame = self.codeLab.frame;
    [self addSubview:self.textField];
    [self addSubview:_codeLab];
}

- (void)resignResponder{
    [self.textField resignFirstResponder];
}


#pragma mark - - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //只限制输入字母和数字
    NSCharacterSet *chaset = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:chaset] componentsJoinedByString:@""];
    if ([string isEqualToString:filtered]) {
        // 判断是不是“删除”字符
        if (string.length != 0) {// 不是“删除”字符
            // 判断验证码/密码的位数是否达到预定的位数
            if (textField.text.length < CODECOUNT) {
                self.codeLab.text = [[textField.text stringByAppendingString:string] uppercaseString];
                self.code = self.codeLab.text;
                if (textField.text.length == CODECOUNT -1) {
                    if (self.codeBlock) {
                        self.codeBlock(self.codeLab.text);
                    }
                }
                return YES;
            }
            return NO;
            
        } else { // 是“删除”字符
            self.codeLab.text = [[textField.text substringToIndex:textField.text.length - 1] uppercaseString];
            self.code = self.codeLab.text;
            return YES;
        }
    }else{
        return NO;
    }
}

@end


@interface LKCodeLabel ()

@end

@implementation LKCodeLabel

- (void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    //默认配置
    self.codeCount = self.codeCount>0?self.codeCount:6;
    self.codeInval = self.codeInval>0?self.codeInval:8;
    self.codeSize = self.codeSize.width>0?self.codeSize:CGSizeMake(34, 40);
    
    CGFloat leftX = (self.width - (self.codeSize.width*self.codeCount +self.codeInval*(self.codeCount-1)))/2;
    for (NSInteger i = 0; i < self.codeCount; i++) {
        //绘制区域
        CGFloat oriX = leftX +(self.codeSize.width+self.codeInval)*i;
        CGFloat oriY = (self.height -self.codeSize.height)/2.0;
        CGRect rect = CGRectMake(oriX, oriY, self.codeSize.width, self.codeSize.height);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:2];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, path.CGPath);
        CGContextSetLineWidth(context, 0.5);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#999999"].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        
    }
    
    for (NSInteger i=0; i<self.text.length; i++) {
        NSString *charecterString = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:i]];
        //设置属性
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        attributes[NSFontAttributeName] = self.font;
        attributes[NSForegroundColorAttributeName] = self.textColor;
        //计算Size
        CGSize characterSize = [charecterString sizeWithAttributes:attributes];
        CGFloat oriX = leftX +(self.codeSize.width+self.codeInval)*i+(self.codeSize.width -characterSize.width)/2.0;
        CGFloat oriY = (self.height -self.codeSize.height)/2.0+(self.codeSize.height-characterSize.height)/2.0;
        CGPoint vertificationCodeDrawStartPoint = CGPointMake(oriX, oriY);
        [charecterString drawAtPoint:vertificationCodeDrawStartPoint withAttributes:attributes];
    }
    
}

@end
