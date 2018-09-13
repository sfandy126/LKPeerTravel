//
//  LKTabImageView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/5/26.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCustomTabBar.h"

#import "LKTabBarItemView.h"

#define ITEMVIEW_BASE_TAG 10000
#define UITABBAR_HEIGHT 49

@interface LKCustomTabBar ()

@property (nonatomic , assign) NSInteger lastSelectedIndex;
@property (nonatomic , strong) UIImageView *tabBarBackgroundView;

@end

@implementation LKCustomTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    self.lastSelectedIndex = -1;
    //  tabbar 背景图
    self.tabBarBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.tabBarBackgroundView.userInteractionEnabled = YES;
    [self addSubview:self.tabBarBackgroundView];
    
    self.shadowImage = [UIImage new];
    self.backgroundColor = [UIColor clearColor];
  
}

- (void)addCenterBtn {
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //  设定button大小为适应图片
    UIImage *normalImage = [UIImage imageNamed:@"btn_table_publish_none"];
    UIImage *hightImage = [UIImage imageNamed:@"btn_table_publish_pressed"];

    _centerBtn.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [_centerBtn setImage:normalImage forState:UIControlStateNormal];
    [_centerBtn setImage:hightImage forState:UIControlStateSelected];

    //去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
    //根据图片调整button的位置(图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
    _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - normalImage.size.width)/2.0, _tabBarBackgroundView.height-UITABBAR_HEIGHT, normalImage.size.width, normalImage.size.height);
    [_centerBtn addTarget:self action:@selector(centerButAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarBackgroundView addSubview:_centerBtn];
    
//    self.clipsToBounds = YES;
    self.tabBarBackgroundView.clipsToBounds = NO;
}


- (void)setUpTabBar {
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        self.tabBarBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    } else {
        UIImage *image = [UIImage imageNamed:@"bottom_background"];
        self.tabBarBackgroundView.height = image.size.height*kWidthRadio;
        self.tabBarBackgroundView.bottom = self.height;
        self.tabBarBackgroundView.image = image;
    }

    NSInteger count = self.itemNormalIcons.count;
    //  创建tabbar中的 itemView， 并创建相应的点击事件
    for (NSInteger i = 0; i < count; i ++) {
        if (i == 2 && count == 5) {
            [self addCenterBtn];
            continue;
        }
        LKTabBarItemView *itemView = [self createItemViewWithFrame:CGRectMake(i*(self.tabBarBackgroundView.frame.size.width/count),
                                                                         (self.tabBarBackgroundView.height-UITABBAR_HEIGHT),
                                                                         (self.tabBarBackgroundView.frame.size.width/count),
                                                                         UITABBAR_HEIGHT)
                                                        index:i];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewTap:)];
        [itemView addGestureRecognizer:gesture];
        [self.tabBarBackgroundView addSubview:itemView];
    }
}

- (void)hiddenSubViews {
    for (UIView *view in self.subviews) {
        if (view != self.tabBarBackgroundView) {
            view.hidden = YES;
        }
    }
}


/**
 *  自定义 UITabBarItem
 *
 *  @param frame 位置
 *  @param index 下标
 *
 *  @return LMBItemView
 */
- (LKTabBarItemView *)createItemViewWithFrame:(CGRect)frame index:(NSInteger)index {
    LKTabBarItemView *itemView = [[LKTabBarItemView alloc] initWithFrame:frame];
    itemView.tag = ITEMVIEW_BASE_TAG + index;
    itemView.backgroundColor = self.itemNormalBgColor;
   
    itemView.icon.image = [UIImage imageNamed:[self.itemNormalIcons objectAtIndex:index]];
    
    if (index == 2) {
        [self replaceGrowthTabItemWithBabyInfo];
    }
    
    itemView.title.text = [self.itemTitles objectAtIndex:index];
    itemView.title.textColor = self.itemNormalTitleColor;
    return itemView;
}


/**
 *  获取第N个 TabBarItem
 *
 *  @param index tabbarItem 索引号
 *
 *  @return LMBItemView
 */
