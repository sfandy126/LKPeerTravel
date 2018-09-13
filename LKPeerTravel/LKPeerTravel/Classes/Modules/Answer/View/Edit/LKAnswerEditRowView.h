//
//  LKAnswerEditRowView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAnswerEditRowView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) BOOL showSwitch;

@property (nonatomic,copy) void (^switchBlock)(BOOL isOn);

@end
