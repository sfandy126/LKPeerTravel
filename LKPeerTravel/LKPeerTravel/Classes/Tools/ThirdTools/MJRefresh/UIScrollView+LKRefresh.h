//
//  UIScrollView+LKRefresh.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/25.
//  Copyright © 2018年 LK. All rights reserved.
//


/***
 *   封装第三方MJRefresh刷新组件。
 *
 *
 **/

#import <UIKit/UIKit.h>

typedef void(^LKRefreshBlock)(void);

@interface UIScrollView (LKRefresh)


#pragma mark --  header 头部

///头部添加下拉刷新控件
- (void)addHeaderRefreshBlock:(LKRefreshBlock )refreshBlock;

///头部添加下拉刷新控件(默认的状态文字和更新时间)
- (void)addLegendHeaderRefreshBlock:(LKRefreshBlock )refreshBlock;

///头部添加下拉刷新控件(gif动画)
- (void)addLegendGifHeaderRefreshBlock:(LKRefreshBlock )refreshBlock;

///结束头部刷新
- (void)endHeaderRefreshing;

///开始下拉刷新
- (void)beginHeaderRefreshing;

#pragma mark - - footer 尾部

///尾部添加上拉加载
- (void)addFooterRefreshBlock:(LKRefreshBlock )refreshBlock;

///尾部添加上拉加载
- (void)addLegendFooterRefreshBlock:(LKRefreshBlock )refreshBlock;

///结束尾部加载
- (void)endFooterRefreshing;

///开始尾部加载
- (void)beginFooterRefreshing;


///结束所有加载
- (void)endRefreshing;

///没有更多了
- (void)noticeNoMoreData;

///重置没有更多
- (void)resetNoMoreData;

///是否没有更多了
- (void)setNoticeNoMoreData:(BOOL)isNoMore;

/// 隐藏上拉刷新
- (void)hiddenFooter:(BOOL)hidden;

@end
