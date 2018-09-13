//
//  LKOrderMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKOrderServer.h"

@protocol LKOrderMainViewDelegate <NSObject>

/// 状态更新完成
@optional
- (void)stateOperationFinished;

@end

@interface LKOrderMainView : UIView
@property (nonatomic,weak) LKOrderServer *server;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,copy) void (^switchSegmentBlock)(NSInteger index);
@property (nonatomic, weak) id<LKOrderMainViewDelegate>delegate;
- (void)doneLoading;

@end
