//
//  LKWishEditMarkCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishEditMarkCell.h"

#import "LKWishTagListView.h"

@implementation LKWishEditMarkCell

{
    UILabel *_titleLabel;
    UIButton *_addBtn;
    LKWishTagListView *_tagView;
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
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = kColorGray1;
    _titleLabel.frame = CGRectMake(20, 0, 100, 50);
    _titleLabel.text = @"心愿标签";
    [self.contentView addSubview:_titleLabel];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setTitleColor:kColorGray1 forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_addBtn setTitle:@"添加+" forState:UIControlStateNormal];
    _addBtn.frame = CGRectMake(0, 0, 80, 50);
    [_addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.right = kScreenWidth-10;
    [self.contentView addSubview:_addBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_titleLabel.left, 0, kScreenWidth-_titleLabel.left, 0.5)];
    line.backgroundColor = kColorLine1;
    [self.contentView addSubview:line];
    line.bottom = 50;
    
    LKWishTagListView *tagView = [[LKWishTagListView alloc] initWithFrame:CGRectMake(0, line.bottom, kScreenWidth, 0)];
     @weakify(self);
    tagView.deleteWishBlock = ^(NSDictionary *dict) {
        @strongify(self);
        if (self.deleteWishBlock) {
            self.deleteWishBlock(dict);
        }
    };
    [self.contentView addSubview:tagView];
    _tagView = tagView;
}

- (void)addAction:(UIButton *)sender {
    if (self.addWishBlock) {
        self.addWishBlock();
    }
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    _tagView.tags = tags;
}

+ (CGFloat)cellHeightWidthTags:(NSArray *)tags {
    CGFloat height = [LKWishTagListView heightWithTags:tags];
    return height+50;
}

@end
