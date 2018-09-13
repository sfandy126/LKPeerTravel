//
//  LKNavigationBar.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKNavigationBar : UINavigationBar

@property (nonatomic, strong) UINavigationItem *navigationItem;
@property (nonatomic) CGFloat naviAlpha;


/** 随着scrollView滚动，颜色风格变化
 **/
- (void)setOffsetY:(CGFloat)offsetY alphaBlock:(void(^)(CGFloat alpha))alphaBlock;

/** 设置leftButton
 ** ImageName 图片名
 ** target    controller
 ** action    方法名
 **/
- (void)setLeftItemImage:(NSString *)ImageName target:(id)target action:(SEL)action;

/** 设置rightButton
 ** ImageName 图片名
 ** target    controller
 ** action    方法名
 **/
- (void)setRightItemImage:(NSString *)ImageName target:(id)target action:(SEL)action;

//最多支持两个right item
- (void)setRightItemsImages:(NSArray *)imageNames  target:(id)target action:(SEL)action  ohterAction:(SEL)otherAction;

/** 设置LeftButton
 ** name 名字
 ** target    controller
 ** action    方法名
 **/
- (void)setLeftItem:(NSString *)name target:(id)target tintColor:(UIColor*)color  action:(SEL)action;

/** 设置rightButton
 ** name 名字
 ** target    controller
 ** action    方法名
 **/
- (void)setRightItem:(NSString *)name target:(id)target tintColor:(UIColor*)color  action:(SEL)action;

/** 设置title
 ** title 标题颜色
 **/
- (void)setTitle:(NSString *)title;

/** 隐藏title
 ** hidden 是否隐藏
 **/
- (void)setTitleHidden:(BOOL)hidden;

/** 设置title颜色
 ** color 颜色
 ** nightColor 不支持换肤时，传nil
 **/
- (void)setTitleColor:(UIColor *)color  nightColor:(UIColor *)nightColor;

/** 设置LeftItem 的tintColor
 ** color 颜色
 ** nightColor 不支持换肤时，传nil
 **/
- (void)setLeftTintColor:(UIColor *)color  nightColor:(UIColor *)nightColor;

/** 设置RightItem 的tintColor
 ** color 颜色
 ** nightColor 不支持换肤时，传nil
 **/
- (void)setRightTintColor:(UIColor *)color  nightColor:(UIColor *)nightColor;

/** 设置Items 的 Color (包括 title、leftButton、rightButton)
 ** color 颜色
 ** nightColor 不支持换肤时，传nil
 **/
- (void)setItemsColor:(UIColor *)color nightColor:(UIColor *)nightColor;

/** 设置右边 Items 的 字体大小
 ** font 字体
 **/
- (void)setRightItemWithFontOfSize:(UIFont *)font;

/** 设置rightItems
 ** items rightItems
 **/
- (void)setRightBarButtonItems:(NSArray *)items;

/** 设置rightItem
 ** item rightItem
 **/
- (void)setRightBarButtonItem:(UIBarButtonItem *)item;

/** 设置titleView
 ** titleView
 **/
- (void)setTitleView:(UIView*)titleView;

/** 设置标题透明度
 ** alpha 透明度
 **/
- (void)setTitleAlpha:(CGFloat)alpha;

/**
 ** 更新导航栏透明度
 ** @param alpha 透明度
 */
- (void)updataNavigationAlpha:(CGFloat)alpha;

/**
 *  是否隐藏左侧按钮
 *
 **/
- (void)setLeftItemHidden:(BOOL)isHidden;

@end
