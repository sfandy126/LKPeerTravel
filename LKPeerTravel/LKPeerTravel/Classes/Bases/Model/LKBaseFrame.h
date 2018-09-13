//
//  LKBaseFrame.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  布局相关的模型
 *
 *
 **/

#import <Foundation/Foundation.h>

@interface LKBaseFrame : NSObject

///控件的顶部间距
@property (nonatomic,assign) CGFloat topInval;
///控件的底部间距(不建议设置底部间隙)
@property (nonatomic,assign) CGFloat bottomInval;
///控件的宽度
@property (nonatomic,assign) CGFloat width;
///控件的高度
@property (nonatomic,assign) CGFloat height;
///控件的左侧间距
@property (nonatomic,assign) CGFloat leftInval;
///控件的右侧间距
@property (nonatomic,assign) CGFloat rightInval;
///控件的字体大小
@property (nonatomic,strong) UIFont *font;
///控件的行间距
@property (nonatomic,assign) CGFloat lineSpace;
///当前控件展示的行数
@property (nonatomic,assign) NSInteger rowCount;


@end
