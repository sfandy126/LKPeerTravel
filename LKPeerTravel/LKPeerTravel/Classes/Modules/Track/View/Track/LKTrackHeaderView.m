//
//  LKTrackHeaderView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackHeaderView.h"
#import <SDCycleScrollView.h>
#import "LKTrackCityMoreView.h"
#import "LKSegmentView.h"
#import "LKSearchBarView.h"

@interface LKTrackHeaderView () <SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) LKSearchBarView *searchView;

@property (nonatomic,strong) UILabel *countryLab;
@property (nonatomic,strong) UILabel *cityLab;
@property (nonatomic,strong) UIImageView *cityIcon;

@property (nonatomic,strong) LKTrackCityMoreView *moreView;
@property (nonatomic,strong) LKSegmentView *segmentView;

@property (nonatomic,strong) LKTrackModel *model;
@end

@implementation LKTrackHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (LKSearchBarView *)searchView{
    if (!_searchView) {
        _searchView = [[LKSearchBarView alloc] initCustomWithFrame:CGRectMake(0, 30, 240, 25)];
        _searchView.centerX = kScreenWidth/2.0;
        _searchView.searchItemStyle = LKSearchItemStyle_white;
        _searchView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        _searchView.placeholderColor = [UIColor colorWithHexString:@"#ffffff"];
        _searchView.layer.cornerRadius = 5.0;
        _searchView.layer.masksToBounds = YES;
        _searchView.placeholder = @"输入导游，城市名称进行搜索";
        @weakify(self);
        _searchView.clickSearchBarBlock = ^{
            @strongify(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewWithClickedSearchBar)]) {
                [self.delegate headerViewWithClickedSearchBar];
            }
        };
    }
    return _searchView;
}

- (void)createView{
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, headerIconHeight) delegate:self placeholderImage:nil];
    _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleView.currentPageDotColor = [UIColor colorWithHexString:@"#FDB92C"];
    _cycleView.showPageControl = YES;
    _cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleView.clipsToBounds = YES;
    @weakify(self);
    _cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerViewDidSelectedBannerWithIndex:)]) {
            [self.delegate headerViewDidSelectedBannerWithIndex:currentIndex];
        }
    };
    [self addSubview:_cycleView];
    
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//    _pageControl.right = _cycleView.width;
//    _pageControl.bottom = _cycleView.height;
//    _pageControl.hidesForSinglePage = YES;
//    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FDB92C"];
//    _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#8B888E"];
//    _pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [_cycleView addSubview:_pageControl];
    
    [_cycleView addSubview:self.searchView];
    
    //城市
    _cityLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 0)];
    _cityLab.backgroundColor = [UIColor clearColor];
    _cityLab.text = @"";
    _cityLab.textColor = [UIColor whiteColor];
    _cityLab.font = [UIFont boldSystemFontOfSize:24.0];
    _cityLab.height = ceil(_cityLab.font.lineHeight);
    _cityLab.bottom = _cycleView.bottom -18;
    [_cycleView addSubview:_cityLab];
    
    //国家
    _countryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    _countryLab.backgroundColor = [UIColor clearColor];
    _countryLab.text = @"";
    _countryLab.textColor = [UIColor whiteColor];
    _countryLab.font = [UIFont systemFontOfSize:16.0];
    _countryLab.left = _cityLab.left;
    _countryLab.height = ceil(_countryLab.font.lineHeight);
    _countryLab.bottom = _cityLab.top -5;
    [_cycleView addSubview:_countryLab];
    
    _cityIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 16)];
    _cityIcon.backgroundColor = [UIColor clearColor];
    _cityIcon.image =[UIImage imageNamed:@"img_foot_position"];
    _cityIcon.bottom = _cityLab.bottom-5;
    [_cycleView addSubview:_cityIcon];
    
    //更多视图
    _moreView = [[LKTrackCityMoreView alloc] initWithFrame:CGRectMake(0, _cycleView.bottom, kScreenWidth, moreCityHeight)];
    _moreView.selectedBlock = ^(LKTrackCityModel *item) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:selectedSingleCity:isMore:)]) {
            [self.delegate headerView:self selectedSingleCity:item isMore:item.is_more];
        }
    };
    [self addSubview:_moreView];
    
    //菜单栏
    _segmentView = [[LKSegmentView alloc] initWithFrame:CGRectMake(12, _moreView.bottom+segmentTop, 200, segmentHeight)];
    _segmentView.proccessTop = 2;
    _segmentView.titles = @[@"最新",@"热门"];
    [_segmentView showSegment];
    _segmentView.selectedBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:selectedSegement:)]) {
            [self.delegate headerView:self selectedSegement:index];
        }
    };
    [self addSubview:_segmentView];
}

- (void)configData:(LKTrackModel *)model{
    self.model = model;
    NSArray *imageUrls = [NSArray getArray:[model.headerModel.city_icons valueForKey:@"imageUrl"]];
    _cycleView.imageURLStringsGroup = imageUrls;
    _pageControl.numberOfPages = _cycleView.imageURLStringsGroup.count;

    _countryLab.text = [NSString stringValue:model.headerModel.city_country];
    _cityLab.text = [NSString stringValue:model.headerModel.city_name];
    _cityIcon.hidden = _cityLab.text.length==0;
    CGSize citySize = [LKUtils sizeFit:_cityLab.text withUIFont:_cityLab.font withFitWidth:100 withFitHeight:_cityLab.height];
    _cityLab.width = citySize.width;
    _cityIcon.left = _cityLab.right +5;

    [_moreView configData:model.cityClassifys];
}


@end

