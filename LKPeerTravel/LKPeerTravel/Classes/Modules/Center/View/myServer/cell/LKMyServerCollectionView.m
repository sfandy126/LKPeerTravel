//
//  LKMyServerCollectionView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerCollectionView.h"

#import "LKEditSceneViewController.h"

static NSString *kLKMyServerItemViewCellIdentify = @"kLKMyServerItemViewCellIdentify";
@class LKMyServerItemFlowLayout,LKMyServerItemViewCell;
@interface LKMyServerCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *datalists;

@end


@implementation LKMyServerCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        
        self.collectionView.left = 20;
        self.collectionView.width = self.width-self.collectionView.left*2;
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKMyServerItemFlowLayout *layout = [[LKMyServerItemFlowLayout alloc] init];
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
        [_collectionView registerClass:[LKMyServerItemViewCell class] forCellWithReuseIdentifier:kLKMyServerItemViewCellIdentify];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datalists.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKMyServerItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLKMyServerItemViewCellIdentify forIndexPath:indexPath];
    LKMyServerCityModel *item = [self.datalists objectAt:indexPath.item];
    [cell configData:item];
     @weakify(self);
    cell.deleteItemBlock = ^(LKMyServerCityModel *itemModel) {
        @strongify(self);
        if (self.deleteItemBlock) {
            self.deleteItemBlock(itemModel);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LKMyServerCityModel *item = [self.datalists objectAt:indexPath.item];
    LKEditSceneViewController *vc = [[LKEditSceneViewController alloc] init];
    vc.scene_id = item.city_id;
     @weakify(self);
    vc.successAddBlock = ^(NSDictionary *dict) {
        @strongify(self);
        LKMyServerCityModel *cicy = [LKMyServerCityModel modelWithDict:dict];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.datalists];
        [temp replaceObjectAtIndex:indexPath.item withObject:cicy];
        self.datalists = [NSArray arrayWithArray:temp];
        [self.collectionView reloadData];
    };
    [LKMediator pushViewController:vc animated:YES];
}

- (void)configData:(LKMyServerTypeModel *)data{
    self.datalists = [NSArray getArray:data.citys];
    [self.collectionView reloadData];
    
    self.collectionView.height = data.itemsHeight;
    self.height = self.collectionView.height;
}


@end


@interface LKMyServerItemFlowLayout ()
@property (nonatomic,strong) NSMutableArray *attrsArray;

@end

@implementation LKMyServerItemFlowLayout
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

@interface LKMyServerItemViewCell ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *deleteIcon;
@property (nonatomic,strong) LKMyServerCityModel *item;

@end

@implementation LKMyServerItemViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        _icon.layer.cornerRadius = 5.0;
        _icon.layer.masksToBounds = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        _icon.clipsToBounds = YES;
        [self.contentView addSubview:_icon];
        
        _deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_service_delete_none"]];
        _deleteIcon.right = _icon.right+5;
        _deleteIcon.top = _icon.top-5;
        _deleteIcon.userInteractionEnabled = YES;
         @weakify(self);
        [_deleteIcon lk_addTapGestureRecognizerWithBlock:^(UIGestureRecognizer *gestureRecognizer) {
            @strongify(self);
            if (self.deleteItemBlock) {
                self.deleteItemBlock(self.item);
            }
        }];
        [self.contentView addSubview:_deleteIcon];
        
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

- (void)configData:(LKMyServerCityModel *)item{
    self.item = item;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.city_icon] placeholderImage:nil];
    self.titleLab.text = item.city_name;
}

@end

