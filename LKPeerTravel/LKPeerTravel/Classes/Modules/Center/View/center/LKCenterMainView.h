//
//  LKCenterMainView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKCenterServer.h"

@protocol LKCenterMainViewDelegate <NSObject>

- (void)mainViewScrollContentOffsetY:(CGFloat)offsetY;

@end

@interface LKCenterMainView : UIView

@property (nonatomic,weak) LKCenterServer *server;
@property (nonatomic, strong) LKCenterModel *model;
@property (nonatomic, assign) id<LKCenterMainViewDelegate> delegate;

- (void)doneLoading;

@end
