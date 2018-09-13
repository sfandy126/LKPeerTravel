//
//  LKTrackCityMoreView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackCityMoreView.h"

#define itemWidth 70.0
#define itemHeight 70.0

static NSString *kTrackCityMoreCellIdetify = @"kTrackCityMoreCellIdetify";
@class LKTrackCityMoreCollectionCell;
@interface LKTrackCityMoreView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataLists;
@end

@implementation LKTrackCityMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - - collectionView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 10.0;
        
        CGRect rect = CGRectMake(0, 10, self.width, itemHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[LKTrackCityMoreCollectionCell class] forCellWithReuseIdentifier:kTrackCityMoreCellIdetify];
    }
    return _collectionView;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataLists.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKTrackCityMoreCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kTrackCityMoreCellIdetify forIndexPath:indexPath];
    
    if (self.dataLists.count>0) {
        LKTrackCityModel *model = [self.dataLists objectAt:indexPath.item];
        [cell configData:model];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LKTrackCityModel *model = [self.dataLists objectAt:indexPath.item];
    
    if (self.selectedBlock) {
        self.selectedBlock(model);
    }
}

- (void)configData:(NSArray *)citys{
    self.dataLists = [NSArray getArray:citys];
    [self.collectionView reloadData];
}


@end

@interface LKTrackCityMoreCollectionCell ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UIImageView *alphaIcon;
@property (nonatomic,strong) UILabel *cityLab;

@property (nonatomic,strong) UIImageView *moreIcon;


@end

@implementation LKTrackCityMoreCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.cornerRadius = 5.0;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        
        //半透明的背景层
        _alphaIcon = [[UIImageView alloc] initWithFrame:_iconIV.bounds];
        _alphaIcon.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
        [_iconIV addSubview:_alphaIcon];
        
        //城市名称
        _cityLab = [[UILabel alloc] initWithFrame:_iconIV.bounds];
        _cityLab.backgroundColor = [UIColor clearColor];
        _cityLab.text = @"";
        _cityLab.font = [UIFont systemFontOfSize:16.0];
        _cityLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _cityLab.textAlignment = NSTextAlignmentCenter;
        [_cityLab adjustsFontSizeToFitWidth];
        [_iconIV addSubview:_cityLab];
        
        //更多icon
        _moreIcon = [[UIImageView alloc] initWithFrame:_iconIV.bounds];
        _moreIcon.image =[UIImage imageNamed:@"btn_foot_more_none"];
        _moreIcon.contentMode = UIViewContentModeScaleAspectFill;
        _moreIcon.clipsToBounds = YES;
        _moreIcon.hidden = YES;
        [self.contentView addSubview:_moreIcon];
        
    }
    return self;
}

- (void)configData:(LKTrackCityModel *)model{
    NSDictionary *dict = [model.city_icons firstObject];
    if ([NSDictionary isNotEmptyDict:dict]) {
        [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:dict[@"imageUrl"]]] placeholderImage:nil];

    }
    _cityLab.text = [NSString stringValue:model.city_name];
   
    _moreIcon.hidden = !model.is_more;
    _alphaIcon.hidden = !_moreIcon.hidden;
    _iconIV.hidden = model.is_more;
}

@end

