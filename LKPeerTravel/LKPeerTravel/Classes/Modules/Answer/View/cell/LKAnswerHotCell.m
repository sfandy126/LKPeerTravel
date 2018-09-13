//
//  LKAnswerHotCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerHotCell.h"

#define itemWidth 340.0
#define itemHeight 130.0

@class LKAnswerHotAnswerCell;
static NSString *kLKAnswerHotAnswerCellIdentify = @"kLKAnswerHotAnswerCellIdentify";

@interface LKAnswerHotCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataLists;
@end



@implementation LKAnswerHotCell

- (void)createView{
    [super createView];
    
    [self addSubview:self.collectionView];

}

- (void)configData:(id)data{
    [super configData:data];
    
    self.dataLists = [NSArray getArray:data];
    [self.collectionView reloadData];
}

+ (CGFloat)getCellHeight:(id)data{
    return itemHeight;
}

#pragma mark - - collectionView

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =  [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 10.0;
        
        CGRect rect = CGRectMake(0, 0, kScreenWidth, itemHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[LKAnswerHotAnswerCell class] forCellWithReuseIdentifier:kLKAnswerHotAnswerCellIdentify];
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
    LKAnswerHotAnswerCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kLKAnswerHotAnswerCellIdentify forIndexPath:indexPath];
    
    if (self.dataLists.count>0) {
        LKAnswerSingleModel *model = [self.dataLists objectAt:indexPath.item];
        [cell configData:model];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LKAnswerSingleModel *item = [self.dataLists objectAt:indexPath.item];
    
    if (self.selectedBlock) {
        self.selectedBlock(item);
    }
}





@end


@interface LKAnswerHotAnswerCell ()
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *contentLab;

//参与者
@property (nonatomic,strong) UIImageView *joinerIcon;
@property (nonatomic,strong) UILabel *joinerLab;

@end

@implementation LKAnswerHotAnswerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 70, 70)];
        _iconIV.backgroundColor = [UIColor lightGrayColor];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.cornerRadius = _iconIV.height/2.0;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.clipsToBounds = YES;
        [self.contentView addSubview:_iconIV];
        
        //昵称
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.text = @"";
        _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_nameLab];
        
        //正文
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.backgroundColor = [UIColor clearColor];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_contentLab];
        
        //参与者
        _joinerLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _joinerLab.text = @"";
        _joinerLab.backgroundColor = [UIColor clearColor];
        _joinerLab.font = [UIFont boldSystemFontOfSize:12.0];
        _joinerLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _joinerLab.height = ceil(_joinerLab.font.lineHeight);
        _joinerLab.hidden = YES;
        [self addSubview:_joinerLab];
        
        _joinerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _joinerIcon.image = [UIImage imageNamed:@"img_answer_people"];
        _joinerIcon.hidden = _joinerLab.hidden;
        [self addSubview:_joinerIcon];
        
    }
    return self;
}

- (void)configData:(LKAnswerSingleModel *)model{
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringValue:model.face]] placeholderImage:nil];
    
    //昵称
    _nameLab.font = [UIFont boldSystemFontOfSize:16.0];
    _nameLab.text = [NSString stringValue:model.nick_name];
    _nameLab.top = 17.0;
    _nameLab.left = _iconIV.right +10;
    _nameLab.width = 100;
    _nameLab.height = ceil(_nameLab.font.lineHeight);
    
    //正文
    _contentLab.font = [UIFont systemFontOfSize:12.0];
    _contentLab.text = [NSString stringValue:model.content];
    _contentLab.top = _nameLab.bottom +5;
    _contentLab.left = _nameLab.left;
    _contentLab.width = itemWidth - _nameLab.left -17.0;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_contentLab.text];
    [attri addAttributes:@{NSFontAttributeName : _contentLab.font,
                           NSParagraphStyleAttributeName:style
                           } range:NSMakeRange(0, attri.length)];
    _contentLab.attributedText = attri;
    CGSize contentSize = [LKUtils sizeAttributedString:attri withUIFont:_contentLab.font withFitWidth:_contentLab.width withFitHeight:1000];
    CGFloat maxHeight = itemHeight - _contentLab.top - 20;
    if (contentSize.height<maxHeight) {
        _contentLab.height = contentSize.height;
    }else{
        _contentLab.height = maxHeight;
    }

    _contentLab.numberOfLines = 0;
    _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //参与者
    _joinerLab.hidden = _joinerIcon.hidden = model.join_num.length==0;
    _joinerLab.text = [NSString stringWithFormat:@"%@人参与",model.join_num];
    CGSize joinerSize = [LKUtils sizeFit:_joinerLab.text withUIFont:_joinerLab.font withFitWidth:100 withFitHeight:_joinerLab.height];
    _joinerLab.width = joinerSize.width;
    _joinerLab.right = self.width - 17;
    
    _joinerIcon.right = _joinerLab.left -4;
    _joinerIcon.bottom = _nameLab.bottom;
    _joinerLab.centerY = _joinerIcon.centerY;
    
}


@end
