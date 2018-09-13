//
//  LKAnswerSectionView.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerSectionView.h"

@interface LKAnswerSectionView ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *moreBut;
@property (nonatomic,assign) BOOL isHot;

@end

@implementation LKAnswerSectionView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title isHot:(BOOL)isHot
{
    self = [super initWithFrame:frame];
    if (self) {
        _isHot = isHot;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, self.height)];
        _titleLab.text = title;
        _titleLab.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self addSubview:_titleLab];
        
        _moreBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBut.backgroundColor = [UIColor clearColor];
        _moreBut.frame = CGRectMake(0, 0, 40,25);
        _moreBut.right = self.width-23;
        _moreBut.centerY = self.height/2;
        [_moreBut setTitle:@"全部" forState:UIControlStateNormal];
        [_moreBut setImage:[UIImage imageNamed:@"btn_home_into_none"] forState:UIControlStateNormal];
        [_moreBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _moreBut.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _moreBut.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        _moreBut.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [_moreBut addTarget:self action:@selector(moreButAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBut];
    }
    return self;
}

- (void)moreButAction{
    if (self.moreButBlock) {
        self.moreButBlock(self.isHot);
    }
}


@end
