//
//  UIActionSheet+LKBlock.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionSheetHandler)(UIActionSheet *actionSheet, NSInteger buttonIndex);

@interface UIActionSheet (LKBlock)

- (void)showWithHandler:(UIActionSheetHandler)handler;

+ (void)showButtonsWithTitle:(NSString *)title buttons:(NSArray <NSString *>*)butTitles handler:(UIActionSheetHandler )handler;


@end
