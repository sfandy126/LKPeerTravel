//
//  LKStateMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKStateMainView : UIView

@property (nonatomic,copy) void (^nextBlock)(LKUserType userType);

@end


@interface LKStateButView: UIView
@property (nonatomic,assign) LKUserType userType;
@property (nonatomic,assign) BOOL isSelected;

@end
