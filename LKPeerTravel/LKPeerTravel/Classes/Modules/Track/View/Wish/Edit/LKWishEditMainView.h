//
//  LKWishEditMainView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKWishMainModel.h"

#import "LKWishEditModel.h"

@interface LKWishEditMainView : UIView

@property (nonatomic, strong) LKWishListModel *model;
/// 是否重新编辑
@property (nonatomic, assign) BOOL isReEdit;

@property (nonatomic, strong) LKWishEditModel *editModel;

/// 已选择的心愿标签
@property (nonatomic, strong) NSMutableArray *selectedWishLabels;

@end
