//
//  LKAnswerSectionView.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAnswerSectionView : UIView

@property (nonatomic,copy) void (^moreButBlock)(BOOL isHot);

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title isHot:(BOOL)isHot;

@end
