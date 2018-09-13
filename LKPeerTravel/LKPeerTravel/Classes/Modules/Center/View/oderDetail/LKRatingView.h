//
//  LKRatingView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/5.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKRatingView : UIView

@property (nonatomic,assign) NSInteger starNumber;
/*
 *调整底部视图的颜色
 */
@property (nonatomic,strong) UIColor *viewColor;

/*
 *是否允许可触摸
 */
@property (nonatomic,assign) BOOL enable;

/// 图片状态下的星星
@property (nonatomic, strong) NSString *normalStarImageName;
/// 选择状态下的星星
@property (nonatomic, strong) NSString *lightStarImagename;
/// 更新了评分
@property (nonatomic, strong) void (^updateRatingBlock) (void);

@property (nonatomic,assign) NSInteger star;

@end
