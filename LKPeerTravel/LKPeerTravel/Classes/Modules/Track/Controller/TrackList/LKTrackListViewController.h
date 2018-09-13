//
//  LKTrackListViewController.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  足迹列表
 *
 *
 **/

#import "LKBaseViewController.h"

@interface LKTrackListViewController : LKBaseViewController

///如传城市编号，则为该城市的足迹列表
@property (nonatomic,copy) NSString *cityNo;

///如传用户编号，则为该用户的游记列表,如都不传，则为当前用户的足迹列表
@property (nonatomic,copy) NSString *customerNumber;

@end
