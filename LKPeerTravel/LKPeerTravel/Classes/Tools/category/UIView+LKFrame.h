//
//  UIView+LKFrame.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LKFrame)

@property(nonatomic,assign) CGFloat top;
@property(nonatomic,assign) CGFloat left;
@property(nonatomic,assign) CGFloat bottom;
@property(nonatomic,assign) CGFloat right;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,assign,readonly) CGFloat screenX;
@property(nonatomic,assign,readonly) CGFloat screenY;
@property(nonatomic,assign,readonly) CGFloat screenViewX;
@property(nonatomic,assign,readonly) CGFloat screenViewY;
@property(nonatomic,assign,readonly) CGRect screenFrame;

@property (nonatomic,assign) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic,assign) CGSize  size;        ///< Shortcut for frame.size.

@end
