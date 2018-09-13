//
//  UIAlertView+LKBlock.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIAlertView+LKBlock.h"
#import <objc/runtime.h>

static NSString *kHandlerAssociatedKey = @"kHandlerAssociatedKey";

@implementation UIAlertView (LKBlock)

- (void)showWithHandler:(UIAlertViewHandler)handler {
    
    objc_setAssociatedObject(self, (__bridge const void *)(kHandlerAssociatedKey), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setDelegate:self];
    [self show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    UIAlertViewHandler completionHandler = objc_getAssociatedObject(self, (__bridge const void *)(kHandlerAssociatedKey));
    
    if (completionHandler != nil) {
        
        completionHandler(alertView, buttonIndex);
    }
}

#pragma mark - - Public Method

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
              handler:(UIAlertViewHandler)handler {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert showWithHandler:handler];
}

+ (void)showErrorWithMessage:(NSString *)message
                     handler:(UIAlertViewHandler)handler {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert showWithHandler:handler];
}


+ (void)showWarningWithMessage:(NSString *)message
                       handler:(UIAlertViewHandler)handler {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert showWithHandler:handler];
}

+ (void)showButtonWithTitles:(NSString *)title
                     message:(NSString *)message
                buttonTitles:(NSArray*)titles
                     handler:(UIAlertViewHandler)handler {
    
    NSString *firstObject = [titles firstObject];
    if (!firstObject || ![firstObject isKindOfClass:[NSString class]]) {
        firstObject = @"";
    }
    
    NSString *lastObject = [titles lastObject];
    if (!lastObject || ![lastObject isKindOfClass:[NSString class]]) {
        lastObject = @"";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:firstObject,lastObject, nil];
    
    [alert showWithHandler:handler];
    
}



@end
