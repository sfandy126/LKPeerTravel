//
//  UILabel+LKLabel.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UILabel+LKLabel.h"
#import <objc/runtime.h>

static const char * LKLABEL_ATTRITEXT = "LKLABEL_ATTRITEXT";

@implementation UILabel (LKLabel)
@dynamic attriText;

- (void)setLineSpaceing:(CGFloat)space{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing =space;
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attri addAttributes:@{NSFontAttributeName:self.font,
                           NSParagraphStyleAttributeName:style,
                           } range:NSMakeRange(0, attri.length)];
    
    self.attriText = [attri copy];
}

- (void)setAttriText:(NSAttributedString *)attriText{
    objc_setAssociatedObject(self, LKLABEL_ATTRITEXT, attriText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)getAttriText{
    objc_getAssociatedObject(self, LKLABEL_ATTRITEXT);
}

@end
