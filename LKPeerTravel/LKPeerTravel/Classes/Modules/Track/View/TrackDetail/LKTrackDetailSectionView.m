//
//  LKTrackDetailSectionView.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailSectionView.h"

@interface LKTrackDetailSectionView ()
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation LKTrackDetailSectionView


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
        [self addSubview:self.commentLab];
    }
    return self;
}

- (void)configData:(LKTrackDetailModel *)data{
    self.commentLab.text = [NSString stringWithFormat:@"评论(%zd)",data.comments.count];
//    self.commentLab.centerY = self.height/2.0;
    self.commentLab.top = 17;
}




@end
