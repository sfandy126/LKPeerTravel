//
//  LKOrderListShopsView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderListShopsView.h"

#define column 4 //列数
///横行间隙
#define itemInterInval (kScreenWidth-20*2 -itemWidth*column)/(column-1)
///垂直间隙
#define itemLineSpacing 10.0
#define itemWidth  71*kWidthRadio
#define itemHeight 92*kWidthRadio

static NSString *kLKOrderListShopsViewCellIdentify = @"kLKOrderListShopsViewCellIdentify";
@class LKOrderListShopFlowLayout,LKOrderListShopsViewCell;
@interface LKOrderListShopsView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *datalists;

@end


@implementation LKOrderListShopsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self addSubview:self.titleLab];
        
        self.collectionView.top = self.titleLab.bottom +titleAndCollectionInval;
        self.collectionView.left = 20;
        self.collectionView.width = self.width-self.collectionView.left*2;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, titleTop, 100, 0)];
        _titleLab.text = @"用户选定的服务";
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            _titleLab.text = @"我选择的服务";
        }
        _titleLab.font = kFont(12);
        _titleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKOrderListShopFlowLayout *layout = [[LKOrderListShopFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumInteritemSpacing = itemInterInval;
        layout.minimumLineSpacing = itemLineSpacing;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.userInteractionEnabled = NO;
        [_collectionView registerClass:[LKOrderListShopsViewCell class] forCellWithReuseIdentifier:kLKOrderListShopsViewCellIdentify];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datalists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKOrderListShopsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLKOrderListShopsViewCellIdentify forIndexPath:indexPath];
    LKOrderSingleShopModel *item = [self.datalists objectAt:indexPath.item];
    [cell configData:item];
    return cell;
}

- (void)configData:(LKOrderListModel *)model{
    self.datalists = [NSArray getArray:model.shops];
    [self.collectionView reloadData];
    
    self.collectionView.height = model.shopsHeight;
    self.height = self.collectionView.top +self.collectionView.height +collectionBottom;
}

- (void)configOrderDetailData:(NSArray *)datas shopsHeight:(CGFloat )shopsHeight{
    self.datalists = [NSArray getArray:datas];
    [self.collectionView reloadData];
    
    self.collectionView.height = shopsHeight;
    self.height = self.collectionView.top +self.collectionView.height +collectionBottom;
}


@end


@interface LKOrderListShopFlowLayout ()
@property (nonatomic,strong) NSMutableArray *attrsArray;

@end

@implementation LKOrderListShopFlowLayout
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
    attrs.frame = CGRectMake((itemInterInval+itemWidth)*(i%column), (itemLineSpacing+itemHeight)*(i/column), itemWidth,itemHeight);
    
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

@interface LKOrderListShopsViewCell ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *titleLab;

@end

@implementation LKOrderListShopsViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        _icon.backgroundColor = [UIColor lightGrayColor];
        _icon.layer.cornerRadius = 5.0;
        _icon.layer.masksToBounds = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
        [self.contentView addSubview:_icon];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = kBFont(12);
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.text = @"";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.height = ceil(_titleLab.font.lineHeight);
        _titleLab.width = _icon.width;
        _titleLab.centerX = _icon.centerX;
        _titleLab.top = _icon.bottom +8;
        [self.contentView addSubview:_titleLab];
    }
    return self;
}

- (void)configData:(LKOrderSingleShopModel *)item{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.city_icon] placeholderImage:nil];
    self.titleLab.text = item.city_name;
}

@end
