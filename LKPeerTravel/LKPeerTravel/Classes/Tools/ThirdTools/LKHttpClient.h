//
//  LKHttpClient.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger,LKRequestMethod) {
    LKRequestMethodGET = 100,
    LKRequestMethodPOST =101,
};

@interface LKHttpClient : AFHTTPSessionManager

+ (LKHttpClient *)shareClient;

+ (void )POST:(NSString *)cmd
   parameters:(id)parameters
     progress:(void (^)(NSProgress *progress))uploadProgress
      success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

+(void)GET:(NSString *)cmd
    parameters:(id)parameters
  progress:(void (^)(NSProgress *progress))downloadProgress
   success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
   failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

@end
