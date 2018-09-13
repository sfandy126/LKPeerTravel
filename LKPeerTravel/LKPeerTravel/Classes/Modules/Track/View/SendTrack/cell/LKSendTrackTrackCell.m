//
//  LKSendTrackTrackCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackTrackCell.h"
#import "LKCollectionViewFlowLayout.h"
#import "LKSendTrackAddCollectionViewCell.h"

@interface LKSendTrackTrackCell ()<UICollectionViewDataSource,UICollectionViewDelegate,LKCollectionViewFlowLayoutDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *datalists;

@end

@implementation LKSendTrackTrackCell

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        LKCollectionViewFlowLayout *layout =  [[LKCollectionViewFlowLayout alloc] init];
        layout.delegate = self;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.columnsCount = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerClass:[LKSendTrackAddCollectionViewCell class] forCellWithReuseIdentifier:kLKSendTrackAddCollectionViewCellIdentify];
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

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKSendTrackAddCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kLKSendTrackAddCollectionViewCellIdentify forIndexPath:indexPath];
    
    LKSendTrackAddModel *item = [self.datalists objectAt:indexPath.item];
    [cell configData:item];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    LKSendTrackAddModel *item = [self.datalists objectAt:indexPath.item];
    if (item.is_add) {
        [LKImagePicker getPictureWithBlock:^(UIImage *image) {
            item.city_image = image;
            item.is_add = NO;
            if (self.addImageBlock) {
                self.addImageBlock(item);
            }
        }];
    }

}

#pragma mark - - LKCollectionViewFlowLayoutDelegate

///设置item的高度
- (CGFloat)collectionFlowLayout:(LKCollectionViewFlowLayout *)flowLayout heightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    LKSendTrackAddModel *item = [self.datalists objectAt:indexPath.item];
    if (item) {
        return item.itemFrame.height;
    }
    return CGFLOAT_MIN;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        
        [self addSubview:self.collectionView];

    }
    return self;
}


- (void)configData:(id)data{
    self.datalists = [NSArray getArray:data];
    [self.collectionView reloadData];

    self.collectionView.left = 10;
    self.collectionView.width = kScreenWidth -self.collectionView.left*2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionView.height = self.collectionView.contentSize.height;
    });
}

+ (CGFloat)getCellHeight:(id)data{
    CGFloat height = 0.0;
    NSArray *list = [NSArray getArray:data];
    NSInteger i=0;
    for (LKSendTrackAddModel *item in list) {//偶数
        if (i%2==0) {
            LKSendTrackAddModel *secItem = [list objectAt:i+1];//奇数
            height+= MAX(item.itemFrame.height,secItem.itemFrame.height)+10;
        }
        i++;
    }
    if (height>0) {
        height+=10;
    }
    return height;
}

@end
