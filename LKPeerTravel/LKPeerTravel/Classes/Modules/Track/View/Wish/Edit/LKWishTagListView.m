//
//  LKWishTagListView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishTagListView.h"

#define kTagFont [UIFont systemFontOfSize:14]
#define kDeleteTop 8
#define kTitleHeight 30

@implementation LKWishTagListView

{
    UIScrollView *_scrollView;
    NSMutableArray *_tagsView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        
        _tagsView = [NSMutableArray array];
    }
    return self;
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    CGFloat left = 20;
    CGFloat top = 18;
    CGFloat bottom=0;
    
    for (LKWishTagView *view in _tagsView) {
        view.hidden = YES;
    }
    
    for (int i=0; i<tags.count; i++) {
        NSDictionary *title = tags[i];
        LKWishTagView *tagView = [_tagsView objectAt:i];
        if (tagView) {
            tagView.frame = CGRectMake(left, top, 100, kTitleHeight+kDeleteTop);
        } else {
            tagView = [[LKWishTagView alloc] initWithFrame:CGRectMake(left, top, 100, kTitleHeight+kDeleteTop)];
        }
        tagView.dict = title;
        tagView.hidden = NO;
        [_scrollView addSubview:tagView];
         @weakify(self);
        tagView.deleteWishBlock = ^(NSDictionary *dict) {
            @strongify(self);
            if (self.deleteWishBlock) {
                self.deleteWishBlock(dict);
            }
        };
        left = tagView.right+5;
        if (left+tagView.width>_scrollView.width-20) {
            left=20;
            top = tagView.bottom+5;
        }
        bottom = tagView.bottom;
        if (![_tagsView containsObject:tagView]) {
            [_tagsView addObject:tagView];
        }
        
    }
    _scrollView.height = bottom+18;
    self.height = _scrollView.height;
}

+ (CGFloat)heightWithTags:(NSArray *)tags {
    NSInteger line = 1;
    CGFloat left = 20;
    for (int i=0; i<tags.count; i++) {
        NSDictionary *title = tags[i];
        CGSize size = [LKUtils sizeFit:title[@"codDestinationPointName"] withUIFont:kTagFont withFitWidth:MAXFLOAT withFitHeight:30];
        CGFloat tagWidth = size.width+20+kDeleteTop;
        left += tagWidth+5;
        if (left+tagWidth>kScreenWidth-20) {
            line++;
            left=20;
        }
    }
    return 18+line*(30+kDeleteTop)+5*(line-1)+18;
}

@end


@implementation LKWishTagView

{
    UILabel *_titleLabel;
    UIView *_grayView;
    UIButton *_deleteBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeleteTop, 100, 30)];
        _grayView.layer.cornerRadius = 4;
        _grayView.layer.masksToBounds = YES;
        _grayView.backgroundColor = TableBackgroundColor;
        [self addSubview:_grayView];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = kTagFont;
        _titleLabel.textColor = kColorGray1;
        _titleLabel.frame = CGRectMake(10, kDeleteTop, 100, 30);
        [self addSubview:_titleLabel];
        
  
        
//        _deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_service_delete_none"]];
//        _deleteIcon.right = _icon.right+5;
//        _deleteIcon.top = _icon.top-5;
//        [self.contentView addSubview:_deleteIcon];
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_service_delete_none"] forState:UIControlStateNormal];
        _deleteBtn.frame = CGRectMake(0, 0, 24, 24);
        [self addSubview:_deleteBtn];
        [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)deleteAction:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.deleteWishBlock) {
        self.deleteWishBlock(self.dict);
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    CGSize size = [LKUtils sizeFit:title withUIFont:_titleLabel.font withFitWidth:MAXFLOAT withFitHeight:30];
    _titleLabel.text = title;
    _titleLabel.width = size.width;
    
    self.width = _titleLabel.width+20+kDeleteTop;
    
    _grayView.width = _titleLabel.width+20;
    _deleteBtn.right = self.width;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    NSString *title = dict[@"codDestinationPointName"];
    
    CGSize size = [LKUtils sizeFit:title withUIFont:_titleLabel.font withFitWidth:MAXFLOAT withFitHeight:30];
    _titleLabel.text = title;
    _titleLabel.width = size.width;
    
    self.width = _titleLabel.width+20+kDeleteTop;
    
    _grayView.width = _titleLabel.width+20;
    _deleteBtn.right = self.width;
}

@end
