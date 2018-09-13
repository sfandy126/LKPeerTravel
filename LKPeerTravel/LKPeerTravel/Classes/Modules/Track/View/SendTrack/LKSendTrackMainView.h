//
//  LKSendTrackMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSendTrackServer.h"

@interface LKSendTrackMainView : UIView

@property (nonatomic,weak) LKSendTrackServer *server;

@property (nonatomic,weak) LKBaseViewController *vc;

- (void)doneLoading;

- (void)resignTextFieldFirstResponder;

@end
