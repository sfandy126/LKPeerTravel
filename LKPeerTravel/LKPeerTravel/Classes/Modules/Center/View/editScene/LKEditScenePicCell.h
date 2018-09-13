//
//  LKEditScenePicCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKEditSceneCellModel.h"

static NSString *kLKEditScenePicCellReuserIndentifier = @"kLKEditScenePicCellReuserIndentifier";



@interface LKEditScenePicCell : UITableViewCell

@property (nonatomic, strong) LKEditSceneCellModel *data;


@end
