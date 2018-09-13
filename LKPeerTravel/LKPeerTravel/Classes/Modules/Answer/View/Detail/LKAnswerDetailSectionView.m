//
//  LKAnswerDetailSectionView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerDetailSectionView.h"

@interface LKAnswerDetailSectionView ()
@property (nonatomic,strong) UIView *spaceView;
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation LKAnswerDetailSectionView

- (UIView *)spaceView{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 10)];
        _spaceView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    }
    return _spaceView;
}

- (UILabel *)commentLab{
    if (!_commentLab) {
        _commentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLab.text = @"";
        _commentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _commentLab.font = kBFont(17);
        _commentLab.left = 20;
        _commentLab.width = 100;
        _commentLab.height = ceil(_commentLab.font.lineHeight);
    }
    return _commentLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self addSubview:self.spaceView];
        
        self.commentLab.top = self.spaceView.bottom +10;
        [self addSubview:self.commentLab];
    }
    return self;
}

- (void)configData:(LKAnswerDetailModel *)data{
    self.commentLab.text = [NSString stringWithFormat:@"评论(%zd)",data.comments.count];
    //    self.commentLab.centerY = self.height/2.0;
    self.commentLab.top = 17;
}


@end
