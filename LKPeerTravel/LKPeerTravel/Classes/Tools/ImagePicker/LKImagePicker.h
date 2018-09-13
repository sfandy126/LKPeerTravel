//
//  LKImagePicker.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^imageBlock)(UIImage *image);


@interface LKImagePicker : NSObject

/// 获取图片
+ (void)getPictureWithBlock:(imageBlock)block;
/// 获取图片
+ (void)getPictureWithController:(UIViewController *)controller block:(imageBlock)block;
/// 拍摄图片
+ (void)getCameraWithBlock:(imageBlock)block;
/// 拍摄图片
+ (void)getCameraWithController:(UIViewController *)controller block:(imageBlock)block;

@end
