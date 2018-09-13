//
//  LKEditPictureCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditPictureCell.h"



@implementation LKEditPictureCell

{
    UIImageView *_iv;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-40, 0)];
    [self.contentView addSubview:_iv];
}

- (void)setData:(id)data {
    _data = data;
    if ([data isKindOfClass:[UIImage class]]) {
        UIImage *img = (UIImage *)data;
        _iv.height = img.size.height*(kScreenWidth-40)/img.size.width;
        _iv.image = img;
    }
}

@end
