//
//  LKCodeMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCodeMainView : UIView

@property (nonatomic,copy) void (^sureBlock)(NSString *code);
@property (nonatomic,copy) void (^skipBlock)(void);

@end



