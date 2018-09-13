//
//  LKSearchBarView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/5.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

///搜索图标样式
typedef NS_ENUM(NSInteger,LKSearchItemStyle) {
    LKSearchItemStyle_gray,
    LKSearchItemStyle_white,
    LKSearchItemStyle_location,
};

@interface LKSearchBarView : UIView

///UISearchBar
- (id)initWithFrame:(CGRect)frame;

///自定义（不用UISearchBar）
- (id)initCustomWithFrame:(CGRect)frame;
@property (nonatomic,strong) UISearchBar *searchBar;

///UISearchBar默认为NO
@property (nonatomic,assign) BOOL canClick;
@property (nonatomic,weak) id<UISearchBarDelegate> delegate;

///搜索图标样式，默认白色
@property (nonatomic,assign) LKSearchItemStyle searchItemStyle;

///字体,默认12.0
@property (nonatomic,strong) UIFont *font;

///字体颜色，默认白色
@property (nonatomic,strong) UIColor *textFiledColor;

///引导文本颜色，默认灰色
@property (nonatomic,strong) UIColor *placeholderColor;

///默认文本
@property (nonatomic,strong) NSString *placeholder;

///点击跳转事件
@property (nonatomic,copy) void (^clickSearchBarBlock)(void);

@end
