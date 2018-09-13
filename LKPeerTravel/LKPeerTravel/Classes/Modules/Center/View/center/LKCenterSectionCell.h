//
//  LKCenterSectionCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LKCenterSectionCellReuseIndentifier = @"LKCenterSectionCellReuseIndentifier";

@class LKCenterSectionModel;

@interface LKCenterSectionCell : UITableViewCell

@property (nonatomic, strong) LKCenterSectionModel *sectionModel;
@property (nonatomic, assign) NSInteger section;

@end
