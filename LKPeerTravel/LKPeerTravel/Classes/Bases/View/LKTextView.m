//
//  LKTextView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTextView.h"

@implementation LKTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layoutManager.allowsNonContiguousLayout = NO;
        
        // 添加一个显示提醒文字的label（显示占位文字的label）
        UILabel *placehoderLabel = [[UILabel alloc] init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
        
        // 设置默认的占位文字颜色
        self.placehoderColor = [UIColor lightGrayColor];
        
        // 设置默认的字体
        self.font = [UIFont systemFontOfSize:14];
        self.placehoderLeft = 5;
        self.placehoderTop = 8;
        
        // 当用户通过键盘修改了self的文字，self就会自动发出一个UITextViewTextDidChangeNotification通知
        // 一旦发出上面的通知，就会调用self的textDidChange方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
    // text属性：只包括普通的文本字符串
    // attributedText：包括了显示在textView里面的所有内容（表情、text）
    self.placehoderLabel.hidden = self.hasText;
}


#pragma mark - 公共方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

/**
 * 图文混排时，设置的是NSAttributedString
 */
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    
    _placehoder = placehoder;
    // 设置文字
    self.placehoderLabel.text = placehoder;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)setAttriPlaceholder:(NSAttributedString *)attriPlaceholder {
    _attriPlaceholder = [attriPlaceholder copy];
    
    self.placehoderLabel.attributedText = attriPlaceholder;
    
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    
    // 设置颜色
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placehoderLabel.font = font;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placehoderLabel.top = self.placehoderTop;
    self.placehoderLabel.left = self.placehoderLeft;
    self.placehoderLabel.width = self.width - 2 * self.placehoderLabel.left;
    
    [self.placehoderLabel sizeToFit];
    if (self.placehoderLabel.width > self.width - 2 * self.placehoderLabel.left) {
        self.placehoderLabel.width = self.width - 2 * self.placehoderLabel.left;
    }
}

- (void)updatePlacehoderLableFrame{
    self.placehoderLabel.height = self.height - self.placehoderLabel.top *2;
    self.placehoderLabel.centerY = self.centerY;
}


@end
