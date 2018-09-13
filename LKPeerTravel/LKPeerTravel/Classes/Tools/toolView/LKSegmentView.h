//
//  LKSegmentView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LKSegmentLayoutStyle) {
    LKSegmentLayoutStyle_custom=0,//自定义，可修改butInval
    LKSegmentLayoutStyle_center,//按钮居中，修改butInval无效
};

@interface LKSegmentView : UIView

///标题
@property (nonatomic,strong) NSArray *titles;

///当前选择的下标
@property (nonatomic,assign) NSInteger currentIndex;

///选中的标题颜色
@property (nonatomic,strong) UIColor *selectdTitleColor;

///未选中的标题颜色
@property (nonatomic,strong) UIColor *unSelectdTitleColor;

///选中的标题字体大小
@property (nonatomic,strong) UIFont *selectdTitleFont;

///未选中的标题字体大小
@property (nonatomic,strong) UIFont *unSelectdTitleFont;

///按钮之间的间隙(默认16)
@property (nonatomic,assign) CGFloat butInval;

///按钮布局样式,默认为自定义样式，butInval
@property (nonatomic,assign) LKSegmentLayoutStyle layoutStyle;

///标题距离边框的边距,默认为zero
@property (nonatomic,assign) UIEdgeInsets paddingEdgeInsets;

///当前选择的进度条颜色
@property (nonatomic,strong) UIColor *proccessColor;
///进度高度,默认为7
@property (nonatomic,assign) CGFloat proccessHeight;
///进度宽度，默认根据标题适配
@property (nonatomic,assign) CGFloat proccessWidth;

///按钮与进度的间距,如为0,则置最底部
@property (nonatomic,assign) CGFloat proccessTop;


///选中按钮的回调
@property (nonatomic,copy) void (^selectedBlock)(NSInteger index);

///显示菜单栏
- (void)showSegment;

///初始化后，手动更改选中位置
- (void)setSelectedCurrentIndex:(NSInteger)index;

@end
