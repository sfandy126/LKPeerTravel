//
//  LKOrderDetailMainView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKOrderDetailServer.h"

typedef NS_ENUM(NSInteger,DetailOperationType) {
    DetailOperationType_cancel = 1,
    DetailOperationType_pay,
    DetailOperationType_kefu,
    DetailOperationType_rebook,
    DetailOperationType_sure,
    DetailOperationType_service,
    DetailOperationType_comment,
    DetailOperationType_reply,
    DetailOperationType_complete
};

@protocol LKOrderDetailMainViewDelegate <NSObject>
@optional
- (void)stateOperationWithType:(DetailOperationType)type;
- (void)guideReplyWithInputStr:(NSString *)inputStr level:(NSInteger)level;
@end

@interface LKOrderDetailMainView : UIView
@property (nonatomic,weak) LKOrderDetailServer *server;
@property (nonatomic, weak) id<LKOrderDetailMainViewDelegate>delegate;

- (void)doneLoading;

@end
