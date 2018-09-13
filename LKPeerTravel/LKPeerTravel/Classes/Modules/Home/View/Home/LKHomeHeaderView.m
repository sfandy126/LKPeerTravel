//
//  LKHomeHeaderView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/29.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeHeaderView.h"
#import "LKSearchBarView.h"
#import <SDCycleScrollView.h>

@interface LKHomeHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleView;
@property (nonatomic,strong) LKSearchBarView *searchView;
@end

@implementation LKHomeHeaderView

- (LKSearchBarView *)searchView{
    if (!_searchView) {
        _searchView = [[LKSearchBarView alloc] initCustomWithFrame:CGRectMake(10, 0, self.width-20, 50)];
        _searchView.centerX = kScreenWidth/2.0;
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        _searchView.placeholderColor = [UIColor colorWithHexString:@"#969696"];
        _searchView.searchItemStyle = LKSearchItemStyle_gray;
        _searchView.layer.cornerRadius = 10.0;
        _searchView.layer.masksToBounds = YES;
        _searchView.placeholder = @"输入导游，城市名称进行搜索";
        _searchView.clickSearchBarBlock = ^{
            [LKMediator openSearch];
        };
    }
    return _searchView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height-30) delegate:self placeholderImage:nil];
        _cycleView.backgroundColor = [UIColor lightGrayColor];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleView.currentPageDotColor = [UIColor colorWithHexString:@"#FDB92C"];
        _cycleView.showPageControl = YES;
    }
    return _cycleView;
}

- (void)createView{

    @weakify(self);
    self.cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        @strongify(self);
        //选择的回调
        NSLog(@"选择的回调");
    };
    [self addSubview:self.cycleView];
    
    self.searchView.top = self.cycleView.bottom-20;
    [self addSubview:self.searchView];

}

- (void)configData:(NSArray<LKBannerPicModel *>*)banners{
    NSMutableArray *temp = [NSMutableArray array];
    for (LKBannerPicModel *picModel in banners) {
        NSString *picUrl = [NSString stringValue:picModel.bannerUrl];
        if (picUrl.length>0) {
            [temp addObject:picUrl];
        }
    }
    NSArray *pics = [NSArray getArray:[temp copy]];
    _cycleView.imageURLStringsGroup = pics;
}

@end
