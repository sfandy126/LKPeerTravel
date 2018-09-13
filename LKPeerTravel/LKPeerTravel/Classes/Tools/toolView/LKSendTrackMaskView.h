//
//  LKSendTrackMaskView.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//


/**
 *  发布足迹弹窗
 *
 *
 **/

#import <UIKit/UIKit.h>

@interface LKSendTrackMaskView : UIView

@property (nonatomic,copy) void (^selectedBlock)(NSInteger index);

- (void)show;

- (void)hide;

@end



