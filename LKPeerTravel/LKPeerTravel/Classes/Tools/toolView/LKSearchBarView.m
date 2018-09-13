//
//  LKSearchBarView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/5.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSearchBarView.h"

@interface LKSearchBarView ()
@property (nonatomic,strong) UIImageView *searchIcon;
@property (nonatomic,strong) UILabel *placeholderLabel;
@end

@implementation LKSearchBarView

- (void)configDefault{
    self.canClick = NO;
    self.searchItemStyle = LKSearchItemStyle_white;
    self.textFiledColor = [UIColor colorWithHexString:@"#333333"];
    self.placeholderColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.font = [UIFont systemFontOfSize:12.0];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self configDefault];
    }
    return self;
}

- (id)initCustomWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCustomView];
        [self configDefault];
    }
    return self;
}


- (void)setupUI{
    _searchBar = [[UISearchBar alloc] initWithFrame:self.bounds];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.searchBarStyle = UISearchBarStyleProminent;
    //设置搜索框的背景颜色
    _searchBar.barTintColor = [UIColor clearColor];
    //设置搜索框中的光标的颜色
    _searchBar.tintColor = [UIColor blackColor];
    
    //添加背景图,可以去掉外边框的灰色部分,同时决定了输入框的高度
    UIImage *bgImg = [UIImage imageWithColor:[UIColor clearColor] andHeight:self.size];
    [_searchBar setBackgroundImage:bgImg];
    [_searchBar setSearchFieldBackgroundImage:bgImg forState:UIControlStateNormal];
    [_searchBar setTranslucent:YES];//设置是否透明
    
    //移除视图，防止修改背景视图颜色无效（被该视图挡住了）
    UIView *subview = _searchBar.subviews.firstObject;
    for (UIView *view in subview.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        }
    }

    UIView *sssubview = _searchBar.subviews.firstObject;
    for (UIView *view in sssubview.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            for (UIView *sview in view.subviews) {
                sview.backgroundColor = [UIColor clearColor];
                if ([sview isKindOfClass:[UIImageView class]]) {
                    sview.left = 10;
                }
                if ([sview isKindOfClass:[UILabel class]]) {
                    sview.left = 40;
                }
            }
        }
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            for (UIView *sview in view.subviews) {
                sview.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    
    //设置textField里面文字在field中的位置
    _searchBar.searchTextPositionAdjustment = UIOffsetMake(5, 0);
    [self addSubview:_searchBar];
}

- (void)createCustomView{
    //搜素图标
    _searchIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _searchIcon.contentMode = UIViewContentModeScaleAspectFill;
    _searchIcon.clipsToBounds = YES;
    [self addSubview:_searchIcon];
    
    //默认文本框
    _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderLabel];
    
    [self g_addTapWithTarget:self action:@selector(searchAction)];
}

- (void)setCanClick:(BOOL)canClick{
    _canClick = canClick;
    _searchBar.userInteractionEnabled = canClick;
}

- (void)setDelegate:(id<UISearchBarDelegate>)delegate{
    _delegate = delegate;
    _searchBar.delegate = delegate;
}

- (void)setSearchItemStyle:(LKSearchItemStyle)searchItemStyle{
    _searchItemStyle = searchItemStyle;
    
    //自定义搜索框放大镜的图标
    if (_searchBar) {
        if (searchItemStyle == LKSearchItemStyle_white) {
            [_searchBar setImage:[UIImage imageNamed:@"icon_foot_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        }else if (searchItemStyle == LKSearchItemStyle_location){
            [_searchBar setImage:[UIImage imageNamed:@"img_loading_position"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        }
        else{
            [_searchBar setImage:[UIImage imageNamed:@"img_home_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        }
    }
    
    //自定义
    if (_searchIcon) {
        if (searchItemStyle == LKSearchItemStyle_white) {
            _searchIcon.image = [UIImage imageNamed:@"icon_foot_search"];
        }else{
           _searchIcon.image = [UIImage imageNamed:@"img_home_search"];
        }
    }
}

- (void)setFont:(UIFont *)font{
    _font = font;
    
    //自定义
    if (_placeholderLabel) {
        _placeholderLabel.font = font;
        _placeholderLabel.height = ceil(font.lineHeight);
    }
}

- (void)setTextFiledColor:(UIColor *)textFiledColor{
    _textFiledColor = textFiledColor;

}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    //自定义
    if (_placeholderLabel) {
        _placeholderLabel.textColor = placeholderColor;
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    if (_searchBar) {
        _searchBar.placeholder = placeholder;
    }
    
    //自定义
    if (_placeholderLabel) {
        _placeholderLabel.text = placeholder;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_searchBar) {
        UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
        if (searchField) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringValue:_searchBar.placeholder]];
            [attri addAttributes:@{NSFontAttributeName:self.font,
                                   NSForegroundColorAttributeName:self.placeholderColor
                                   } range:NSMakeRange(0, attri.length)];
            searchField.attributedPlaceholder = attri;
            
            searchField.font = self.font;
            searchField.textColor = self.textFiledColor;
            if (_searchBar.text.length>0) {
                NSMutableAttributedString *textAttri = [[NSMutableAttributedString alloc] initWithString:[NSString stringValue:_searchBar.text]];
                [textAttri addAttributes:@{NSFontAttributeName:self.font,
                                           NSForegroundColorAttributeName:self.textFiledColor
                                           } range:NSMakeRange(0, attri.length)];
                searchField.attributedText = textAttri;
            }
        }
    }
    
    //自定义
    if (_placeholderLabel && _searchIcon) {
        _searchIcon.size = _searchIcon.image.size;
        _searchIcon.centerY = self.height/2.0;
        
        CGSize textSize = [LKUtils sizeFit:_placeholderLabel.text withUIFont:_placeholderLabel.font withFitWidth:1000 withFitHeight:_placeholderLabel.height];
        _placeholderLabel.size = textSize;
        _placeholderLabel.centerY = _searchIcon.centerY;
        
        CGFloat inval = 3.0;//搜索图标与文本的间距
        CGFloat leftX = (self.width - (_searchIcon.width + inval +_placeholderLabel.width))/2.0;
        _searchIcon.left = leftX;
        _placeholderLabel.left = _searchIcon.right +inval;
        
    }
}

- (void)searchAction{
    if (self.clickSearchBarBlock) {
        self.clickSearchBarBlock();
    }
}


@end







