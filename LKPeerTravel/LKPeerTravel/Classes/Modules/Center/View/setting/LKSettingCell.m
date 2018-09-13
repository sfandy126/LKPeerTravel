//
//  LKSettingCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSettingCell.h"

@interface LKSettingCell ()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subTitleLab;
@property (nonatomic,strong) UIImageView *arrowIcon;

@end

@implementation LKSettingCell

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 0)];
        _titleLab.text = @"";
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = kFont(12);
        _titleLab.height = ceil(_titleLab.font.lineHeight);
        _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 0)];
        _subTitleLab.text = @"";
        _subTitleLab.textAlignment = NSTextAlignmentRight;
        _subTitleLab.font = kFont(12);
        _subTitleLab.height = ceil(_titleLab.font.lineHeight);
        _subTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _subTitleLab;
}

- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _arrowIcon.image = [UIImage imageNamed:@"btn_home_into_none"];
    }
    return _arrowIcon;
}

- (void)createView{
    [super createView];
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.subTitleLab];
    [self.contentView addSubview:self.arrowIcon];
}

- (void)configData:(id)data{
    [super configData:data];
    
    LKSettingRowModel *model = (LKSettingRowModel *)data;
    self.titleLab.text = model.title;
    self.titleLab.centerY = self.height/2.0;
    self.titleLab.left = 20;
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    self.titleLab.font = kFont(12);
    
    self.subTitleLab.text = model.subTitle;
    self.subTitleLab.centerY = self.height/2.0;
    
    self.arrowIcon.right = self.width-20;
    self.arrowIcon.centerY = self.height/2.0;
    self.arrowIcon.hidden = NO;
    
    self.subTitleLab.right = self.arrowIcon.left -5;
    self.subTitleLab.hidden = NO;
   
    if (model.rowType == LKSettingRowType_clearCache){
        self.subTitleLab.hidden = NO;
        self.subTitleLab.right = self.width - 20;
        self.arrowIcon.hidden = YES;
        
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            NSUInteger allsize = totalSize;
            NSString *canStr = @"B";
            if (allsize>=1024) {//kb
                allsize =allsize*1.0/1024;
                canStr =@"KB";
            }
            if (allsize>=1024) {//mb
                allsize =allsize*1.0/1024;
                canStr =@"M";
            }
            
            self.subTitleLab.text = [NSString stringWithFormat:@"%zd%@",allsize,canStr];
        }];
    }
}

+ (CGFloat)getCellHeight:(id)data{
 
    return 50;
}

@end
