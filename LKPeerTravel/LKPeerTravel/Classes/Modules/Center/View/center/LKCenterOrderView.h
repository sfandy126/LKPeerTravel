//
//  LKCenterOrderView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKCenterOrderView : UIView
@property (nonatomic,copy) void (^selectedBlock)(NSInteger index);
@end

@interface LKCenterOrderBtn : UIButton

@end
