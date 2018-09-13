//
//  LKMyServerSceneCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerSceneCell.h"
#import "LKMyServerCollectionView.h"

#import "LKMyServerMainView.h"

@interface LKMyServerSceneCell ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *addBut;
@property (nonatomic,strong) LKMyServerCollectionView *itemsView;
@property (nonatomic,strong) NSIndexPath *indesPath;
@property (nonatomic,strong) LKMyServerTypeModel *typeModel;

@end

@implementation LKMyServerSceneCell
- (UILabel *)titleLab{
    if (!_titleLab){
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 18, 100, 0)];
        _titleLab.text = @"景点";
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLab.textAlignment =  NSTextAlignmentLeft;
        _titleLab.font = kBFont(14);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
    }
    return _titleLab;
}

- (UIButton *)addBut{
    if (!_addBut) {
        _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBut.backgroundColor = [UIColor clearColor];
        _addBut.frame = CGRectMake(0, 0, 60,25);
        _addBut.right = kScreenWidth -15;
        _addBut.centerY = self.titleLab.centerY;
        [_addBut setTitle:@"添加" forState:UIControlStateNormal];
        _addBut.titleLabel.font = kFont(12);
        [_addBut setImage:[UIImage imageNamed:@"btn_service_plus_none"] forState:UIControlStateNormal];
        [_addBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _addBut.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _addBut.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        _addBut.imageEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
        [_addBut addTarget:self action:@selector(addButAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBut;
}

- (LKMyServerCollectionView *)itemsView{
    if (!_itemsView) {
        _itemsView = [[LKMyServerCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
         @weakify(self);
        _itemsView.deleteItemBlock = ^(LKMyServerCityModel *itemModel) {
            @strongify(self);
            if (self.deleteItemBlock) {
                self.deleteItemBlock(itemModel, self.typeModel);
            }
        };
    }
    return _itemsView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.addBut];
    self.itemsView.top = self.titleLab.bottom +20;
    [self.contentView addSubview:self.itemsView];
}


- (void)configData:(LKMyServerTypeModel *)data  indexPath:(NSIndexPath *)indexPath{
    self.typeModel = data;
    self.titleLab.text = data.title;
    self.indesPath = indexPath;
    [self.itemsView configData:data];
}

+ (CGFloat)getCellHeight:(LKMyServerTypeModel *)data indexPath:(NSIndexPath *)indexPath{
    return 50+data.itemsHeight;
}

- (void)addButAction{
    if ([self.mainView.delegate respondsToSelector:@selector(mainViewDidClickAdd:)]) {
        NSInteger type = 1;
        if (self.indesPath.section==2) {
            type = 3;
        } else if (self.indesPath.section==3) {
            type = 2;
        }
        [self.mainView.delegate mainViewDidClickAdd:type];
    }
}

@end





