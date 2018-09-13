//
//  LKLoginMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLoginServer.h"

@interface LKLoginMainView : UIView

@property (nonatomic,copy) void (^clickedGetCodeBlock)(NSString *iphone);

// 验证码登录
@property (nonatomic,copy) void (^codeLogin)(NSString *iphone,NSString *code);

//测试用
- (void)settingCode:(NSString *)code;

@end
