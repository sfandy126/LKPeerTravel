//
//  LKImageBrowseCollectionViewCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKImageBrowseCollectionViewCell.h"
#import "LKZoomingScrollView.h"

@interface LKImageBrowseCollectionViewCell ()
@property (nonatomic,strong) LKZoomingScrollView *scrollView;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation LKImageBrowseCollectionViewCell
{
    CGSize origSize;
    CGPoint origPoint;
}

- (LKZoomingScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[LKZoomingScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_scrollView setMinimumZoomScale:1.0f];
        [_scrollView setMaximumZoomScale:2.0f];
    }
    return _scrollView;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 20*2, 20)];
        _contentLab.text = @"";
        _contentLab.textAlignment =NSTextAlignmentCenter;
        _contentLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _contentLab.font = kFont(12);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.scrollView];
    
    self.contentLab.bottom = kScreenHeight - 150;
    [self.contentView addSubview:self.contentLab];
    
}


- (void)configData:(LKImageBrowseSingleModel *)item{
    [self.scrollView setItem:item isShowLoading:YES];
    
    self.contentLab.text = item.content;

    CGSize contentSize = [LKUtils sizeFit:self.contentLab.text withUIFont:self.contentLab.font withFitWidth:self.contentLab.width withFitHeight:150];
    self.contentLab.height = contentSize.height;
}

@end
