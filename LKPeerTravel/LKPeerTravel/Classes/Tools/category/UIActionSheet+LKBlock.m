//
//  UIActionSheet+LKBlock.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "UIActionSheet+LKBlock.h"
#import <objc/runtime.h>

static NSString *kActionSheetHandlerAssociatedKey = @"kActionSheetHandlerAssociatedKey";


@implementation UIActionSheet (LKBlock)

- (void)showWithHandler:(UIActionSheetHandler)handler {
    
    objc_setAssociatedObject(self, (__bridge const void *)(kActionSheetHandlerAssociatedKey), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setDelegate:self];
    [self showInView:[UIApplication sharedApplication].delegate.window];
}

#pragma mark - - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIActionSheetHandler completionHandler = objc_getAssociatedObject(self, (__bridge const void *)(kActionSheetHandlerAssociatedKey));
    
    if (completionHandler != nil) {
        
        completionHandler(actionSheet, buttonIndex);
    }
}

+ (void)showButtonsWithTitle:(NSString *)title buttons:(NSArray <NSString *>*)butTitles handler:(UIActionSheetHandler )handler{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[butTitles objectAt:0],[butTitles objectAt:1],[butTitles objectAt:2],[butTitles objectAt:3], nil];
    [sheet showWithHandler:handler];
}

@end
