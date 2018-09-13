//
//  LKCenterRowCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LKCenterRowCellReuseIndentifier = @"LKCenterRowCellReuseIndentifier";

@class LKCenterRowModel;

@interface LKCenterRowCell : UITableViewCell

@property (nonatomic, strong) LKCenterRowModel *rowModel;

@end
