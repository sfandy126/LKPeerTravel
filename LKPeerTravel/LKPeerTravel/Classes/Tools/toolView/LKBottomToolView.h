//
//  LKBottomToolView.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/3.
//  Copyright © 2018年 LK. All rights reserved.
//


/**
 *  底部工具视图
 *
 *
 **/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LKBottomToolViewType) {
    LKBottomToolViewType_back=0,//返回
    LKBottomToolViewType_comment,//评论
    LKBottomToolViewType_share,//分享
};

typedef NS_ENUM(NSInteger,LKBottomToolViewStyle) {
    LKBottomToolViewStyle_black=0,//默认为黑色样式
    LKBottomToolViewStyle_white=1,//白色样式
};



@interface LKBottomToolView : UIView

///样式
@property (nonatomic,assign) LKBottomToolViewStyle style;

///点击事件回调
@property (nonatomic,copy) void (^clickedBlcok)(LKBottomToolViewType type);


@end
