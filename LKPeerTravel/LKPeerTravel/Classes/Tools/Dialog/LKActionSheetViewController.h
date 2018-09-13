//
//  LKActionSheetViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKActionSheetViewController;

@protocol LKActionSheetViewControllerDelegate <NSObject>

@required
- (void)actionSheetController:(LKActionSheetViewController *)actionSheetController didClickIndex:(NSInteger)index;

@end

@interface LKActionSheetViewController : UIViewController

@property (nonatomic, weak) id<LKActionSheetViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
- (instancetype)initWithItems:(NSArray<NSString *> *)items delegate:(id<LKActionSheetViewControllerDelegate>)delegate;
- (instancetype)initWithItems:(NSArray<NSString *> *)items title:(NSString *)title delegate:(id<LKActionSheetViewControllerDelegate>)delegate;

@end
