//
//  LKUserDetailCanlenderCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/21.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKServerModel.h"
#import "LKUserDetailMainView.h"

static NSString *LKUserDetailCanlenderCellReuseIdentifier = @"LKUserDetailCanlenderCellReuseIdentifier";

@interface LKUserDetailCanlenderCell : UITableViewCell

@property (nonatomic, weak) LKUserDetailMainView *mainView;
@property (nonatomic, strong) LKServerModel *serverModel;

@property (nonatomic, strong) NSString *beginDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, assign) NSInteger days;

+ (CGFloat)heightWithModel:(LKServerModel *)model;


@end
