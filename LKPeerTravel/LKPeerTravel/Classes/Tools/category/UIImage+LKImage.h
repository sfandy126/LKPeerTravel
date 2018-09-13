//
//  UIImage+LKImage.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/29.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LKImage)

/// 绘制指定高度和颜色的图片
+ (UIImage*) imageWithColor:(UIColor*)color andHeight:(CGSize )size;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
