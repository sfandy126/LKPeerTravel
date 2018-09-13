//
//  LKSceneDetailModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSceneDetailModel.h"

@implementation LKSceneDetailPicModel

@end


@implementation LKSceneDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"images":[LKSceneDetailPicModel class]};
}
@end
