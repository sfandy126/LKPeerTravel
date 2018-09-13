//
//  LKAnswerMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKAnswerServer.h"

@interface LKAnswerMainView : UIView

@property (nonatomic,weak) LKAnswerServer *server;

@property (nonatomic,strong) UITableView *tableview;

- (void)doneLoading;

@end
