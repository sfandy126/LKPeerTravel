//
//  LKTabImageView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/5/26.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LKSelectTabbar) {
    LKSelectHomePage = 0,   //首页
    LKSelectNewsPage,      //消息
    LKSelectBreedsPage,    //孕育
    LKSelectWelfarePage,   //福利
    LKSelectPersonalPage   //个人
};

//选项选中后回调
typedef void (^itemSelected)(NSInteger index);

@interface LKCustomTabBar : UITabBar

@property (nonatomic, strong) UIButton *centerBtn; //中间按钮


//item标题
@property (nonatomic,strong) NSArray *itemTitles;
//tabBar背景图片
@property (nonatomic,strong) UIImage *tabBarBackgroundImage;
//未选中状态下item背景颜色
@property (nonatomic,strong) UIColor *itemNormalBgColor;
//选中状态下item背景颜色
@property (nonatomic,strong) UIColor *itemSelectedBgColor;
//未选中状态下item图标
@property (nonatomic,strong) NSArray *itemNormalIcons;
//选中状态下item图标
@property (nonatomic,strong) NSArray *itemSelectedIcons;
//未选中状态下item标题颜色
@property (nonatomic,strong) UIColor *itemNormalTitleColor;
//选中状态下item标题颜色
@property (nonatomic,strong) UIColor *itemSelectedTitleColor;
//选择哪个tab
@property (nonatomic,assign) LKSelectTabbar selectTabbar;
//item被选中的block
@property (nonatomic, copy) itemSelected onSelected;

/// 显示中间凸起的按钮
@property (nonatomic, assign) BOOL showTopNonormoralBtn;
///中间按钮点击事件
@property (nonatomic, copy)void(^centerButBlock)(void);
/**
 设置tabbar
 */
- (void)setUpTabBar;

/**
 选中某个tab

 @param index index
 */
- (void)selectedAtIndex:(NSInteger)index;


/**
 某个tab添加红点、数字

 @param index index
 @param bage 红点
 */
- (void)showTipViewAtIndex:(NSInteger)index bage:(NSString*)bage;


/**
 隐藏某个红点

 @param index index
 */
- (void)hiddenTipViewAtIndex:(NSInteger)index;


/**
 设置某个tab的红点

 @param badgeNum 数字
 @param index index
 */
- (void)setBadgeNum:(NSString *)badgeNum index:(NSInteger)index;

- (void)updateTabBarFrame:(CGRect)frame;

- (void)hiddenSubViews;
@end

