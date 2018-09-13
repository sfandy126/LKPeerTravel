//
//  LKGuideListViewController.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/1.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  城市中的导游列表
 *
 *
 **/

#import "LKBaseViewController.h"

@interface LKGuideListViewController : LKBaseViewController

///根据城市编号获取导游列表
@property (nonatomic,copy) NSString *cityNo;

@property (nonatomic,copy) NSString *cityName;


@end
