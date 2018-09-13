//
//  LKAnswerDetailCommentCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerDetailCommentCell.h"

//第一级昵称的顶部间隙
#define kNameTop 17
//第一级回复内容的顶部间隙
#define kContentTop 5
#define kTimeTop 20

//第二级回复表格顶部间隙
#define kSubTableTop 5
//第二级回复内容顶部间隙
#define kSubContentTop 10
//第二级回复内容之间的间隙
#define kSubContentInval 10

@class LKAnswerDetailSubCommentCell;
@interface LKAnswerDetailCommentCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *iconIV;//头像
@property (nonatomic,strong) UILabel *nameLab;///昵称
@property (nonatomic,strong) UILabel *contentLab;///评论内容
@property (nonatomic,strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UIButton *commentBut;//回复按钮

@property (nonatomic,strong) UIImageView *tableContentIcon;//子回复列表背景
@property (nonatomic,strong) UITableView *tableView;//子级回复列表
@property (nonatomic,strong) NSArray *subComments;//子级回复列表

@end

@implementation LKAnswerDetailCommentCell

- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        _iconIV.contentMode = UIViewContentModeScaleAspectFit;
        _iconIV.clipsToBounds = YES;
        _iconIV.layer.cornerRadius = _iconIV.width/2.0;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconIV;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.text = @"";
        _nameLab.textColor = [UIColor colorWithHexString:@"#646464"];
        _nameLab.font = kFont(14);
        _nameLab.width = 100;
        _nameLab.height = ceil(_nameLab.font.lineHeight);
    }
    return _nameLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _contentLab.font = kFont(14);
        _contentLab.height = ceil(_contentLab.font.lineHeight);
    }
    return _contentLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.text = @"";
        _timeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
        _timeLab.font = kFont(10);
        _timeLab.width = 200;
        _timeLab.height = ceil(_timeLab.font.lineHeight);
    }
    return _timeLab;
}

- (UIButton *)commentBut{
    if (!_commentBut) {
        _commentBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBut.frame = CGRectMake(0, 0, 16,16);
        _commentBut.imageView.size = CGSizeMake(16, 16);
        [_commentBut setImage:[UIImage imageNamed:@"img_foot_talk"] forState:UIControlStateNormal];
    }
    return _commentBut;
}

- (UIImageView *)tableContentIcon{
    if (!_tableContentIcon) {
        _tableContentIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tableContentIcon.backgroundColor = [UIColor lightGrayColor];
        _tableContentIcon.width = kScreenWidth -(20+40+10)-20;
        _tableContentIcon.layer.cornerRadius = 2.0;
        _tableContentIcon.layer.masksToBounds = YES;
    }
    return _tableContentIcon;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth -(20+40+10)-20, 0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor =[ UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.scrollEnabled = NO;
        _tableView.allowsSelection = NO;
        _tableView.delegate =self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[LKAnswerDetailSubCommentCell class] forCellReuseIdentifier:kLKAnswerDetailSubCommentCellIdentify];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.subComments.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKAnswerDetailSubCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKAnswerDetailSubCommentCellIdentify forIndexPath:indexPath];
    LKAnswerCommentModel *item = [self.subComments objectAt:indexPath.section];
    [cell configData:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKAnswerCommentModel *item = [self.subComments objectAt:indexPath.section];
    return [LKAnswerDetailSubCommentCell getSubCellHeight:item];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kSubContentInval;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.iconIV];
        
        self.nameLab.top  = self.iconIV.top;
        self.nameLab.left = self.iconIV.right+10;
        [self.contentView addSubview:self.nameLab];
        
        self.contentLab.left = self.nameLab.left;
        self.contentLab.top = self.nameLab.bottom +5;
        self.contentLab.width = kScreenWidth - self.contentLab.left -20;
        [self.contentView addSubview:self.contentLab];
        
        self.timeLab.left = self.nameLab.left;
        [self.contentView addSubview:self.timeLab];
        
        self.commentBut.right = kScreenWidth-20;
        [self.contentView addSubview:self.commentBut];
        
        self.tableContentIcon.hidden = YES;
        [self.contentView addSubview:self.tableContentIcon];
        self.tableView.hidden = self.tableContentIcon.hidden;
        [self.tableContentIcon addSubview:self.tableView];
        
    }
    return self;
}


