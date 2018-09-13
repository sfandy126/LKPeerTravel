//
//  LKBaseModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@implementation LKBaseModel

+ (id )modelWithDict:(NSDictionary *)dict{
    //子类自己去实现
    return [self new];
}

- (void)calculateLayoutViewFrame{
    //计算控件的布局
}

- (void)requestDataWithParams:(NSDictionary *)params
                      forPath:(NSString *)path
                   httpMethod:(LKRequestMethod)httpMethod
                     finished:(LKFinishedBlock)finished
                       failed:(LKFailedBlock)failed {

    if (httpMethod == LKRequestMethodGET) {
        [LKHttpClient GET:path parameters:params progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            LKResult *result = [[LKResult alloc] initWithDict:responseObject];
            result.response = (NSHTTPURLResponse *)task.response;
            finished(self,result);

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failed(self,error);
        }];
     
        
    }else if(httpMethod == LKRequestMethodPOST) {
        [LKHttpClient POST:path parameters:params progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            LKResult *result = [[LKResult alloc] initWithDict:responseObject];
            result.response = (NSHTTPURLResponse *)task.response;
            finished(self,result);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failed(self,error);
        }];
    }
}



@end

@implementation LKResult

- (id)initWithDict:(NSDictionary*)dict
{
    self = [self init];
    if (self) {
        
        if (![dict isKindOfClass:[NSDictionary class]]) {
            dict = @{};
        }
//        _success = [[dict objectForKey:@"ret"] intValue] == 0;
//        _data    = [dict objectForKey:@"data"];
//        if ([_data isKindOfClass:[NSArray class]]) {
//            if (((NSArray*)_data).count == 0) {
//                _data = @[];
//            }
//        }else if([_data isKindOfClass:[NSDictionary class]]) {
//            if(((NSDictionary*)_data).count==0){
//                _data = @{};
//            }
//        }else if([_data isKindOfClass:[NSString class]]){
//            if(((NSString*)_data).length==0){
//                _data = @"";
//            }
//        }
        
        NSDictionary *transactionStatus = dict[@"transactionStatus"];
        _errorCode = transactionStatus[@"errorCode"];
        _replyCode = transactionStatus[@"replyCode"];
        _replyText = transactionStatus[@"replyText"];
        
        _success = [transactionStatus[@"success"] boolValue];
        
        _data = [NSDictionary getDictonary:dict];
        
//        _code    = [[NSString stringValue:[dict objectForKey:@"ret"]] intValue];
//        _message = [NSString stringValue:[dict objectForKey:@"msg"]];
//        _timestamp = [NSString stringValue:[dict objectForKey:@"timestamp"]];
    }
    return self;
    
}

@end
