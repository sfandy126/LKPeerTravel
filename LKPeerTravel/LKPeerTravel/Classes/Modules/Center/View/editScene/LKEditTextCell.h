//
//  LKEditTextCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKEditSceneCellModel.h"

@interface LKEditTextCell : UITableViewCell

@property (nonatomic, strong) LKEditSceneCellModel *model;

@property (nonatomic, strong) NSString *placeholder;

- (NSString *)addText;

- (void)beginEdit;

@end
