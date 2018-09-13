//
//  LKThirdLoginView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKThirdLoginView : UIView

@property (nonatomic,copy) void (^selectedLoginBlock)(LKLoginType selectedType);

@end
