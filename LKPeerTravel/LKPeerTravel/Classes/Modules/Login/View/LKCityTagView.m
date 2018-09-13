//
//  LKCityTagView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCityTagView.h"

@class LKTag,LKTagButton,LKTagView;
@interface LKCityTagView ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKTagView *tagView;
@end

@implementation LKCityTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
    }
    return self;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, self.width, 0)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.text = @"热门城市";
        _titleLab.font = [UIFont systemFontOfSize:18.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLab.height = ceil(_titleLab.font.lineHeight);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (LKTagView *)tagView{
    if (!_tagView) {
        CGFloat oriY = self.titleLab.bottom +20;
        _tagView = [[LKTagView alloc] initWithFrame:CGRectMake(0, oriY, self.width, self.height -oriY)];
        //整个tagView对应其SuperView的上左下右距离
        _tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        //item之间的距离
        _tagView.interitemSpacing = 10;
        //上下行之间的距离
        _tagView.lineSpacing = 10;
        //最大宽度
        _tagView.preferredMaxLayoutWidth = self.width;
        _tagView.regularHeight = 30;
    }
    return _tagView;
}


- (void)configData:(NSArray <LKCityTagModel *>*)dataSource{
    [self.tagView removeAllTags];
    // 初始化标签
    for (LKCityTagModel *item in dataSource) {
        [self.tagView addTag:item];
    }
    // 点击事件回调
    @weakify(self);
    self.tagView.didTapTagAtIndex = ^(LKCityTagModel *item) {
        @strongify(self);
        if (self.selectedBlock) {
            self.selectedBlock(item);
        }
    };
    
    [self.tagView layoutSubviews];
    [self addSubview:self.tagView];
}

@end


@implementation LKTagButton

+ (LKTagButton *)buttonWithTag: (LKCityTagModel *)item {
    LKTagButton *btn = [super buttonWithType:UIButtonTypeCustom];
    btn.item = item;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:[NSString stringValue:item.title] forState:UIControlStateNormal];
    [btn setTitle:[NSString stringValue:item.title] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    btn.layer.cornerRadius = 3.0;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //标签相对于自己容器的上左下右的距离
    btn.contentEdgeInsets =  UIEdgeInsetsMake(0, 10, 0, 10);
    return btn;
}

@end

@interface LKTagView ()

@property (assign, nonatomic) BOOL didSetup;
@property (nonatomic,assign) BOOL isIntrinsicWidth;  //!<是否宽度固定
@property (nonatomic,assign) BOOL isIntrinsicHeight; //!<是否高度固定
@property (nonatomic,strong) LKTagButton *lastBut;//上一次点击的按钮

@end

@implementation LKTagView

// 重写setter给bool赋值
- (void)setRegularWidth:(CGFloat)intrinsicWidth
{
    if (_regularWidth != intrinsicWidth) {
        _regularWidth = intrinsicWidth;
        if (intrinsicWidth == 0) {
            self.isIntrinsicWidth = NO;
        }
        else
        {
            self.isIntrinsicWidth = YES;
        }
    }
    
}

- (void)setRegularHeight:(CGFloat)intrinsicHeight
{
    if (_regularHeight != intrinsicHeight) {
        _regularHeight = intrinsicHeight;
        if (intrinsicHeight == 0)
        {
            self.isIntrinsicHeight = NO;
        }
        else
        {
            self.isIntrinsicHeight = YES;
        }
    }
}

#pragma mark - Lifecycle

-(CGSize)intrinsicContentSize {

    NSArray *subviews = self.subviews;
    UIView *previousView = nil;
    CGFloat topPadding = self.padding.top;
    CGFloat bottomPadding = self.padding.bottom;
    CGFloat leftPadding = self.padding.left;
    CGFloat rightPadding = self.padding.right;
    CGFloat itemSpacing = self.interitemSpacing;
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat currentX = leftPadding;
    CGFloat intrinsicHeight = topPadding;
    CGFloat intrinsicWidth = leftPadding;
    
    if (!self.singleLine && self.preferredMaxLayoutWidth > 0) {
        NSInteger lineCount = 0;
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            // 宽度和高度通过参数的0或者非0来进行赋值
            CGFloat width = self.isIntrinsicWidth?self.regularWidth:size.width;
            CGFloat height = self.isIntrinsicHeight?self.regularHeight:size.height;
            if (previousView) {
                //                CGFloat width = size.width;
                currentX += itemSpacing;
                if (currentX + width + rightPadding <= self.preferredMaxLayoutWidth) {
                    currentX += width;
                } else {
                    lineCount ++;
                    currentX = leftPadding + width;
                    intrinsicHeight += height;
                }
            } else {
                lineCount ++;
                intrinsicHeight += height;
                currentX += width;
            }
            previousView = view;
            intrinsicWidth = MAX(intrinsicWidth, currentX + rightPadding);
        }
        
        intrinsicHeight += bottomPadding + lineSpacing * (lineCount - 1);
    } else {
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            intrinsicWidth += self.isIntrinsicWidth?self.regularWidth:size.width;
        }
        intrinsicWidth += itemSpacing * (subviews.count - 1) + rightPadding;
        intrinsicHeight += ((UIView *)subviews.firstObject).intrinsicContentSize.height + bottomPadding;
    }
    
    return CGSizeMake(intrinsicWidth, intrinsicHeight);
}

