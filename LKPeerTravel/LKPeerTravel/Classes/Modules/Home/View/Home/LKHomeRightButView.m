//
//  LKHomeRightButView.m
//  LKPeerTravel
//
//  Created by LK on 2018/8/5.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeRightButView.h"

@interface LKHomeRightButView ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation LKHomeRightButView

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = kFont(12);
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.height = ceil(_titleLabel.font.lineHeight);
    }
    return _titleLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        
        [self g_addTapWithTarget:self action:@selector(tapAction)];
    }
    return self;
}

- (void)tapAction{
    if (self.selectedBlock) {
        self.selectedBlock();
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    CGSize size = [LKUtils sizeFit:self.titleLabel.text withUIFont:self.titleLabel.font withFitWidth:100 withFitHeight:self.titleLabel.height];
    self.titleLabel.width = size.width;
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
    
    [self setNeedsLayout];
}

- (void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    self.imageView.size = imageSize;
    
    [self setNeedsLayout];
}

- (void)setInval:(CGFloat)inval{
    _inval = inval;
    
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat titleLeftX = (self.width - (self.titleLabel.width + self.imageView.width + self.inval))/2.0;
    self.titleLabel.left = titleLeftX;
    self.imageView.left = self.titleLabel.right +self.inval;
    self.titleLabel.centerY = self.height/2.0;
    self.imageView.centerY = self.titleLabel.centerY;
    

}

@end

