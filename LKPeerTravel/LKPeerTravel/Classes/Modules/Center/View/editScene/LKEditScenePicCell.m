//
//  LKEditScenePicCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditScenePicCell.h"

@interface LKEditScenePicCell ()

@property (nonatomic, strong) UIImageView *iv;

@end

@implementation LKEditScenePicCell


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

- (void)setData:(LKEditSceneCellModel *)data {
    _data = data;
    if ([data.data isKindOfClass:[UIImage class]]) {
        UIImage *img = (UIImage *)data.data;
        _iv.height = img.size.height*(kScreenWidth-40)/img.size.width;
        _iv.image = img;
    }
    
    if (data.codImageUrl.length) {
         @weakify(self);
        [_iv sd_setImageWithURL:[NSURL URLWithString:data.codImageUrl] placeholderImage:data.data  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            @strongify(self);
            if (image) {
                self.iv.height = image.size.height*(kScreenWidth-40)/image.size.width;
                self.iv.image = image;
            }
        }];
    }
}

@end
