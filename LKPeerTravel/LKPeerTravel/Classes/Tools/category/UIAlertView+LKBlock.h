//
//  UIAlertView+LKBlock.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewHandler)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (LKBlock)

- (void)showWithHandler:(UIAlertViewHandler)handler;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
              handler:(UIAlertViewHandler)handler;

+ (void)showErrorWithMessage:(NSString *)message
                     handler:(UIAlertViewHandler)handler;

+ (void)showWarningWithMessage:(NSString *)message
                       handler:(UIAlertViewHandler)handler;

+ (void)showButtonWithTitles:(NSString *)title
                     message:(NSString *)message
                buttonTitles:(NSArray*)titles
                     handler:(UIAlertViewHandler)handler;

@end
