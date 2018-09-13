//
//  LKMyServerMainView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKMyServerServer.h"

#import "LKEditServerModel.h"


@protocol LKMyServerMainViewDelegate <NSObject>

@optional
/// 点击了添加景点、美食、购物
- (void)mainViewDidClickAdd:(NSInteger)addType;

@end

@interface LKMyServerMainView : UIView
@property (nonatomic,weak) LKMyServerServer *server;
@property (nonatomic, weak) id<LKMyServerMainViewDelegate>delegate;

/// 保存服务编辑的模型 用户上传数据
@property (nonatomic,strong) LKEditServerModel *editModel;

- (void)doneLoading;

/// 完成编辑 获取数据
- (void)complishEdit;

- (void)editSceneFinishedType:(NSInteger)editType data:(NSDictionary *)data;

@end
