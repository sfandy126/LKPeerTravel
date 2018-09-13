//
//  LKSceneListCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/27.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKSceneListModel.h"

@interface LKSceneListCell : UITableViewCell

@property (nonatomic, strong) LKSceneListModel *model;
@property (nonatomic, copy) void (^selectSceneBlock)(LKSceneListModel *listModel);

@end