- (void)layoutSubviews {
    if (!self.singleLine) {
        self.preferredMaxLayoutWidth = self.frame.size.width;
    }
    
    [super layoutSubviews];
    
    [self layoutTags];
}

#pragma mark - Custom accessors

- (void)setPreferredMaxLayoutWidth: (CGFloat)preferredMaxLayoutWidth {
    if (preferredMaxLayoutWidth != _preferredMaxLayoutWidth) {
        _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
        _didSetup = NO;
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - Private

- (void)layoutTags {
    if (self.didSetup) {
        return;
    }
    
    NSArray *subviews = self.subviews;
    UIView *previousView = nil;
    CGFloat topPadding = self.padding.top;
    CGFloat leftPadding = self.padding.left;
    CGFloat rightPadding = self.padding.right;
    CGFloat itemSpacing = self.interitemSpacing;
    CGFloat lineSpacing = self.lineSpacing;
    CGFloat currentX = leftPadding;
    
    if (!self.singleLine && self.preferredMaxLayoutWidth > 0) {
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            CGFloat width1 = self.isIntrinsicWidth?self.regularWidth:size.width;
            CGFloat height1 = self.isIntrinsicHeight?self.regularHeight:size.height;
            if (previousView) {
                //                CGFloat width = size.width;
                currentX += itemSpacing;
                if (currentX + width1 + rightPadding <= self.preferredMaxLayoutWidth) {
                    view.frame = CGRectMake(currentX, CGRectGetMinY(previousView.frame), width1, height1);
                    currentX += width1;
                } else {
                    CGFloat width = MIN(width1, self.preferredMaxLayoutWidth - leftPadding - rightPadding);
                    view.frame = CGRectMake(leftPadding, CGRectGetMaxY(previousView.frame) + lineSpacing, width, height1);
                    currentX = leftPadding + width;
                }
            } else {
                CGFloat width = MIN(width1, self.preferredMaxLayoutWidth - leftPadding - rightPadding);
                view.frame = CGRectMake(leftPadding, topPadding, width, height1);
                currentX += width;
            }
            
            previousView = view;
        }
    } else {
        for (UIView *view in subviews) {
            CGSize size = view.intrinsicContentSize;
            view.frame = CGRectMake(currentX, topPadding, self.isIntrinsicWidth?self.regularWidth:size.width, self.isIntrinsicHeight?self.regularHeight:size.height);
            currentX += self.isIntrinsicWidth?self.regularWidth:size.width;
            
            previousView = view;
        }
    }
    
    self.didSetup = YES;
}

#pragma mark - IBActions

- (void)onTag: (LKTagButton *)btn {
    if (self.lastBut && self.lastBut == btn) {
        return;
    }
    //改变点击效果
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[LKTagButton class]]) {
            LKTagButton *tagBut = (LKTagButton *)view;
            if (btn == tagBut) {
                [tagBut setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FED631"] andHeight:btn.size] forState:UIControlStateNormal];
                [tagBut setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FED631"] andHeight:btn.size] forState:UIControlStateHighlighted];
            }else{
                [tagBut setBackgroundImage:nil forState:UIControlStateNormal];
                [tagBut setBackgroundImage:nil forState:UIControlStateHighlighted];
            }
        }
    }
    self.lastBut = btn;
    if (self.didTapTagAtIndex) {
        self.didTapTagAtIndex(btn.item);
    }
}

#pragma mark - Public

- (void)addTag: (LKCityTagModel *)tag {
    NSParameterAssert(tag);
    LKTagButton *btn = [LKTagButton buttonWithTag: tag];
    [btn addTarget: self action: @selector(onTag:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: btn];
    
    self.lastBut = nil;
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)removeAllTags {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.lastBut = nil;
    self.didSetup = NO;
    [self invalidateIntrinsicContentSize];
}

@end




