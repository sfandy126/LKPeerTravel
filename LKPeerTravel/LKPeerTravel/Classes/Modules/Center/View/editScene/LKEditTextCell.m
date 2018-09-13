//
//  LKEditTextCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditTextCell.h"

#import <YYTextView.h>

@implementation LKEditTextCell

{
    YYTextView *_textView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI {
    YYTextView *textView = [YYTextView new];
    textView.font = kFont(14);
    textView.placeholderText = @"点击输入景点介绍";
    textView.placeholderTextColor = kColorGray2;
    textView.textColor = kColorGray1;
    textView.placeholderFont = kFont(14);
    textView.frame = CGRectMake(20, 17, kScreenWidth-40, 160-34);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    
    textView.typingAttributes = @{NSParagraphStyleAttributeName:style};
    
    [self.contentView addSubview:textView];
    _textView = textView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:YYTextViewTextDidChangeNotification object:textView];
    
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    _textView.placeholderText = placeholder;
}

- (void)textFieldTextDidChange:(NSNotification *)noti {
    self.model.data = _textView.text;
}

- (NSString *)addText {
    if (_textView.text.length==0) {
        return @"";
    }
    NSString *text = [_textView.text copy];
    _textView.text = @"";
    return text;
}

@end
