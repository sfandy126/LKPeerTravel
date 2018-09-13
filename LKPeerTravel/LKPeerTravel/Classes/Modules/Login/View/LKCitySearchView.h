//
//  LKCitySearchView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSelectCityModel.h"

@interface LKCitySearchView : UIView
@property (nonatomic,copy) void (^selectedBlock)(LKCityTagModel *item);

- (void)configData:(NSArray *)data;

@end

@interface LKCitySearchCell : LKBaseCell

@end
