//
//  UIResponder+firstResponder.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (firstResponder)
//使用时只需要对UIResponder类调用该类方法即可获得当前第一响应者
+ (id)lk_currentFirstResponder;
@end
