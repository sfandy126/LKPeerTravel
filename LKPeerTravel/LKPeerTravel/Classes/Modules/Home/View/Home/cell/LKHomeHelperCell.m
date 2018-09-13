//
//  LKHomeHelperCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeHelperCell.h"
#import "LKHomeRightButView.h"
#import "LKWishEditViewController.h"

#define kItemCount 4 //最多展示4个
#define itemLeft 10.0 //collection的insetLeft
#define itemWidth  70.0
#define itemHeight (74+8+20)
#define itemInval 10

static NSString *kLKHomeHelpCollectionCellIdentify = @"kLKHomeHelpCollectionCellIdentify";

@interface LKHomeHelperCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LKHomeRightButView *batchButView;//换一批按钮
@property (nonatomic,strong) UILabel *emptyLab;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray<LKHomeGuideModel *> *dataLists;
@end

@implementation LKHomeHelperCell

- (void)createView{
    [super createView];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 0)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10.0;
    _bgView.layer.masksToBounds = YES;
    _bgView.clipsToBounds = YES;
    _bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bgView];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 45)];
    _titleLab.text = @"私人助手";
    _titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_bgView addSubview:_titleLab];
    
    _lineView = [UIView createLineWithX:0 y:_titleLab.bottom];
    [_bgView addSubview:_lineView];
    
    
    _batchButView = [[LKHomeRightButView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _batchButView.right = _bgView.width-15;
    _batchButView.centerY = _titleLab.height/2;
    _batchButView.title = @"换一批";
    _batchButView.image = [UIImage imageNamed:@"btn_home_renovate_none"];
    _batchButView.imageSize = CGSizeMake(38/3, 38/3);
    _batchButView.inval = 3;
    @weakify(self);
    _batchButView.selectedBlock = ^{
        @strongify(self);
        [self batchButAction];
    };
    [_bgView addSubview:_batchButView];
    
    _emptyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineView.bottom, _bgView.width, 0)];
    _emptyLab.backgroundColor = [UIColor clearColor];
    _emptyLab.text = @"发布心愿单，寻找您的私人助手";
    _emptyLab.font = [UIFont systemFontOfSize:12.0];
    _emptyLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _emptyLab.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_emptyLab];
    [_emptyLab g_addTapWithTarget:self action:@selector(emptyAction)];
    
    [_bgView addSubview:self.collectionView];
}

- (void)emptyAction {
    LKNavigationViewController *navi = [[LKNavigationViewController alloc] initWithRootViewController:[LKWishEditViewController new]];
    [LKMediator presentViewController:navi animated:YES];
}

- (void)configData:(id)data{
    [super configData:data];
    CGFloat cellHeight = [[self class] getCellHeight:data];
    _bgView.height = cellHeight;
    
    NSArray *items = [NSArray getArray:data];
    _emptyLab.hidden = items.count>0;
    self.collectionView.hidden = items.count==0;
    if (items.count==0) {
        _emptyLab.height = _bgView.height -_lineView.bottom;
    }else{
        self.collectionView.width = _bgView.width;
        self.collectionView.centerY = _lineView.bottom + (_bgView.height - _lineView.bottom)/2.0;
        self.dataLists = items;
        [self.collectionView reloadData];
    }
    
}

+ (CGFloat)getCellHeight:(id)data{
    return 186.0;
}

//点击换一批
- (void)batchButAction{
    if (self.batchButBlock) {
        self.batchButBlock();
    }
}

#pragma mark - - collectionView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = itemInval;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, itemHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[LKHomeHelperCollectionCell class] forCellWithReuseIdentifier:kLKHomeHelpCollectionCellIdentify];
    }
    return _collectionView;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //最多展示4个
    return self.dataLists.count<=kItemCount?self.dataLists.count:kItemCount;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKHomeHelperCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kLKHomeHelpCollectionCellIdentify forIndexPath:indexPath];
    
    if (self.dataLists.count>0) {
        LKHomeGuideModel *model = [self.dataLists objectAt:indexPath.item];
        [cell configData:model]; 
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LKHomeGuideModel *model = [self.dataLists objectAt:indexPath.item];

    if (self.clickGuideBlock) {
        self.clickGuideBlock([NSString stringValue:model.uid]);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, itemLeft, 0, itemLeft);
}


@end

@interface LKHomeHelperCollectionCell ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *nickLab;

@end

@implementation LKHomeHelperCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        _iconIV.centerX = itemWidth/2;
        _iconIV.backgroundColor = [UIColor lightGrayColor];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.cornerRadius = _iconIV.width/2;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        
        _nickLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconIV.bottom+8, itemWidth, 0)];
        _nickLab.backgroundColor = [UIColor clearColor];
        _nickLab.text = @"";
        _nickLab.font = [UIFont boldSystemFontOfSize:12.0];
        _nickLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nickLab.height = ceil(_nickLab.font.lineHeight);
        _nickLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nickLab];

    }
    return self;
}

- (void)configData:(LKHomeGuideModel *)model{
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:model.face]] placeholderImage:nil];
    _nickLab.text = [NSString stringValue:model.nick_name];
}
@end
