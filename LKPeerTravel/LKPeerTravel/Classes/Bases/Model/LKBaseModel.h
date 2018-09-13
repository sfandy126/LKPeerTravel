//
//  LKBaseModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKHttpClient.h"

@class LKResult;
@class LKBaseModel;

///model层回调
typedef void (^LKFinishedBlock) (LKBaseModel *item, LKResult *response);
typedef void (^LKFailedBlock)   (LKBaseModel *item, NSError *error);
typedef void (^LKProgress)      (float progress);

///server层回调
typedef void(^LKServerFinishedBlock)(LKResult *item, BOOL isFinished);
typedef void(^LKServerFailedBlock)(NSError *error);

@interface LKBaseModel : NSObject

+ (id )modelWithDict:(NSDictionary *)dict;

///计算控件的布局
- (void)calculateLayoutViewFrame;

- (void)requestDataWithParams:(NSDictionary *)params
                      forPath:(NSString *)path
                   httpMethod:(LKRequestMethod)httpMethod
                     finished:(LKFinishedBlock)finished
                       failed:(LKFailedBlock)failed;

@end


@interface LKResult : NSObject

@property (nonatomic) BOOL success;
@property (nonatomic, copy) id data;
//@property (nonatomic) int code;
//@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *timestamp;

////状态码，如果非零表示失败，0表示成功
@property (nonatomic, copy) NSString *errorCode;
///如果状态码非零，这个字段有值
@property (nonatomic, copy) NSString *replyCode;
///如果状态码非零，这个字段有值，具体错误消息
@property (nonatomic, copy) NSString *replyText;


//响应后的头数据
@property (nonatomic, strong) NSHTTPURLResponse *response;

- (id)initWithDict:(NSDictionary*)dict;

@end
