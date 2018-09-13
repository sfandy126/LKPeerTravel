//
//  LKBannerModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@interface LKBannerModel : LKBaseModel

@end


@interface LKBannerPicModel : LKBaseModel

@property (nonatomic,copy) NSString *bannerNo;
@property (nonatomic,copy) NSString *bannerUrl;
@property (nonatomic,copy) NSString *jumpUrl;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *txtBanner;

@end
