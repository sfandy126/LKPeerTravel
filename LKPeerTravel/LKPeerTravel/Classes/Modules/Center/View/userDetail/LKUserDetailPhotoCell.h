//
//  LKUserDetailPhotoCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKServerModel.h"
#import "LKUserDetailMainView.h"

typedef NS_ENUM(NSInteger,PhotoCellType) {
    PhotoCellType_scene = 1, // 景点
    PhotoCellType_food = 2, // 美食
    PhotoCellType_mall = 3, // 商城
};

static NSString *LKUserDetailPhotoCellReuseIndentifier = @"LKUserDetailPhotoCellReuseIndentifier";


@interface LKUserDetailPhotoCell : UITableViewCell

@property (nonatomic, weak) LKUserDetailMainView *mainView;
@property (nonatomic, assign) PhotoCellType cellType;

@property (nonatomic, strong) LKServerModel *serverModel;

+ (CGFloat)heightWithModel:(LKServerModel *)model;


@end
