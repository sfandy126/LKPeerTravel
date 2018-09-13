//
//  LKHttpClient.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHttpClient.h"
#import "OpenUDID.h"
#import "NSString+YYAdd.h"

#define kTimeOut 10

@implementation LKHttpClient

+ (LKHttpClient *)shareClient{
    static LKHttpClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl = [NSURL URLWithString:kBaseURL];
        instance = [[LKHttpClient alloc] initWithBaseURL:baseUrl];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"image/jpeg",@"image/png", @"application/octet-stream",@"text/json", nil];
       
        [instance setResponseSerializer:responseSerializer];
        
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.requestSerializer.timeoutInterval = kTimeOut;
        [instance.requestSerializer setValue:baseUrl.host forHTTPHeaderField:@"host"];

    });
    return instance;
}

+ (void )POST:(NSString *)cmd
   parameters:(id)parameters
     progress:(void (^)(NSProgress *progress))uploadProgress
      success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
      failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{

    LKHttpClient *httpClient =  [LKHttpClient shareClient];
    
    id upKey;
    BOOL isUploadfile = NO;
    for (id onekey in parameters) {
        if ([onekey isEqualToString:@"file"]) {
            httpClient.requestSerializer.timeoutInterval = 30;
            isUploadfile = YES;
            upKey = onekey;
        }
    }
    
    NSMutableDictionary *mparams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    id uploadObject;
    if (upKey) {
        uploadObject = [parameters valueForKey:upKey];
        [mparams setValue:nil forKey:upKey];
    }
    
    NSDictionary *params = [LKHttpClient makeParams:mparams cmd:cmd httpMethod:LKRequestMethodPOST];
    NSString *json = [params modelToJSONString];
    
    if (isUploadfile) {
        [httpClient POST:cmd parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            id value = uploadObject;
            if ([value isKindOfClass:[NSString class]]) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:value] name:upKey error:nil];
            } else if ([value isKindOfClass:[UIImage class]]) {
                UIImage *image = (UIImage *)value;
                NSDate *now = [NSDate date];
                int i = rand() % 10000;
                if (image) {
                    NSString *uniqueName = [NSString stringWithFormat:@"%@_%d.jpg",[LKUtils dateToString:now withDateFormat:@"yyyyMMddHHmmss"],i];
                    NSData *data = UIImageJPEGRepresentation(image, 0.9);
                    [formData appendPartWithFileData:data name:upKey fileName:uniqueName mimeType:@"image/png"];
                }
            } else if ([value isKindOfClass:[NSData class]]) {
                NSData *data = value;
                NSString *is_gif = [params valueForKey:@"is_gif"];
                if (data && data.length > 0) {
                    NSDate *now = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMddHHmmss"];
                    int i = rand() % 10000;
                    if (!is_gif) {
                        NSString *uniqueName = [NSString stringWithFormat:@"%@_%d.jpg",[LKUtils dateToString:now withDateFormat:@"yyyyMMddHHmmss"],i];
                        [formData appendPartWithFileData:data name:upKey fileName:uniqueName mimeType:@"image/jpeg"];
                    }else {
                        NSString *uniqueName = [NSString stringWithFormat:@"%@_%d.gif",[formatter stringFromDate:now],i];
                        [formData appendPartWithFileData:data name:upKey fileName:uniqueName mimeType:@"image/gif"];
                    }
                }
            }
        } progress:uploadProgress success:success failure:failure];
    } else {
        [httpClient POST:cmd parameters:params progress:uploadProgress success:success failure:failure];
    }
}


+(void)GET:(NSString *)cmd
parameters:(id)parameters
  progress:(void (^)(NSProgress *progress))downloadProgress
   success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
   failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure{
    
    LKHttpClient *httpClient =  [LKHttpClient shareClient];
    [httpClient GET:cmd parameters:parameters progress:downloadProgress success:success failure:failure];
}

+ (id)makeParams:(NSDictionary *)params cmd:(NSString *)cmd httpMethod:(LKRequestMethod )httpMethod{
    if (!params) {
        params  =@{};
    }
    NSMutableDictionary *newsParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    
    //移除mvc字段,前面自己加的用于识别host
//    [newsParams removeObjectForKey:@"mvc"];
    
    
    //获取版本号
//    NSString *strAppVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    //获取时间戳
    NSDate *now = [NSDate date];
    NSString *timestamp = [NSString stringWithFormat:@"%.f", [now timeIntervalSince1970]];
    
//    NSString *openUdid = [NSString stringValue:[OpenUDID value]];
    
    
    NSMutableDictionary *sessionContext = [NSMutableDictionary dictionary];
    [sessionContext setValue:timestamp forKey:@"localDateTimeText"];
    [sessionContext setValue:[LKUtils md5:timestamp] forKey:@"externalReferenceNo"];
    //如果客户已登陆，则是客户编号，如果未登录则是uuid
    if ([LKUserInfoUtils getUserNumber].length>0) {
        [sessionContext setValue:[LKUserInfoUtils getUserNumber] forKey:@"userReferenceNumber"];
    }else{
        [sessionContext setValue:[LKUtils md5:timestamp] forKey:@"userReferenceNumber"];
    }
    [sessionContext setValue:@"tongxing" forKey:@"userReferenceOrg"];
    [sessionContext setValue:@"1" forKey:@"accessSource"];
    
    [newsParams setObject:sessionContext forKey:@"sessionContext"];
    
//    [newsParams setObject:@"MSG1001" forKey:@"businessType"];
//    [newsParams setObject:@"1" forKey:@"noticeType"];
    
//    if ([LKUserInfoUtils getUserNumber].length>0) {
//        [newsParams setValue:[LKUserInfoUtils getUserNumber] forKey:@"customerNumber"];
//    }
    return newsParams;
}


@end
