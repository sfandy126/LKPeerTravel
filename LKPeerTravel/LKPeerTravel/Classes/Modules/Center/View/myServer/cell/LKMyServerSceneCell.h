//
//  LKMyServerSceneCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKMyServerModel.h"

/**
 *  我的服务 景点、美食、购物cell
 *
 **/

static NSString *kMyServerSceneCellIdentify = @"kMyServerSceneCellIdentify";

@class LKMyServerMainView;

@interface LKMyServerSceneCell : UITableViewCell

@property (nonatomic, copy) void (^deleteItemBlock) (LKMyServerCityModel *itemModel,LKMyServerTypeModel *typeModel);

@property (nonatomic, weak) LKMyServerMainView *mainView;

- (void)configData:(LKMyServerTypeModel *)data  indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(LKMyServerTypeModel *)data indexPath:(NSIndexPath *)indexPath;

@end



