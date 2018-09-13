//
//  LKSelectCityModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSelectCityModel.h"

@implementation LKSelectCityModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 屏蔽测试数据
        /*
        NSArray *citys = @[@{@"title":@"深圳",@"tag_id":@"1"},
                           @{@"title":@"巴厘岛",@"tag_id":@"2"},
                           @{@"title":@"赤道几内亚",@"tag_id":@"3"},
                           @{@"title":@"温哥华",@"tag_id":@"4"},
                           @{@"title":@"北京",@"tag_id":@"5"},
                           @{@"title":@"拉斯维加斯",@"tag_id":@"6"},
                           @{@"title":@"洪都拉斯",@"tag_id":@"7"},
                           @{@"title":@"马达加斯加",@"tag_id":@"8"},
                           @{@"title":@"拉萨",@"tag_id":@"9"},
                           @{@"title":@"哥斯达黎加",@"tag_id":@"10"},
                           @{@"title":@"迪拜",@"tag_id":@"11"}];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in citys) {
            LKCityTagModel *item = [LKCityTagModel modelWithDict:dict];
            [temp addObject:item];
        }
        self.tags = [NSArray getArray:[temp copy]];
        
        
        {
            NSArray *citys = @[@{@"title":@"深圳",@"tag_id":@"1"},
                               @{@"title":@"巴厘岛",@"tag_id":@"2"},
                               @{@"title":@"赤道几内亚",@"tag_id":@"3"},
                               @{@"title":@"温哥华",@"tag_id":@"4"},
                               @{@"title":@"北京",@"tag_id":@"5"},
                               @{@"title":@"拉斯维加斯",@"tag_id":@"6"},
                               @{@"title":@"洪都拉斯",@"tag_id":@"7"},
                               @{@"title":@"马达加斯加",@"tag_id":@"8"},
                               @{@"title":@"拉萨",@"tag_id":@"9"},
                               @{@"title":@"哥斯达黎加",@"tag_id":@"10"},
                               @{@"title":@"迪拜",@"tag_id":@"11"}];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in citys) {
                LKCityTagModel *item = [LKCityTagModel modelWithDict:dict];
                [temp addObject:item];
            }
            self.searchResult = [NSArray getArray:[temp copy]];
        }
         */
    }
    return self;
}

@end

@implementation LKCityTagModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKCityTagModel *item = [LKCityTagModel new];
        item.tag_id = [NSString stringValue:[dict valueForKey:@"tag_id"]];
        item.title = [NSString stringValue:[dict valueForKey:@"title"]];
        return item;
    }
    return nil;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"tag_id":@"cityNo",@"title":@"cityName"};
}

@end
