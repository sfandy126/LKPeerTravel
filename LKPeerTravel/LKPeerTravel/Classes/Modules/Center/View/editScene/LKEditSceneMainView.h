//
//  LKEditSceneMainView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKEditSceneModel.h"


@interface LKEditSceneMainView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(LKEditSceneModel *)model type:(NSInteger)type;

- (NSArray *)getRowContents;
- (NSArray *)getSceneContents;

@end
