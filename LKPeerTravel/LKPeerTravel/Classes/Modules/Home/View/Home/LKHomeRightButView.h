//
//  LKHomeRightButView.h
//  LKPeerTravel
//
//  Created by LK on 2018/8/5.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKHomeRightButView : UIView

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) CGSize imageSize;

@property (nonatomic,assign) CGFloat inval;

@property (nonatomic,copy) void (^selectedBlock)(void);


@end
