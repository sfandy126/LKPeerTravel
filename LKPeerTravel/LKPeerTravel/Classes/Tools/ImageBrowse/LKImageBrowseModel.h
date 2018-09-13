//
//  LKImageBrowseModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@interface LKImageBrowseModel : LKBaseModel
@property (nonatomic,copy) NSArray *list;
///当前展示的下标
@property (nonatomic,assign) NSInteger curIndex;

@property (nonatomic,copy) NSString *footprintNo;///足迹id

- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;


@end


@interface LKImageBrowseSingleModel : LKBaseModel
@property (nonatomic,copy) NSString *footprintNo;///足迹id

@property (nonatomic,copy) NSString *imageNo;///图片Id
@property (nonatomic,copy) NSString *imageUrl;///图片Url
@property (nonatomic,copy) NSString *jumpUrl;///跳转url
@property (nonatomic,copy) NSString *imageDesc;///图片描述
@property (nonatomic,copy) NSString *flagCover;///是否为主图 y/n
@property (nonatomic,copy) NSString *content;///足迹描述

@end
