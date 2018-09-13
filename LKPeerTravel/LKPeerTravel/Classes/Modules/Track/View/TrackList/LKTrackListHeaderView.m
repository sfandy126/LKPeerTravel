//
//  LKTrackListHeaderView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackListHeaderView.h"
#import <SDCycleScrollView.h>
#import "LKSearchBarView.h"


@interface LKTrackListHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleView;

@property (nonatomic,strong) UILabel *countryLab;
@property (nonatomic,strong) UILabel *cityLab;
@property (nonatomic,strong) UIImageView *cityIcon;

@property (nonatomic,strong) UIImageView *lookIcon;
@property (nonatomic,strong) UILabel *lookLab;

@property (nonatomic,strong) UIImageView *commentIcon;
@property (nonatomic,strong) UILabel *commentLab;

@property (nonatomic,strong) LKTrackCityModel *model;
@end

@implementation LKTrackListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (void)createView{
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, 240) delegate:self placeholderImage:nil];
    _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleView.currentPageDotColor = [UIColor colorWithHexString:@"#FDB92C"];
    _cycleView.showPageControl = NO;
    @weakify(self);
    _cycleView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        //选择的回调
        @strongify(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedBannerWithItem:)]) {
            [self.delegate didClickedBannerWithItem:self.model];
        }
    };
    [self addSubview:_cycleView];
    
    
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
    
    
    //查看
    _lookIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _lookIcon.image = [UIImage imageNamed:@"img_foot_look"];
    [_cycleView addSubview:_lookIcon];
    
    _lookLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _lookLab.backgroundColor = [UIColor clearColor];
    _lookLab.text = @"";
    _lookLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_cycleView addSubview:_lookLab];
    
    //回复
    _commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _commentIcon.image = [UIImage imageNamed:@"img_foot_talk"];
    [_cycleView addSubview:_commentIcon];
    
    _commentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLab.backgroundColor = [UIColor clearColor];
    _commentLab.text = @"";
    _commentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_cycleView addSubview:_commentLab];
    
}


- (void)configData:(LKTrackCityModel *)item{
    self.model = item;
    NSArray *imageUrls = [NSArray getArray:[item.city_icons valueForKey:@"imageUrl"]];
    _cycleView.imageURLStringsGroup = imageUrls;
    
    _countryLab.text = [NSString stringValue:item.city_country];
    _cityLab.text = [NSString stringValue:item.city_name];
    _cityIcon.hidden = _cityLab.text.length==0;
    CGSize citySize = [LKUtils sizeFit:_cityLab.text withUIFont:_cityLab.font withFitWidth:100 withFitHeight:_cityLab.height];
    _cityLab.width = citySize.width;
    _cityIcon.left = _cityLab.right +5;
    
    //回复
    _commentLab.text = [NSString stringValue:item.comments];
    _commentLab.font = item.commentFrame.font;
    _commentLab.width = item.commentFrame.width;
    _commentLab.height = item.commentFrame.height;
    _commentLab.right = self.width -20;
    
    _commentIcon.right = _commentLab.left - item.commentFrame.leftInval;
    
    //查看
    _lookLab.text = [NSString stringValue:item.looks];
    _lookLab.font = item.lookFrame.font;
    _lookLab.width = item.lookFrame.width;
    _lookLab.height = item.lookFrame.height;
    _lookLab.right = _commentIcon.left -4.0;
    
    _lookIcon.right = _lookLab.left - item.lookFrame.leftInval;
    
    _commentIcon.centerY = _commentLab.centerY = self.height -20;
    _lookIcon.centerY = _lookLab.centerY = self.height -20;;
}


@end
