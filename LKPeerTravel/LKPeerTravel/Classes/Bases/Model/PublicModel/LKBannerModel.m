//
//  LKBannerModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBannerModel.h"

@implementation LKBannerModel

@end

@implementation LKBannerPicModel

+ (LKBannerPicModel *)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKBannerPicModel *model = [LKBannerPicModel new];
        model.bannerNo = [NSString stringValue:[dict valueForKey:@"bannerNo"]];
        model.bannerUrl = [NSString stringValue:[dict valueForKey:@"bannerUrl"]];
        model.jumpUrl = [NSString stringValue:[dict valueForKey:@"jumpUrl"]];
        model.status = [NSString stringValue:[dict valueForKey:@"status"]];
        model.txtBanner = [NSString stringValue:[dict valueForKey:@"txtBanner"]];
        return model;
    }
    return nil;
}

@end

