//
//  LKZoomingScrollView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKZoomingScrollView.h"

@interface LKZoomingScrollView ()<UIScrollViewDelegate>
@property (nonatomic) BOOL isFull;

@end

@implementation LKZoomingScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        UIImageView* bigImg = [[UIImageView alloc] initWithFrame:self.bounds];
        bigImg.contentMode = UIViewContentModeScaleAspectFit;
        bigImg.userInteractionEnabled = YES;
        [self addSubview:bigImg];
        self.bigImg = bigImg;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(hanleLongTap:)];
        longGesture.minimumPressDuration = 1;
        [self addGestureRecognizer:longGesture];
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }
    return self;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    if (self.isFull) {
        if (self.zoomScale < self.maximumZoomScale) {
            [self setZoomScale:self.maximumZoomScale animated:YES];
        }else {
            [self setZoomScale:self.minimumZoomScale animated:YES];
        }
    }
    else {
        CGFloat zoomScale = self.zoomScale;
        zoomScale = (zoomScale == 1.0) ? 2.0 : 1.0;
        CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)hanleLongTap:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //长按操作
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture {
        //单击操作
}

- (void)resetScale {
    [self setZoomScale:1.0f];
    _bigImg.frame = self.bounds;
}

- (void)setItem:(LKImageBrowseSingleModel *)item isShowLoading:(BOOL)isShow{
    
    [self resetScale];
    
    [_bigImg sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error && image) {
            [self adjustImage];
        }
    }];

}

- (void)adjustImage {
    
    if (_bigImg.image == nil) {
        NSLog(@"图片为空不做操作");
        return;
    }
    
    CGFloat height = kScreenWidth * _bigImg.image.size.height / _bigImg.image.size.width;
    
    if(height > kScreenHeight) {
        _isFull = YES;
        _bigImg.width = kScreenWidth;
        _bigImg.height = height;
        _bigImg.top = 0;
        [self setContentSize:_bigImg.size];
    }
    else {
        _isFull = NO;
        _bigImg.width = kScreenWidth;
        _bigImg.height = height;
        _bigImg.center = self.center;
        [self setContentSize:_bigImg.size];
    }
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _bigImg;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat svw = scrollView.bounds.size.width;
    CGFloat svh = scrollView.bounds.size.height;
    CGFloat vw = _bigImg.frame.size.width;
    CGFloat vh = _bigImg.frame.size.height;
    CGRect f = _bigImg.frame;
    if (vw < svw)
        f.origin.x = (svw - vw) / 2.0;
    else
        f.origin.x = 0;
    if (vh < svh)
        f.origin.y = (svh - vh) / 2.0;
    else
        f.origin.y = 0;
    _bigImg.frame = f;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale animated:YES];
}



@end
