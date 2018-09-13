//
//  LKSelectCityModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKCityTagModel;
@interface LKSelectCityModel : LKBaseModel
@property (nonatomic,strong) NSArray <LKCityTagModel *>*tags;
@property (nonatomic,strong) NSArray <LKCityTagModel *>*searchResult;


@end

@interface LKCityTagModel : LKBaseModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *tag_id;
@property (nonatomic,assign) BOOL isSelected;

// 城市描述
@property (nonatomic,copy) NSString *cityDesc;
// 城市别名
@property (nonatomic,copy) NSString *cityNm;

@end
