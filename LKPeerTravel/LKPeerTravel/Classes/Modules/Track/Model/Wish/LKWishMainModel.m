//
//  LKWishMainModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishMainModel.h"

@implementation LKWishLanguageInfo

@end

@implementation LKWishLabelInfo

@end

@implementation LKWishMainModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"dataList":LKWishListModel.class};
}


@end


@implementation LKWishListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"languageList":LKWishLanguageInfo.class,@"wishLabelList":LKWishLabelInfo.class};
}

@end
