//
//  LKTrackMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackMainView.h"
#import "LKCollectionViewFlowLayout.h"
#import "LKTrackHeaderView.h"
#import "LKTrackCityCell.h"

@interface LKTrackMainView () <UICollectionViewDataSource,UICollectionViewDelegate,LKCollectionViewFlowLayoutDelegate,LKTrackHeaderViewDelegate>
@property (nonatomic,strong) NSArray *datalists;
@end

@implementation LKTrackMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKCollectionViewFlowLayout *layout =  [[LKCollectionViewFlowLayout alloc] init];
        layout.delegate = self;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, headerHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.columnsCount = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView hiddenFooter:YES];
        [_collectionView  registerClass:[LKTrackHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTrackHeaderIdentify];
        [_collectionView registerClass:[LKTrackCityCell class] forCellWithReuseIdentifier:kTrackCityCollectionCellIdentify];
    }
    return _collectionView;
}

#pragma mark - - <UICollectionViewDataSource,UICollectionViewDelegate>

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datalists.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LKTrackHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kTrackHeaderIdentify forIndexPath:indexPath];
        headerView.delegate = self;
        [headerView configData:self.server.model];
        return headerView;
    }
    return nil;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKTrackCityCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kTrackCityCollectionCellIdentify forIndexPath:indexPath];
 
    LKTrackCityModel *item = [self.datalists objectAt:indexPath.item];
    [cell configData:item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LKTrackCityModel *item = [self.datalists objectAt:indexPath.item];
    if (item) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(didSelectedItem:indexPath:)]) {
            [self.delegate didSelectedItem:item indexPath:indexPath];
        }
    }
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

#pragma mark - - LKCollectionViewFlowLayoutDelegate

///设置item的高度
- (CGFloat)collectionFlowLayout:(LKCollectionViewFlowLayout *)flowLayout heightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    LKTrackCityModel *item = [self.datalists objectAt:indexPath.item];
    if (item) {
        return item.itemFrame.height;
    }
    return CGFLOAT_MIN;
}


#pragma mark - - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewScrollContentOffsetY:)]) {
        [self.delegate mainViewScrollContentOffsetY:scrollView.contentOffset.y];
    }
}

#pragma mark - - LKTrackHeaderViewDelegate

///菜单栏选择的代理
- (void)headerView:(LKTrackHeaderView *)headerView selectedSegement:(NSInteger )index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSwitchSegment:)]) {
        [self.delegate didSwitchSegment:index];
    }
}

///选择城市分类的代理
- (void)headerView:(LKTrackHeaderView *)headerView selectedSingleCity:(LKTrackCityModel *)item isMore:(BOOL)isMore{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCityClass:isMore:)]) {
        [self.delegate didSelectedCityClass:item isMore:isMore];
    }
}

///点击头部搜索框
- (void)headerViewWithClickedSearchBar{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedSearchBar)]) {
        [self.delegate didClickedSearchBar];
    }
}

///点击头部banner
- (void)headerViewDidSelectedBannerWithIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedBannerWithIndex:)]) {
        [self.delegate didSelectedBannerWithIndex:index];
    }
}


- (void)doneLoading{
    if (self.server.selectedType == LKTrackSelectedType_Newest) {
        self.datalists =  [NSArray getArray:[self.server.newestCitys copy]];
    }
    if (self.server.selectedType == LKTrackSelectedType_Hot) {
        self.datalists =  [NSArray getArray:[self.server.hotCitys copy]];
    }
 
    [self.collectionView endRefreshing];

    [self.collectionView reloadData];
    
    if (self.server.selectedType == LKTrackSelectedType_Newest) {
        if (self.server.model.isNewestLastPage) {
            [self.collectionView noticeNoMoreData];
        }else{
            [self.collectionView resetNoMoreData];
        }
    }else{
        if (self.server.model.isHotLastPage) {
            [self.collectionView noticeNoMoreData];
        }else{
            [self.collectionView resetNoMoreData];
        }
    }
  
}



@end
