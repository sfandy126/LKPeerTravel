//
//  LKUploadManager.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKUploadManager : NSObject

+ (void)uploadImage:(UIImage *)image completeBlock:(void (^)(id ret,NSError *error)) completeBlock;

+ (void)uploadData:(NSData *)data completeBlock:(void (^)(id ret,NSError *error)) completeBlock;


@end
