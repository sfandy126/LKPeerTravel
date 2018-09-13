//
//  LKWishEditRowModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,LKWishEditRowType) {
    LKWishEditRowType_destination = 1, //目的地
    LKWishEditRowType_time, // 出行时间
    LKWishEditRowType_language, // 语言
    LKWishEditRowType_people, //出行人数
    LKWishEditRowType_money, // 预算
};

@interface LKWishEditRowModel : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *city_id;
@property (nonatomic,strong) NSString *title_desc;
@property (nonatomic,assign) BOOL showArrow;
@property (nonatomic,assign) BOOL showSwitch;
@property (nonatomic,assign) LKWishEditRowType rowType;

@property (nonatomic,assign) BOOL switchState;

+ (instancetype)modelWithTitle:(NSString *)title desc:(NSString *)desc showArrow:(BOOL)showArrow showSwitch:(BOOL)showSwitch;

@end


