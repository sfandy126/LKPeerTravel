//
//  LKNavigationBar.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKNavigationBar.h"

@interface LKNavigationBar ()

@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UIBarButtonItem *rightOhterButton;

@property (nonatomic, strong) UILabel *nameLab;

@end

@implementation LKNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setShadowImage:[[UIImage alloc] init]];
        [self initSubView];
    }
    return self;
}

- (void)initSubView  {
    
    [self setShadowImage:[[UIImage alloc] init]];
    
    
    self.backgroundColor = [UIColor clearColor];
    self.navigationItem = [[UINavigationItem alloc] init];
    [self pushNavigationItem:_navigationItem animated:NO];
  
    [self setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0]];
    
    self.nameLab.text = @"";
    
    [self setNavigationBarAlpha:0];
}



- (void)setLeftItemImage:(NSString *)ImageName target:(id)target action:(SEL)action {
    self.leftButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_leftButton setImage:[UIImage imageNamed:ImageName]];
    _leftButton.tintColor = [UIColor hexColor333333];
    [_navigationItem setLeftBarButtonItem:_leftButton];
}

- (void)setRightItemImage:(NSString *)ImageName target:(id)target action:(SEL)action {
    self.rightButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_rightButton setImage:[UIImage imageNamed:ImageName]];
    _rightButton.tintColor = [UIColor hexColor333333];
    [_navigationItem setRightBarButtonItem:_rightButton];
}

- (void)setRightItemsImages:(NSArray *)imageNames  target:(id)target action:(SEL)action  ohterAction:(SEL)otherAction{
    self.rightButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_rightButton setImage:[UIImage imageNamed:[NSString stringValue:[imageNames objectAt:0]]]];
    _rightButton.tintColor = [UIColor hexColor333333];
    
    self.rightOhterButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:otherAction];
    [_rightOhterButton setImage:[UIImage imageNamed:[NSString stringValue:[imageNames objectAt:1]]]];
    _rightOhterButton.tintColor = [UIColor hexColor333333];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    [_navigationItem setRightBarButtonItems:@[_rightButton,_rightOhterButton,spaceItem]];
}

- (void)setLeftItem:(NSString *)name target:(id)target tintColor:(UIColor*)color  action:(SEL)action{
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:target action:action];
    _leftButton.tintColor = color;
    [_navigationItem setLeftBarButtonItem:_leftButton];
}

- (void)setRightItem:(NSString *)name target:(id)target tintColor:(UIColor*)color  action:(SEL)action {
    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:target action:action];
    _rightButton.tintColor = color;
    [_navigationItem setRightBarButtonItem:_rightButton];
}


- (void)setRightItemWithFontOfSize:(UIFont *)font {
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavigationHeight - 44, kScreenWidth - 100, 44)];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:18];
        _nameLab.textColor = [UIColor hexColor333333];
        _nameLab.centerX = kScreenWidth * 0.5;
        [self addSubview:_nameLab];
    }
    return _nameLab;
}

- (void)setTitle:(NSString *)title {
    _nameLab.text = title;
}

- (void)setTitleHidden:(BOOL)hidden {
    _nameLab.hidden = hidden;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
            view.top = [UIApplication sharedApplication].statusBarFrame.size.height;
        } else if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            view.frame = self.bounds;
        }
    }
    [self setNavigationBarAlpha:self.naviAlpha];
}

- (void)setOffsetY:(CGFloat)offsetY alphaBlock:(void(^)(CGFloat alpha))alphaBlock {
    
    CGFloat alpha = 0;
    if (offsetY > 50) {
        alpha = MIN(1, 1 - ((50 + kNavigationHeight - offsetY) / kNavigationHeight));
        
        [self setNavigationBarAlpha:alpha];
    }
    else {
        [self setNavigationBarAlpha:alpha];
    }
    self.naviAlpha = alpha;
    if (alphaBlock) {
        alphaBlock(alpha);
    }
    [self setNavigaionBarItemsAlpha:alpha];
}

- (void)setNavigationBarAlpha:(CGFloat)alpha {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] || [view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            view.alpha = alpha;
        }
    }
}

/**
 ** 根据alpha值设置right left title的相对颜色值
 **/
- (void)setNavigaionBarItemsAlpha:(CGFloat)alpha {
  
    UIColor * color;
    
    if (alpha > 0) {
        color =  [UIColor hexColor333333];
    }
    else {
        color = [UIColor whiteColor];
    }
    _leftButton.tintColor = color;
    _rightButton.tintColor = color;
    _nameLab.textColor = color;
    _rightOhterButton.tintColor = color;
}

- (void)updataNavigationAlpha:(CGFloat)alpha {
    self.naviAlpha = alpha;
    [self setNavigationBarAlpha:alpha];
    [self setNavigaionBarItemsAlpha:alpha];
}

- (void)setRightTintColor:(UIColor *)color nightColor:(UIColor *)nightColor {
    _rightButton.tintColor = color;
}

- (void)setLeftTintColor:(UIColor *)color nightColor:(UIColor *)nightColor {
    _leftButton.tintColor = color;
}

- (void)setTitleColor:(UIColor *)color nightColor:(UIColor *)nightColor {
    _nameLab.textColor = color;
}

- (void)setItemsColor:(UIColor *)color nightColor:(UIColor *)nightColor {
 
        _leftButton.tintColor = color;
        _rightButton.tintColor = color;
        _rightOhterButton.tintColor = color;
        _nameLab.textColor = color;
}

- (void)setRightBarButtonItems:(NSArray *)items {
    [_navigationItem setRightBarButtonItems:items];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item {
    [_navigationItem setRightBarButtonItem:item];
}

- (void)setTitleView:(UIView*)titleView {
    self.navigationItem.titleView = titleView;
    
    if (_nameLab) {
        [_nameLab removeFromSuperview];
        _nameLab  = nil;
    }
}

- (void)setTitleAlpha:(CGFloat)alpha {
    _nameLab.alpha = alpha;
}

- (void)setLeftItemHidden:(BOOL)isHidden{
    if (isHidden) {
        [_navigationItem setLeftBarButtonItem:nil];
    }else{
        [_navigationItem setLeftBarButtonItem:_leftButton];
    }
}

@end
