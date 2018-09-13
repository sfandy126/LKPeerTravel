//
//  LKTrackDetailCell.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailCell.h"

#define cellHeight 210

@interface LKTrackPersonCusttomView :UIView
@property (nonatomic,strong) UILabel *keyLab;
@property (nonatomic,strong) UILabel *valueLab;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *value;

@end

@implementation LKTrackPersonCusttomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _keyLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _keyLab.text = @"";
        _keyLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _keyLab.font = kFont(12);
        _keyLab.height = ceil(_keyLab.font.lineHeight);
        CGSize  size = [LKUtils sizeFit:@"出行人数" withUIFont:_keyLab.font withFitWidth:100 withFitHeight:_keyLab.height];
        _keyLab.width = size.width;
        [self addSubview:_keyLab];
        
        CGFloat inval = kScreenWidth<375?5:10;
        
        _valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLab.text = @"";
        _valueLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _valueLab.font = kBFont(12);
        _valueLab.left = _keyLab.right +inval;
        _valueLab.width = self.width -_valueLab.left;
        _valueLab.height = ceil(_valueLab.font.lineHeight);
        [self addSubview:_valueLab];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _keyLab.text = title;
}

- (void)setValue:(NSString *)value{
    _value = value;
    _valueLab.text= value;
}

@end

/****************************cellectionView *******************************/

#define itemWidth 71
#define itemHeight 71

static NSString *kLKTrackPersonMoreCollectionCellIdentify = @"kLKTrackPersonMoreCollectionCellIdentify";

@interface LKTrackPersonMoreCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconIV;

- (void)configData:(id)data;

@end

@implementation LKTrackPersonMoreCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        _iconIV.backgroundColor = [UIColor lightGrayColor];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.cornerRadius = 5.0;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
    }
    return self;
}

- (void)configData:(NSString *)imageUrl{
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}
@end


@interface LKTrackPersonMoreView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataLists;

@property (nonatomic,copy) void (^selectedBlock)(NSInteger index);

- (void)configData:(NSArray *)citys;

@end

@implementation LKTrackPersonMoreView

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
        
        CGRect rect = CGRectMake(0, 0, self.width, itemHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.alwaysBounceHorizontal = YES;
        [_collectionView registerClass:[LKTrackPersonMoreCollectionCell class] forCellWithReuseIdentifier:kLKTrackPersonMoreCollectionCellIdentify];
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
    LKTrackPersonMoreCollectionCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kLKTrackPersonMoreCollectionCellIdentify forIndexPath:indexPath];
    NSDictionary *dic = [NSDictionary getDictonary:[self.dataLists objectAt:indexPath.item]];
    NSString *imageUrl = [NSString stringValue:[dic valueForKey:@"imageUrl"]];
    [cell configData:imageUrl];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.item);
    }
}


- (void)configData:(NSArray *)citys{
    self.dataLists = [NSArray getArray:citys];
    [self.collectionView reloadData];
}

@end


/************************************************************************/


@interface LKTrackDetailCell ()

@property (nonatomic,strong) UIView *bgView;
///用户头像
@property (nonatomic,strong) UIImageView *headIcon;
///用户名称
@property (nonatomic,strong) UILabel *nameLab;


@property (nonatomic,strong) NSArray *views;

@property (nonatomic,strong) LKTrackPersonMoreView *moreView;
@end

@implementation LKTrackDetailCell

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10*2, cellHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)headIcon{
    if (!_headIcon) {
        CGFloat iconW = kScreenWidth<375?40:70;
        CGFloat leftX = kScreenWidth<375?10:17;
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(leftX, 17, iconW, iconW)];
        _headIcon.backgroundColor = [UIColor lightGrayColor];
        _headIcon.layer.cornerRadius = _headIcon.width/2.0;
        _headIcon.layer.masksToBounds = YES;
        _headIcon.contentMode = UIViewContentModeScaleAspectFit;
        _headIcon.clipsToBounds = YES;
    }
    return _headIcon;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 0)];
        _nameLab.text = @"";
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLab.font = kBFont(16);
        _nameLab.height = ceil(_nameLab.font.lineHeight);
    }
    return _nameLab;
}

- (LKTrackPersonMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[LKTrackPersonMoreView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, itemHeight)];
    }
    return _moreView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bgView];
        
        [self.bgView addSubview:self.headIcon];
        
        self.nameLab.left = self.headIcon.right +(kScreenWidth<375?5:10);
        self.nameLab.top = self.headIcon.top;
        [self.bgView addSubview:self.nameLab];
        
        CGFloat invalX = kScreenWidth<375?5:10;
        CGFloat invalY = kScreenWidth<375?5:10;
        CGFloat singleWidth = (kScreenWidth - (self.nameLab.left +invalX))/2;
        CGFloat leftX = self.nameLab.left;
        CGFloat topY = self.nameLab.bottom + 26;
        NSArray *titles = @[@"出发时间",@"出行人数",@"出行天数",@"人均消费"];
        NSInteger index =0;
        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *title in titles) {
            LKTrackPersonCusttomView *view = [[LKTrackPersonCusttomView alloc] initWithFrame:CGRectMake(0, 0, singleWidth, 20)];
            view.left = leftX +(view.width +invalX)*(index%2);
            view.top = topY  +(view.height+invalY)*(index/2);
            view.title = title;
            [self.bgView addSubview:view];
            [temp addObject:view];
            index++;
        }
        self.views = [temp copy];
        
        
        self.moreView.bottom = self.bgView.height - 20;
        [self.bgView addSubview:self.moreView];
    }
    return self;
}

- (void)configData:(LKTrackInfoModel *)model{
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:nil];
    
    self.nameLab.text = model.nick_name;
    
    NSArray *values = @[[NSString stringValue:model.datTravelStr],[NSString stringWithFormat:@"%@人",(model.peoples.length==0?@"0":model.peoples)],[NSString stringWithFormat:@"%@天",(model.days.length==0?@"0":model.days)],[NSString stringWithFormat:@"¥%@",(model.perCapital.length==0?@"0":model.perCapital)]];
    NSInteger index = 0;
    for (LKTrackPersonCusttomView *view in self.views) {
        view.value = [values objectAtIndex:index];
        index++;
    }
    
    [self.moreView configData:model.city_icons];
    self.moreView.selectedBlock = ^(NSInteger index) {
        [LKMediator openImageBrowse:@{@"images":[NSArray getArray:model.city_icons],@"foot_id":[NSString stringValue:model.footprintNo],@"content":[NSString stringValue:model.content],@"curIndex":@(index)}];
    };
}

+ (CGFloat)getCellHeight:(id)data{
    return cellHeight;
}

@end
