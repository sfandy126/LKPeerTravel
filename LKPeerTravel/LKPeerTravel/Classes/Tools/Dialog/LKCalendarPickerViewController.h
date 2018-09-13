//
//  LKCalendarPickerViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCalendarPickerViewController : UIViewController

@property (nonatomic, strong) void (^selectCalendarBlock) (NSString *beginTime,NSString *endTime);

@end
