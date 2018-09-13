//
//  LKCalendarPickerView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FSCalendar.h>


@interface LKCalendarPickerView : UIView

@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) NSArray <NSDate *>*dateSets;
@property(nonatomic,copy)NSDate *BeginDate;

@property(nonatomic,copy)NSDate *EndDate;

@property (nonatomic, copy) void (^selectedCalendarBlock) (NSInteger days);

@end