- (LKTabBarItemView *)itemViewAtIndex:(NSInteger)index {
    return (LKTabBarItemView *)[self.tabBarBackgroundView viewWithTag:ITEMVIEW_BASE_TAG + index];
}


/**
 *  改变某个tabbarItem的状态
 *
 *  @param itemView 目标 tabbarItem
 *  @param selected 目标状态：选中状态/非选中状态
 */
- (void)setItemView:(LKTabBarItemView *)itemView selected:(BOOL)selected {
    if (!itemView) {
        return;
    }
    if (selected) {
        if (self.itemSelectedBgColor) {
            itemView.backgroundColor = self.itemSelectedBgColor;
        }
        if (self.itemSelectedIcons) {
            long index = itemView.tag - ITEMVIEW_BASE_TAG;
         
            itemView.icon.image = [UIImage imageNamed:[self.itemSelectedIcons objectAt:index]];
        }
        if (self.itemSelectedTitleColor) {
            itemView.title.textColor = self.itemSelectedTitleColor;
        }
    }
    else {
        itemView.backgroundColor = self.itemNormalBgColor;
        //        itemView.icon.dk_imagePicker = [self.itemNormalIcons objectAt:itemView.tag - ITEMVIEW_BASE_TAG];
        long index = itemView.tag - ITEMVIEW_BASE_TAG;
        itemView.icon.image = [UIImage imageNamed:[self.itemNormalIcons objectAt:index]];
        
        itemView.title.textColor = self.itemNormalTitleColor;
    }
}


//  点击 tabbarItem 时触发
- (void)itemViewTap:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag-ITEMVIEW_BASE_TAG;
    self.selectTabbar = index;
 
    [self selectedAtIndex:index];
    
    //回调
    if (self.onSelected) {
        self.onSelected(index);
    }
}


/**
 *  切换 tabbarItem
 *
 *  @param index tabbarItem的索引号
 */
- (void)selectedAtIndex:(NSInteger)index
{
    if (index == self.lastSelectedIndex) {
        return;
    }
    
    //取消选中上一个选项
    LKTabBarItemView *oldView = [self itemViewAtIndex:self.lastSelectedIndex];
    [self setItemView:oldView selected:NO];
    
    //选中被选择的新选项
    LKTabBarItemView *newView = [self itemViewAtIndex:index];
    [self setItemView:newView selected:YES];
    
    //保存上一个被选中的索引号
    self.lastSelectedIndex = index;
    
    [self replaceGrowthTabItemWithBabyInfo];
}


/**
 *  在tabbarItem上显示提示
 *
 *  @param index tabbarItem的索引号
 *  @param bage  提示内容
 */
- (void)showTipViewAtIndex:(NSInteger)index bage:(NSString*)bage {
    LKTabBarItemView *view = [self itemViewAtIndex:index];
    view.lbage.hidden = NO;
    view.tipView.hidden = NO;
    view.lbage.text = bage;
}


/**
 *  隐藏某个tabbarItem上的所有提示
 *
 *  @param index tabbarItem的索引号
 */
- (void)hiddenTipViewAtIndex:(NSInteger)index
{
    LKTabBarItemView *view = [self itemViewAtIndex:index];
    view.lbage.hidden = YES;
    view.tipView.hidden = YES;
}

- (void)setBadgeNum:(NSString *)badgeNum index:(NSInteger)index {
    LKTabBarItemView *itemView = [self itemViewAtIndex:index];
    itemView.badgeNum = badgeNum;
}

- (void)replaceGrowthTabItemWithBabyInfo {
   
}

- (void)updateTabBarFrame:(CGRect)frame {
    self.frame = frame;
    self.tabBarBackgroundView.frame = self.bounds;
}

- (void)centerButAction{
    if (self.centerButBlock) {
        self.centerButBlock();
    }
}

////处理超出区域点击无效的问题
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    if (self.hidden){
//        return [super hitTest:point withEvent:event];
//    }else {
//        //转换坐标
//        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
//        //判断点击的点是否在按钮区域内
//        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
//            //返回按钮
//            return _centerBtn;
//        }else {
//            return [super hitTest:point withEvent:event];
//        }
//    }
//}

@end
