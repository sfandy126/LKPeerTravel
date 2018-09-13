//
//  LKEditSceneTextCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditSceneTextCell.h"

#import <YYTextView.h>


@implementation LKEditSceneTextCell

{
    YYTextView *_textView;
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
    textView.frame = CGRectMake(20, 17, kScreenWidth-40, 183);
    textView.editable = NO;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    
    textView.typingAttributes = @{NSParagraphStyleAttributeName:style};
    
    [self.contentView addSubview:textView];
    _textView = textView;
}

- (void)setData:(LKEditSceneCellModel *)data {
    _data = data;
    
    if ([data.data isKindOfClass:[NSString class]]) {
        _textView.text = data.data;
    }
    
    if (data.txtImageDesc.length>0) {
        _textView.text = data.txtImageDesc;
    }
    
    _textView.height = data.cellHeight-17;
}

@end
