//
//  LKUserDetailMainView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKServerModel.h"
#import "LKUserDetailModel.h"
#import "LKOrderEditModel.h"

@protocol LKUserDetailMainViewDelegate <NSObject>
@optional
- (void)mainViewDidScroll:(CGPoint)contentOffset;
/// 点击了认证区域
- (void)clickCertifyAtIndex:(NSInteger)index;
/// 点击了景点、美食、商城全部
- (void)clickAllBtnAtPointType:(NSInteger)pointType;
/// 点击了立即预约
- (void)clickImmediateBookingBtn;
@end

@interface LKUserDetailMainView : UIView

@property (nonatomic, weak) id<LKUserDetailMainViewDelegate> delegate;
@property (nonatomic, strong) LKUserDetailModel *model;
@property (nonatomic, strong) LKServerModel *serverModel;
@property (nonatomic, strong) LKOrderEditModel *editModel;

// 选择的景点
@property (nonatomic, strong) NSMutableArray *selectedScenes;

- (void)doneLoading;
- (void)finishAddScenes:(NSArray *)scenes pointType:(NSInteger)pointType;
- (void)obtainEditData;
@end
