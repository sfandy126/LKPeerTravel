//
//  LKEditSceneModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKEditSceneModel : NSObject
@property (nonatomic, strong) NSString *pointType;//    String    类型,1-景点,2-商场,3-美食
@property (nonatomic, assign) NSInteger codId;//    int    id
@property (nonatomic, strong) NSString *codDestinationPointNo;//    String    编号
@property (nonatomic, strong) NSString *codDestinationPointName;//    String    名称
@property (nonatomic, strong) NSString *codDestinationNo;//    String    城市编码
@property (nonatomic, strong) NSString *cityName;//    String    城市名称
@property (nonatomic, strong) NSString *flagOpen;//    String    开放城市标志,1-是;0-否
@property (nonatomic, assign) NSInteger datCreate;//    int    时间
@property (nonatomic, assign) NSInteger footprint;//    int    足迹
@property (nonatomic, strong) NSArray *images;//    [{}]    图片信息
/*
codDestinationImageNo    String    图片编号
txtImageDesc    String    图片说明
codImageUrl    String    图片链接
imgHeight    String    图片高度
imgWidth    String    图片宽度
 */
@end
