//
//  UILabel+LKLabel.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LKLabel)

///设置行间距之后的富文本
@property (nonatomic,strong) NSAttributedString *attriText;

///设置行间距
- (void)setLineSpaceing:(CGFloat)space;

@end
