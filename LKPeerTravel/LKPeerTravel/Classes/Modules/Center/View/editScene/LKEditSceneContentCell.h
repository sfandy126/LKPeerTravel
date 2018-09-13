//
//  LKEditSceneContentCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kLKEditSceneContentCellReuserIndentifier = @"kLKEditSceneContentCellReuserIndentifier";

@interface LKEditSceneContentCell : UITableViewCell

@property (nonatomic, copy) void (^updateCellHeight) (CGFloat height);
@property (nonatomic, strong) NSMutableArray *datas;

- (void)insetImage:(UIImage *)image;


@end
