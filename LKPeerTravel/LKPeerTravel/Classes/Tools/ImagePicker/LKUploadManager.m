//
//  LKUploadManager.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUploadManager.h"

#define kDocumentsPath        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"LKImages"]

@implementation LKUploadManager

+ (void)uploadImage:(UIImage *)image completeBlock:(void (^)(id ret,NSError *error)) completeBlock {
    
    [LKUtils LKScaleImage:image completed:^(UIImage *scaledImage, UIImage *thumbnail, CGFloat quality) {
        if (scaledImage) {
            [LKHttpClient POST:@"tx/cif/CosDestinationPoint/upload" parameters:@{@"file":scaledImage,@"imgWidth":[NSString stringWithFormat:@"%.0f",scaledImage.size.width],@"imgHeight":[NSString stringWithFormat:@"%.0f",scaledImage.size.height]} progress:^(NSProgress *progress) {
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                LKResult *result = [[LKResult alloc]initWithDict:responseObject];
                if (completeBlock) {
                    completeBlock(result,nil);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (completeBlock) {
                    completeBlock(nil,error);
                }
            }];
        }
    }];
    
  
}

+ (void)uploadData:(NSData *)data completeBlock:(void (^)(id ret,NSError *error)) completeBlock {
    if (data) {
        [LKHttpClient POST:@"tx/cif/CosDestinationPoint/upload" parameters:@{@"file":data} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            LKResult *result = [[LKResult alloc]initWithDict:responseObject];
            if (completeBlock) {
                completeBlock(result,nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (completeBlock) {
                completeBlock(nil,error);
            }
        }];
    }
}

@end
