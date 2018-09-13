//
//  LKPageInfo.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKPageInfo : NSObject

@property (nonatomic,assign) NSInteger limit;//": 0,
@property (nonatomic,assign) NSInteger returnCount;//": true,
@property (nonatomic,strong) NSString *orderBy;//": "",
@property (nonatomic,assign) NSInteger count;//": 0,
@property (nonatomic,assign) NSInteger pageSize;//": 10,
@property (nonatomic,assign) NSInteger offset;//": 1,
@property (nonatomic,assign) NSInteger pageNum;//": 1

@end
