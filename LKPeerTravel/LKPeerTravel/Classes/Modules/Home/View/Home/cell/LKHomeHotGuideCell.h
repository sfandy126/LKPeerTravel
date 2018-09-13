//
//  LKHomeHotGuideCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  热门导游cell
 *
 *
 **/

#import "LKBaseCell.h"
#import "LKHomeModel.h"

static NSString *kHomeHotGuideCellIdentify = @"kHomeHotGuideCellIdentify";

@interface LKHomeHotGuideCell : LKBaseCell

@end


@interface LKHomeHotGuideSection :UIView

@property (nonatomic,copy) void (^selectedLoctionBlock)(void);
@property (nonatomic,copy) NSString *city_name;

@end


///标签view
@interface LKHomeHotGuideTagView :UIView

- (void)configData:(NSArray *)tags;

@end

///底部view
@interface LKHomeHotGuideBottomView :UIView

- (void)configData:(LKHomeGuideModel*)model;

@end

///星级
@interface LKHomeStarView :UIView

- (void)configData:(NSString *)star;

@end
