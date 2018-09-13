//
//  LKTrackDetailMainView.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTrackDetailServer.h"


@interface LKTrackDetailMainView : UIView

@property (nonatomic,weak) LKTrackDetailServer *server;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) LKBaseViewController *vc;

@property (nonatomic,strong) void (^addCommentBlock)(NSString *inputComment);

- (void)doneLoading;


@end