- (void)configData:(LKAnswerCommentModel *)data indexPath:(NSIndexPath *)indexPath{
    
    self.nameLab.text = data.customerNm;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.portraitPic] placeholderImage:nil];
    
    self.contentLab.text = data.answerContent;
    self.contentLab.height = [[self class] getCommentContentHeight:data.answerContent];
    self.contentLab.numberOfLines = 0;
    self.contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.timeLab.text = data.datCreate;
    self.timeLab.top = self.contentLab.bottom+20;
    
    self.commentBut.centerY = self.timeLab.centerY;
    
    
    self.subComments = [NSArray getArray:data.comments];
    self.tableView.hidden = self.subComments.count==0;
    self.tableContentIcon.hidden = self.tableView.hidden;
    
    self.tableContentIcon.top = self.timeLab.bottom +kSubTableTop;
    self.tableContentIcon.left = self.timeLab.left;
    self.tableContentIcon.height = [[self class] getSubCommentTableHeight:self.subComments];
    
    self.tableView.top = kSubContentTop;
    self.tableView.height = self.tableContentIcon.height - self.tableView.top*2;
    [self.tableView reloadData];
}

//获取第一级评论内容的高度
+ (CGFloat )getCommentContentHeight:(NSString *)content{
    CGSize size = [LKUtils sizeFit:[NSString stringValue:content] withUIFont:kFont(14) withFitWidth:(kScreenWidth -(20+40+10) -20) withFitHeight:1000];
    return size.height;
}

//获取子级评论内容的高度
+ (CGFloat )getSubCommentContentHeight:(NSString *)content{
    CGSize size = [LKUtils sizeFit:[NSString stringValue:content] withUIFont:kFont(14) withFitWidth:(kScreenWidth -(20+40+10) -20 -20) withFitHeight:1000];
    return size.height;
}

//获取子回复表格的高度
+ (CGFloat )getSubCommentTableHeight:(NSArray *)subConments{
    CGFloat subContentH = 0;
    if (subConments.count>0) {
        subContentH = kSubContentTop*2;
        for (LKAnswerCommentModel *subItem in subConments) {
            subContentH += [[self class] getSubCommentContentHeight:subItem.answerContent];
        }
        
        subContentH += kSubContentInval *(subConments.count-1);
    }
    return subContentH;
}

+ (CGFloat)getCellHeight:(LKAnswerCommentModel *)data indexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = kNameTop + ceil(kFont(14).lineHeight) +kContentTop;
    //第一级回复内容高度
    CGFloat contentH = [[self class] getCommentContentHeight:data.answerContent];
    cellHeight +=contentH;
    
    //时间
    cellHeight += (kTimeTop +ceil(kFont(10).lineHeight));
    
    //子级回复内容高度
    if ([NSArray getArray:data.comments].count>0) {
        CGFloat subContentH = [[self class] getSubCommentTableHeight:[NSArray getArray:data.comments]];
        //子回复容器底部的间隙（与下一个Cell）
        subContentH+=10;
        cellHeight += subContentH;
    }
    
    return cellHeight;
}

@end


@implementation LKAnswerDetailSubCommentCell

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.text = @"";
        _contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        _contentLab.font = kFont(14);
        _contentLab.height = ceil(_contentLab.font.lineHeight);
    }
    return _contentLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.contentLab.left = 5;
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

- (void)configData:(LKAnswerCommentModel *)subItem{
    self.contentLab.text = subItem.answerContent;
    self.contentLab.width = (kScreenWidth -(20+40+10) - 20-20);
    CGSize subContentSize = [LKUtils sizeFit:[NSString stringValue:subItem.answerContent] withUIFont:kFont(14) withFitWidth:self.contentLab.width withFitHeight:1000];
    self.contentLab.height = subContentSize.height;
    self.contentLab.numberOfLines = 0;
    self.contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

+ (CGFloat )getSubCellHeight:(LKAnswerCommentModel *)subItem{
    if (subItem) {
        CGSize subContentSize = [LKUtils sizeFit:[NSString stringValue:subItem.answerContent] withUIFont:kFont(14) withFitWidth:(kScreenWidth -(20+40+10) - 20-20) withFitHeight:1000];
        return subContentSize.height;
    }
    return CGFLOAT_MIN;
}

@end


