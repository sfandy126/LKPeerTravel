//
//  LKSceneListModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKSceneListModel : NSObject

@property (nonatomic, strong) NSString *pointType;//    String    类型,1-景点,2-商场,3-美食
@property (nonatomic, assign) NSInteger codId;//    int    id
@property (nonatomic, strong) NSString *codDestinationPointNo;//    String    编号
@property (nonatomic, strong) NSString *codDestinationPointName;//    String    名称
@property (nonatomic, strong) NSString *codDestinationNo;//    String    城市编码
@property (nonatomic, strong) NSString *txtDestinationPointDesc;//    String    图片说明
@property (nonatomic, strong) NSString *codDestinationPointLogo;//    String    logo
@property (nonatomic, assign) NSInteger codSort;//    int    序号
@property (nonatomic, assign) NSInteger datCreate;//    int    时间
@property (nonatomic, assign) NSInteger footprint;//    int    足迹

/// 选中状态
@property (nonatomic, assign) BOOL selectedState;

@end
