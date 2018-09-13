//
//  LKUserDetailPhotoCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailPhotoCell.h"

#import "LKSceneDetailViewController.h"

@implementation LKUserDetailPhotoCell

{
    UILabel *_titleLabel;
    NSArray *_datas;
}

+ (CGFloat)heightWithModel:(LKServerModel *)model {
    CGFloat space = 30;
    CGFloat left = 20;
    CGFloat count = 4;
    CGFloat top = 15+ceil(kFont(18).lineHeight)+30;
    CGFloat width = (kScreenWidth-left*2-space*(count-1))/count;
    return top+width+12+ceil(kBFont(12).lineHeight)+20;
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
    _titleLabel.text = @"景点";
    _titleLabel.frame = CGRectMake(27, 15,100, ceil(_titleLabel.font.lineHeight));
    [self.contentView addSubview:_titleLabel];
    
    UIImageView *arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    arrowIcon.image = [UIImage imageNamed:@"btn_home_into_none"];
    arrowIcon.centerY = _titleLabel.centerY;
    arrowIcon.right = kScreenWidth-27;
    [self.contentView addSubview:arrowIcon];
    
   UILabel *allLabel = [UILabel new];
    allLabel.font = [UIFont systemFontOfSize:12];
    allLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    allLabel.text = @"全部";
    allLabel.frame = CGRectMake(27, 15,100, ceil(allLabel.font.lineHeight));
    [allLabel sizeToFit];
    allLabel.right = arrowIcon.left-3;
    allLabel.centerY = _titleLabel.centerY;
    [self.contentView addSubview:allLabel];
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(allLabel.left, 0, arrowIcon.right-allLabel.left, 44);
    allBtn.centerY = _titleLabel.centerY;
    [allBtn addTarget:self action:@selector(allBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:allBtn];
    
    CGFloat space = 30;
    CGFloat left = 20;
    CGFloat count = 4;
    CGFloat top = _titleLabel.bottom+30;
    CGFloat width = (kScreenWidth-left*2-space*(count-1))/count;
    for (int i=0; i<count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, width, width)];
        iv.layer.cornerRadius = 5;
        iv.layer.masksToBounds = YES;
        [iv sd_setImageWithURL:[NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/2943762-14f6b0d53e185d43?imageMogr2/auto-orient/strip|imageView2/1/w/300/h/240"]];
        iv.backgroundColor = [UIColor redColor];
        iv.tag = 100+i;
        [self.contentView addSubview:iv];
        left = iv.right+space;
        
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.frame = CGRectMake(iv.left, iv.bottom+8, iv.width, ceil(label.font.lineHeight));
        label.text = @"景点名称";
        label.tag = 200+i;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(iv.left, top, width, label.bottom-top);
        [self.contentView addSubview:btn];
        btn.tag = 300+i;
        [btn addTarget:self action:@selector(sceneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==count-1) {
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(27, label.bottom+19.5, kScreenWidth-27, 0.5)];
            line2.backgroundColor = kColorLine2;
            [self.contentView addSubview:line2];
        }
    }
}

- (void)sceneAction:(UIButton *)sender {
    NSDictionary *dict = [_datas objectAt:sender.tag-300];
    if ([NSDictionary isEmptyDict:dict]) {
        return;
    }
    LKSceneDetailViewController *vc = [[LKSceneDetailViewController alloc] init];
    vc.scene_no = dict[@"codDestinationPointNo"];
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        vc.is_choose = YES;
         @weakify(self);
        vc.finishedSelectedBlock = ^(NSDictionary *dict) {
            @strongify(self);
            NSInteger point_type = 0;
            if (self.cellType==PhotoCellType_scene) {
                point_type = 1;
            } else if (self.cellType==PhotoCellType_mall) {
                point_type = 2;
            } else if (self.cellType==PhotoCellType_food) {
                point_type = 3;
            }
            [self.mainView finishAddScenes:@[dict] pointType:point_type];
        };
    }
    [LKMediator pushViewController:vc animated:YES];
}

- (void)allBtnAction {
    if ([self.mainView.delegate respondsToSelector:@selector(clickAllBtnAtPointType:)]) {
        NSInteger point_type = 0;
        if (self.cellType==PhotoCellType_scene) {
            point_type = 1;
        } else if (self.cellType==PhotoCellType_mall) {
            point_type = 2;
        } else if (self.cellType==PhotoCellType_food) {
            point_type = 3;
        }
        [self.mainView.delegate clickAllBtnAtPointType:point_type];
    }
}

- (void)setCellType:(PhotoCellType)cellType {
    _cellType = cellType;
    
    NSArray *datas;
    if (cellType==PhotoCellType_scene) {
        _titleLabel.text = @"景点";
        datas = _serverModel.attractions;
    } else if (cellType==PhotoCellType_food) {
        _titleLabel.text = @"美食";
        datas = _serverModel.foods;
    } else {
        _titleLabel.text = @"商城";
        datas = _serverModel.shopps;
    }
    _datas = datas;
    for (int i=0; i<4; i++) {
        NSDictionary *dict = [datas objectAt:i];
        UIImageView *iv = [self.contentView viewWithTag:100+i];
        UILabel *label = [self.contentView viewWithTag:200+i];
        UIButton *btn = [self.contentView viewWithTag:300+i];
        if (dict) {
            iv.hidden = NO;
            label.hidden = NO;
            btn.hidden = NO;
            [iv sd_setImageWithURL:dict[@"codDestinationPointLogo"]];
            label.text = dict[@"codDestinationPointName"];
        } else {
            iv.hidden = YES;
            label.hidden = YES;
            btn.hidden = YES;
        }
    }
}


@end
