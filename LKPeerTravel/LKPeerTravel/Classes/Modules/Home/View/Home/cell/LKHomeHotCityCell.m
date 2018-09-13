//
//  LKHomeHotCityCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeHotCityCell.h"
#import "LKHomeRightButView.h"

#define itemLeft 15.0
#define itemInval 10.0
#define itemWidth  ((kScreenWidth-20)-itemLeft*2-itemInval)/2.0
#define itemHeight 120.0*kWidthRadio

static NSString *kLKHomeHotCityCollectionCellIdentify = @"kLKHomeHotCityCollectionCellIdentify";

@class LKHomeCityCollectionViewFlowLayout;
@interface LKHomeHotCityCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKHomeRightButView *moreButView;

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) NSArray<LKHomeGuideModel *> *dataLists;

@end

@implementation LKHomeHotCityCell

- (void)createView{
    [super createView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10.0;
    _bgView.layer.masksToBounds = YES;
    _bgView.clipsToBounds = YES;
    [self.contentView addSubview:_bgView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 45)];
    _titleLab.text = @"热门城市";
    _titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_bgView addSubview:_titleLab];
    
    
    _moreButView = [[LKHomeRightButView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _moreButView.right = _bgView.width-15;
    _moreButView.centerY = _titleLab.height/2;
    _moreButView.title = @"查看更多";
    _moreButView.image = [UIImage imageNamed:@"btn_home_into_none"];
    _moreButView.imageSize = CGSizeMake(38/3, 38/3);
    _moreButView.inval = 3;
    @weakify(self);
    _moreButView.selectedBlock = ^{
        @strongify(self);
        [self moreButAction];
    };
    [_bgView addSubview:_moreButView];
    
    [_bgView addSubview:self.collectionView];
}

- (void)configData:(id)data{
    [super configData:data];
    
    _bgView.height = [[self class] getCellHeight:data];
    self.collectionView.left = itemLeft;
    self.collectionView.top = _titleLab.bottom;
    self.collectionView.width = _bgView.width;
    self.collectionView.height = _bgView.height -_titleLab.bottom;
    
    self.dataLists = [NSArray getArray:data];
    [self.collectionView reloadData];
}

+ (CGFloat)getCellHeight:(id)data{    
    return 45+itemHeight*2+10+20;
}

- (void)moreButAction{
    if (self.moreButBlock) {
        self.moreButBlock();
    }
}
#pragma mark - - collectionView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKHomeCityCollectionViewFlowLayout *layout =  [[LKHomeCityCollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = itemInval;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[LKHomeHotCityCollectionCell class] forCellWithReuseIdentifier:kLKHomeHotCityCollectionCellIdentify];
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
    LKHomeHotCityCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kLKHomeHotCityCollectionCellIdentify forIndexPath:indexPath];
    
    if (self.dataLists.count>0) {
        LKHomeHotCityModel *model = [self.dataLists objectAt:indexPath.item];
        [cell configData:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LKHomeHotCityModel *model = [self.dataLists objectAt:indexPath.item];
    
    if (self.selectedBlock) {
        self.selectedBlock(model);
    }
}



@end

@interface LKHomeHotCityCollectionCell ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UIImageView *likeIcon;
@property (nonatomic,strong) UILabel *likeLab;
@property (nonatomic,strong) UILabel *nameLab;

@end

@implementation LKHomeHotCityCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        _iconIV.backgroundColor = [UIColor lightGrayColor];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.cornerRadius = 6.0;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _iconIV.width, 67)];
        bgView.image = [[UIImage imageNamed:@"img_home_city_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15) resizingMode:UIImageResizingModeStretch];
        bgView.layer.cornerRadius = 6.0;
        bgView.layer.masksToBounds = YES;
        bgView.clipsToBounds = YES;
        [_iconIV addSubview:bgView];
        bgView.bottom = _iconIV.height;
    
        
        //点赞
        _likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 10, 8)];
        _likeIcon.bottom = _iconIV.height - 10;
        _likeIcon.backgroundColor = [UIColor clearColor];
        _likeIcon.contentMode = UIViewContentModeScaleAspectFill;
        _likeIcon.image = [UIImage imageNamed:@"img_home_heart"];
        [_iconIV addSubview:_likeIcon];
        
        _likeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth-25, 0)];
        _likeLab.backgroundColor = [UIColor clearColor];
        _likeLab.text = @"";
        _likeLab.font = [UIFont systemFontOfSize:10.0];
        _likeLab.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.6];
        _likeLab.textAlignment = NSTextAlignmentLeft;
        _likeLab.height = ceil(_likeLab.font.lineHeight);
        _likeLab.left = _likeIcon.right+6;
        _likeLab.centerY = _likeIcon.centerY;
        [_iconIV addSubview:_likeLab];
        
        //城市名称
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10,0, itemWidth, 0)];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.text = @"";
        _nameLab.font = [UIFont boldSystemFontOfSize:24.0];
        _nameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _nameLab.height = ceil(_nameLab.font.lineHeight);
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.bottom =  _likeIcon.top-6;
        [_iconIV addSubview:_nameLab];
        
    }
    return self;
}

- (void)configData:(LKHomeHotCityModel *)model{
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:model.city_icon]] placeholderImage:nil];
    _likeLab.text = [NSString stringValue:model.likes];
    _nameLab.text = [NSString stringValue:model.city_name];
}

@end

@interface LKHomeCityCollectionViewFlowLayout ()
@property (nonatomic,strong) NSMutableArray *attrsArray;
@end

#define column 2 //列数

@implementation LKHomeCityCollectionViewFlowLayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 * 初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // 设置布局属性的frame
    NSInteger i= indexPath.item;
    attrs.frame = CGRectMake((itemInval+itemWidth)*(i%column), (itemInval+itemHeight)*(i/column), itemWidth,itemHeight);

    return attrs;
}
/**
 * 决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(itemWidth, itemHeight);
}

@end

