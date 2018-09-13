//
//  UIScrollView+LKRefresh.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/25.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIScrollView+LKRefresh.h"
#import <MJRefresh.h> 

@implementation UIScrollView (LKRefresh)


#pragma mark --  header

- (void)addHeaderRefreshBlock:(LKRefreshBlock )refreshBlock{
    [self addLegendHeaderRefreshBlock:refreshBlock];
 
}

- (void)addLegendHeaderRefreshBlock:(LKRefreshBlock )refreshBlock{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:refreshBlock];
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.stateLabel.font = [UIFont systemFontOfSize:13.0];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13.0];
    [header setTitle:@"同行旅游正在奋力为你加载...." forState:MJRefreshStateRefreshing];
    self.mj_header = header;
}

- (void)addLegendGifHeaderRefreshBlock:(LKRefreshBlock )refreshBlock{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:refreshBlock];
    NSMutableArray *idleImages = [NSMutableArray array];
    NSMutableArray *refreshingImages = [NSMutableArray array];

    for (NSUInteger i = 0; i<=42; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Pull_down_refresh%zd", i]];
        if (image) {
            [idleImages addObject:image];
        }
    }
    
    for (NSUInteger i = 1; i<=61; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"lmb_jump_%zd", i]];
        if (image) {
            [refreshingImages addObject:image];
        }
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];

    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;

    self.mj_header  = header;
}




- (void)endHeaderRefreshing{
    [self.mj_header endRefreshing];
}

- (void)beginHeaderRefreshing{
    [self.mj_header beginRefreshing];
}

#pragma mark - - footer

- (void)addFooterRefreshBlock:(LKRefreshBlock )refreshBlock{
    MJRefreshFooter *footer = [MJRefreshFooter footerWithRefreshingBlock:refreshBlock];
    self.mj_footer = footer;
}

- (void)addLegendFooterRefreshBlock:(LKRefreshBlock )refreshBlock{
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:refreshBlock];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
    [footer setTitle:@"没有更多了..." forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    self.mj_footer = footer;
}

- (void)endFooterRefreshing{
    [self.mj_footer endRefreshing];
}

- (void)beginFooterRefreshing{
    [self.mj_footer beginRefreshing];
}

- (void)endRefreshing{
    [self endHeaderRefreshing];
    [self endFooterRefreshing];
}

- (void)noticeNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData{
    [self.mj_footer resetNoMoreData];
}

- (void)setNoticeNoMoreData:(BOOL)isNoMore{
    if (isNoMore) {
        [self noticeNoMoreData];
    }else{
        [self resetNoMoreData];
    }
}

- (void)hiddenFooter:(BOOL)hidden {
    self.mj_footer.hidden = hidden;
}
@end
