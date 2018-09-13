//
//  LKOrderDetailEvaluationCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailEvaluationCell.h"

#import <YYTextView.h>

#import "LKRatingView.h"

@implementation LKOrderDetailEvaluationCell

{
    UIImageView *_inputBgIV;
    UIButton *_replyBtn;
    UILabel *_replyGuide;
    UILabel *_commentDesc;
    YYTextView *_textView;
    LKRatingView *_rationView;
}

+ (CGFloat)heightWithModel:(LKOrderDetailModel *)model {
    CGFloat height = 17+ceil(kFont(14).lineHeight);
    NSString *comment = [NSString stringValue:model.commentDict[@"txtCommentContent"]];
    CGSize size = [LKUtils sizeFit:comment withUIFont:kFont(12) withFitWidth:kScreenWidth-40 withFitHeight:CGFLOAT_MAX];
    height+=14+size.height+17;
    if (model.commentFlag) { // 已评价
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            if (model.replayFlag==0) { // 未回复
                height += 123+17+34;
            } else { // 已回复
                NSString *reply = [NSString stringValue:model.commentDict[@"omsReplayContent"]];
                size = [LKUtils sizeFit:reply withUIFont:kFont(12) withFitWidth:kScreenWidth-60 withFitHeight:MAXFLOAT];
                height+= size.height+30+17;
            }
        } else {
            if (model.replayFlag==1) { // 已回复
                NSString *reply = [NSString stringValue:model.commentDict[@"omsReplayContent"]];
                size = [LKUtils sizeFit:reply withUIFont:kFont(12) withFitWidth:kScreenWidth-60 withFitHeight:MAXFLOAT];
                height+= size.height+30+17;
            }
        }
      
    } else {
        height +=123+17+34;
    }
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *label = [UILabel new];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.frame = CGRectMake(20, 17, 250, ceil(label.font.lineHeight));
    label.text = @"客户评价";
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        label.text = @"我的评价";
    }
    [self.contentView addSubview:label];
    
    UILabel *rate = [UILabel new];
    rate.font = [UIFont boldSystemFontOfSize:14];
    rate.textColor = [UIColor colorWithHexString:@"#333333"];
    rate.frame = CGRectMake(20, 17, 50, ceil(label.font.lineHeight));
    rate.text = @"评分";
    rate.textAlignment = NSTextAlignmentRight;
  
    [self.contentView addSubview:rate];
    
    _rationView = [[LKRatingView alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
    _rationView.right = kScreenWidth+10;
    _rationView.centerY = label.centerY;
    [self.contentView addSubview:_rationView];
    
    rate.right = _rationView.left+10;
    
    UILabel *desc = [UILabel new];
    desc.font = [UIFont systemFontOfSize:12];
    desc.textColor = [UIColor colorWithHexString:@"#333333"];
    desc.frame = CGRectMake(20, label.bottom+14, kScreenWidth-40, ceil(label.font.lineHeight));
    desc.text = @"个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介个人简介";
    desc.numberOfLines = 0;
    [desc sizeToFit];
    [self.contentView addSubview:desc];
    _commentDesc = desc;
    
    UIImageView *inputBgIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, desc.bottom+17, kScreenWidth-40, 123)];
    inputBgIV.image = [[UIImage imageNamed:@"img_order_answer_block"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    inputBgIV.userInteractionEnabled = YES;
    [self.contentView addSubview:inputBgIV];
    _inputBgIV = inputBgIV;
    
    YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(10, 10, inputBgIV.width-20, inputBgIV.height-20)];
    textView.font = [UIFont systemFontOfSize:12];
    textView.textColor = [UIColor colorWithHexString:@"#333333"];
    textView.backgroundColor = [UIColor clearColor];
    textView.placeholderText = @"点击回复";
    textView.placeholderTextColor = [UIColor colorWithHexString:@"#c8c8c8"];
    [inputBgIV addSubview:textView];
    _textView = textView;
    
    UILabel *inputDesc = [UILabel new];
    inputDesc.font = [UIFont systemFontOfSize:12];
    inputDesc.textColor = [UIColor colorWithHexString:@"#333333"];
    inputDesc.frame = CGRectMake(20, inputBgIV.bottom+20, inputBgIV.width, ceil(inputDesc.font.lineHeight));
    inputDesc.text = @"您只能回复客户一次,且不能更改!";
    [self.contentView addSubview:inputDesc];
    _replyGuide = inputDesc;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, inputBgIV.bottom+10, 80, 34);
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_loading_code_none"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [btn setTitle:@"回复" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.right = kScreenWidth-20;
    [self.contentView addSubview:btn];
    _replyBtn = btn;
}

- (void)btnAction {
    if (_textView.text.length==0) {
        [LKUtils showMessage:@"请输入内容"];
        return;
    }
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        if (_rationView.star == 0) {
            [LKUtils showMessage:@"请评分"];
            return;
        }
    }
    if ([self.mainView.delegate respondsToSelector:@selector(guideReplyWithInputStr:level:)]) {
        [self.mainView.delegate guideReplyWithInputStr:_textView.text level:_rationView.star];
    }
}

- (void)setModel:(LKOrderDetailModel *)model {
    _model = model;
    
    _commentDesc.text = model.commentDict[@"txtCommentContent"];
    [_commentDesc sizeToFit];
    
    CGFloat height = 0;
    CGSize size;
    
    _inputBgIV.hidden = YES;
    _replyBtn.hidden = YES;
    _replyGuide.hidden = YES;
    
    if (model.commentFlag) { // 已评价
        _rationView.enable = NO;
        _rationView.starNumber = [model.commentDict[@"level"] integerValue];
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            if (model.replayFlag==0) { // 未回复
                height = 123;
                
                _inputBgIV.hidden = NO;
                _replyBtn.hidden = NO;
                _replyGuide.hidden = NO;
                
            } else { // 已回复
                NSString *reply = [NSString stringValue:model.commentDict[@"omsReplayContent"]];
                size = [LKUtils sizeFit:reply withUIFont:kFont(12) withFitWidth:kScreenWidth-60 withFitHeight:MAXFLOAT];
                height = size.height+30;
                
                _inputBgIV.hidden = NO;
                _textView.text = [NSString stringWithFormat:@"我的回复:%@",reply];
                _textView.editable = NO;
            }
        } else {
            if (model.replayFlag==1) { // 已回复
                NSString *reply = [NSString stringValue:model.commentDict[@"omsReplayContent"]];
                size = [LKUtils sizeFit:reply withUIFont:kFont(12) withFitWidth:kScreenWidth-60 withFitHeight:MAXFLOAT];
                height = size.height+30;
                _textView.text = [NSString stringWithFormat:@"私人助手（%@）的回复：%@",model.guideName,reply];
                _textView.editable = NO;
                _inputBgIV.hidden = NO;
            }
        }
        
    } else {
        height = 123;
        _inputBgIV.hidden = NO;
        _replyBtn.hidden = NO;
        _replyGuide.hidden = NO;
        _replyGuide.text = @"您只能评价一次，且不能修改";
        _textView.placeholderText = @"输入评价";
        [_replyBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    
    _inputBgIV.height = height;
    _inputBgIV.top = _commentDesc.bottom+17;
    _textView.height = height - 10;
    
    _replyBtn.top = _inputBgIV.bottom+10;
    _replyGuide.top = _inputBgIV.bottom+20;
    
}

@end
