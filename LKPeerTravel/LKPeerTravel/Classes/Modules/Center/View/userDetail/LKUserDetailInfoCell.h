//
//  LKUserDetailInfoCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKUserDetailModel.h"

static NSString *LKUserDetailInfoCellReuseIndentifier = @"LKUserDetailInfoCellReuseIndentifier";

@class LKUserDetailMainView;

@interface LKUserDetailInfoCell : UITableViewCell

@property (nonatomic, weak) LKUserDetailMainView *mainView;
@property (nonatomic, strong) LKUserDetailModel *detailModel;

+ (CGFloat)heightWithModel:(LKUserDetailModel *)model;

@end

@interface LKUserDetailInfoIconView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title icon:(NSString *)icon;

@end
