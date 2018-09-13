//
//  LKTrackDetailHeaderView.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackDetailModel.h"

@interface LKTrackDetailHeaderView : UIView

@property (nonatomic,copy) void (^clickedHeaderBlock)(LKTrackInfoModel *model);

- (void)configData:(LKTrackInfoModel *)model;


@end
