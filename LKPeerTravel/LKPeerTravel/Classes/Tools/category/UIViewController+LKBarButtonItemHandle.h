//
//  UIViewController+LKBarButtonItemHandle.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LKBarButtonItemHandle)

///设置返回按钮
- (void)setBackBtn;

///返回按钮事件
- (void)back;


//设置左侧按钮
- (UIButton *)setLeftButtonWithImageName:(NSString *)imageName
                   hightlightedImageName:(NSString *)hightlightedImageName
                                   title:(NSString *)title;

//设置右侧按钮
- (void)setRightNavigationItems:(NSArray<NSString *>*)rightItemIcons action:(SEL)selOne action:(SEL)selTwo;

@end
