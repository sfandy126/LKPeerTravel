//
//  LKUserDetailServiceCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKServerModel.h"

static NSString *LKUserDetailServiceCellReuseIndentifier = @"LKUserDetailServiceCellReuseIndentifier";


@interface LKUserDetailServiceCell : UITableViewCell

@property (nonatomic, strong) LKServerModel *serverModel;

+ (CGFloat)heightWithModel:(LKServerModel *)model;

- (NSInteger)getPeopleNumber;
- (double)getPeopleDiscount;

@end
