//
//  LKImageBrowseModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKImageBrowseModel.h"

@implementation LKImageBrowseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSDictionary *dic = @{@"id":@"213819",@"pic":@"https://gss0.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/f9dcd100baa1cd114753d728b912c8fcc2ce2dd4.jpg",@"content":@"蒂萨河打火机等哈手机的哈时间的话 iu 会对大数据等哈就开始大回馈"};
//
//        NSMutableArray *temp = [NSMutableArray array];
//        for (int i=0; i<10; i++) {
//            LKImageBrowseSingleModel *item = [LKImageBrowseSingleModel modelWithDict:dic];
//            if (item) {
//                [temp addObject:item];
//            }
//        }
//
//        self.list = [NSArray getArray:[temp copy]];
    }
    return self;
}

- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self requestDataWithParams:params forPath:@"tx/cif/customer/footprintComment/addition" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

@end

@implementation LKImageBrowseSingleModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKImageBrowseSingleModel *model = [LKImageBrowseSingleModel new];

        model.footprintNo = [NSString stringValue:[dict valueForKey:@"footprintNo"]];
        model.imageNo = [NSString stringValue:[dict valueForKey:@"imageNo"]];
        model.imageUrl = [NSString stringValue:[dict valueForKey:@"imageUrl"]];
        model.jumpUrl = [NSString stringValue:[dict valueForKey:@"jumpUrl"]];
        model.imageDesc = [NSString stringValue:[dict valueForKey:@"imageDesc"]];
        model.flagCover = [NSString stringValue:[dict valueForKey:@"flagCover"]];
        model.content = [NSString stringValue:[dict valueForKey:@"content"]];
        return model;
    }
    return nil;
}

@end

