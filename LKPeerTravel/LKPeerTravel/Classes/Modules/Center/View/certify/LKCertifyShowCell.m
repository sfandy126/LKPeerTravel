//
//  LKCertifyShowCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCertifyShowCell.h"

#import "LKActionSheetViewController.h"
#import "LKImagePicker.h"
#import "LKUploadManager.h"

#import "UIImage+RemoteSize.h"

@interface LKCertifyShowCell () <LKActionSheetViewControllerDelegate>

@end

@implementation LKCertifyShowCell

{
    UILabel *_titleLabel;
    UIImageView *_picIV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(21, 18, kScreenWidth-42, ceil(_titleLabel.font.lineHeight));
    [self.contentView addSubview:_titleLabel];
    
    _picIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, _titleLabel.bottom+10, kScreenWidth-40, 200)];
    _picIV.userInteractionEnabled = YES;
    [self.contentView addSubview:_picIV];
    
     @weakify(self);
    [_picIV lk_addTapGestureRecognizerWithBlock:^(UIGestureRecognizer *gestureRecognizer) {
        @strongify(self);
        [self addPic];
    }];
}

- (void)addPic {
    LKActionSheetViewController *sheet = [[LKActionSheetViewController alloc] initWithItems:@[@"相册",@"相机"] title:@"选择图片来源" delegate:self];
    [self.lk_viewController presentViewController:sheet animated:YES completion:nil];
}

- (void)actionSheetController:(LKActionSheetViewController *)actionSheetController didClickIndex:(NSInteger)index {
    @weakify(self);
    if (index==0) { // 相册
        [LKImagePicker getPictureWithBlock:^(UIImage *image) {
            @strongify(self);
            [self uploadImage:image];
        }];
    } else { // 相机
        [LKImagePicker getCameraWithBlock:^(UIImage *image) {
            @strongify(self);
            [self uploadImage:image];
        }];
    }
}

- (void)uploadImage:(UIImage *)image {
     @weakify(self);
    [LKUploadManager uploadImage:image completeBlock:^(LKResult *ret, NSError *error) {
        if (ret.success) {
            @strongify(self);
            NSString *url = ret.data[@"data"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CGSize size = [UIImage getImageSizeWithURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.model.url = url;
                    self.model.pic_width = [NSString stringWithFormat:@"%f",size.width];
                    self.model.pic_height = [NSString stringWithFormat:@"%f",size.height];
                    if (self.addPicFinished) {
                        self.addPicFinished();
                    }
                });
            });
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    _titleLabel.text = data[@"title"];
    
    [_picIV sd_setImageWithURL:[NSURL URLWithString:data[@"image"]]];
    
    CGFloat width = [data[@"width"] floatValue];
    CGFloat height = [data[@"height"] floatValue];
    
    //_picIV.width/_picIV.height = width/height;
    if (width>0 && height>0) {
        _picIV.height = _picIV.width*height / width;
    }
}

- (void)setModel:(LKCertifyShowModel *)model {
    _model = model;
    
    _titleLabel.text = model.title;
    
    if (model.url.length) {
        [_picIV sd_setImageWithURL:[NSURL URLWithString:model.url]];
        
        CGFloat width = [model.pic_width floatValue];
        CGFloat height = [model.pic_height floatValue];
        
        if (width>0 && height>0) {
            _picIV.height = _picIV.width*height / width;
        }
        
        _picIV.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        _picIV.backgroundColor = kColorGray6;
        _picIV.image = [UIImage imageNamed:@"icon_fb_jia"];
        _picIV.contentMode = UIViewContentModeCenter;
    }
  
}

@end
