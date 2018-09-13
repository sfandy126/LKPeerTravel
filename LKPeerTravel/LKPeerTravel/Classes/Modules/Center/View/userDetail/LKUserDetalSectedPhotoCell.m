//
//  LKUserDetalSectedPhotoCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetalSectedPhotoCell.h"

#import "LKSceneDetailViewController.h"

@implementation LKUserDetailSigleSceneCell

{
    UIImageView *_iconIV;
    UILabel *_sceneLabel;
    UIImageView *_deleteIcon;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        iv.layer.cornerRadius = 5;
        iv.layer.masksToBounds = YES;
        [iv sd_setImageWithURL:[NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/2943762-14f6b0d53e185d43?imageMogr2/auto-orient/strip|imageView2/1/w/300/h/240"]];
        iv.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:iv];
        _iconIV = iv;
        
        _deleteIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_service_delete_none"]];
        _deleteIcon.right = iv.right+5;
        _deleteIcon.top = iv.top-5;
        _deleteIcon.userInteractionEnabled = YES;
        @weakify(self);
        [_deleteIcon lk_addTapGestureRecognizerWithBlock:^(UIGestureRecognizer *gestureRecognizer) {
            @strongify(self);
            if (self.deleteItemBlock) {
                self.deleteItemBlock(self.dict);
            }
        }];
        [self.contentView addSubview:_deleteIcon];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.frame = CGRectMake(iv.left, iv.bottom+8, iv.width, ceil(label.font.lineHeight));
        label.text = @"景点名称";
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _sceneLabel = label;
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    [_iconIV sd_setImageWithURL:dict[@"codDestinationPointLogo"]];
    _sceneLabel.text = dict[@"codDestinationPointName"];
    
    NSArray *images = [NSArray getArray:dict[@"images"]];
    if (images.count>0) {
        NSDictionary *info = images[0];
        [_iconIV sd_setImageWithURL:info[@"codImageUrl"]];
    }
}

@end

@interface LKUserDetalSectedPhotoCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation LKUserDetalSectedPhotoCell

{
    UILabel *_titleLabel;
    UICollectionView *_collectionView;
    UIView *_line;
    CGFloat _itemHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    _titleLabel.text = @"已选地点";
    _titleLabel.frame = CGRectMake(27, 15,100, ceil(_titleLabel.font.lineHeight));
    [self.contentView addSubview:_titleLabel];
    
    CGFloat space = 30;
    CGFloat left = 20;
    CGFloat count = 4;
    CGFloat top = _titleLabel.bottom+30;
    CGFloat width = (kScreenWidth-left*2-space*(count-1))/count;
    CGFloat height = (width+8+ceil(kFont(14).lineHeight));
    _itemHeight = height;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumInteritemSpacing = 17;
    layout.minimumLineSpacing = space;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(left, top, kScreenWidth-left*2, 0) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[LKUserDetailSigleSceneCell class] forCellWithReuseIdentifier:NSStringFromClass(LKUserDetailSigleSceneCell.class)];
    _collectionView.backgroundColor = kColorWhite;
    [self.contentView addSubview:_collectionView];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(27, _collectionView.bottom+19.5, kScreenWidth-27, 0.5)];
    line2.backgroundColor = kColorLine2;
    [self.contentView addSubview:line2];
    _line = line2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.scenes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LKUserDetailSigleSceneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LKUserDetailSigleSceneCell.class) forIndexPath:indexPath];
    cell.dict = self.scenes[indexPath.item];
    cell.deleteItemBlock = self.deleteItemBlock;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.scenes objectAt:indexPath.item];
    if ([NSDictionary isEmptyDict:dict]) {
        return;
    }
    LKSceneDetailViewController *vc = [[LKSceneDetailViewController alloc] init];
    vc.scene_no = dict[@"codDestinationPointNo"];
    [LKMediator pushViewController:vc animated:YES];
}

- (void)setScenes:(NSArray<NSDictionary *> *)scenes {
    _scenes = scenes;
    
    [_collectionView reloadData];

    [_collectionView performBatchUpdates:^{
        
    } completion:^(BOOL finished) {
        _collectionView.height = _collectionView.contentSize.height;
        _line.top = _collectionView.bottom+19.5;
    }];
  
}

+ (CGFloat)heightWithScenes:(NSArray *)scenes {
    CGFloat height = 15+ceil(kBFont(18).lineHeight);
    CGFloat space = 30;
    CGFloat left = 20;
    CGFloat count = 4;
//    CGFloat top = _titleLabel.bottom+30;
    CGFloat width = (kScreenWidth-left*2-space*(count-1))/count;
    CGFloat itemheight = (width+8+ceil(kFont(14).lineHeight));
    NSInteger row = ceil(scenes.count/count);
    height += 30 + row*itemheight+(row>0?(row-1)*17:0)+20;
    return height;
}
@end
