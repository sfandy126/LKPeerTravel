//
//  LKEditSceneToolView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKEditSceneToolView : UIView

@property (nonatomic,copy) void (^btnClickBlock)(NSInteger index);

@end
