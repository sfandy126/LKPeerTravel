//
//  LKBaseCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseCell.h"

@implementation LKBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createView];
    }
    return self;
}

- (void)createView{
    
}

- (void)configData:(id)data{
    
}

+ (CGFloat )getCellHeight:(id)data{
    return CGFLOAT_MIN;
}

@end
