//
//  LKMyServerModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerModel.h"

@implementation LKMyServerModel

///获取我的服务接口
- (void)obtainMyServerData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/CosSrvice/get" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadMyServerData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadMyServerData:(NSDictionary *)dict{
    dict = [NSDictionary getDictonary:dict];
    NSDictionary *data = [NSDictionary getDictonary:[dict valueForKey:@"data"]];
    
    NSMutableArray *temp = [NSMutableArray array];
    
    //基本信息
    self.serviceNo = [NSString stringValue:[data valueForKey:@"serviceNo"]];
    self.dateSets = [NSArray getArray:[data valueForKey:@"dateSets"]];
    self.flagCar = [[NSString stringValue:[data valueForKey:@"flagCar"]] boolValue];
    self.flagPlane = [[NSString stringValue:[data valueForKey:@"flagPlane"]] boolValue];
    self.pmax = [NSString stringValue:[data valueForKey:@"pmax"]];
    self.point = [NSString stringValue:[data valueForKey:@"point"]];
    self.discounts = [NSArray getArray:[data valueForKey:@"discounts"]];

    [temp addObject:@(LKMyServerType_Info)];
    
    //景点
    NSArray *attractions = [NSArray getArray:[data valueForKey:@"attractions"]];
    {
        NSDictionary *dic = @{@"type":@(LKMyServerType_scene),@"title":@"景点",@"citys":attractions};
        LKMyServerTypeModel *item = [LKMyServerTypeModel modelWithDict:dic];
        [temp addObject:item];
    }
    
    //美食
    NSArray *foods = [NSArray getArray:[data valueForKey:@"foods"]];
    {
        NSDictionary *dic = @{@"type":@(LKMyServerType_cate),@"title":@"美食",@"citys":foods};
        LKMyServerTypeModel *item = [LKMyServerTypeModel modelWithDict:dic];
        [temp addObject:item];
    }
    
    //购物
    NSArray *shopps = [NSArray getArray:[data valueForKey:@"shopps"]];
    {
        NSDictionary *dic = @{@"type":@(LKMyServerType_shop),@"title":@"购物",@"citys":shopps};
        LKMyServerTypeModel *item = [LKMyServerTypeModel modelWithDict:dic];
        [temp addObject:item];
    }
    
    ///行程安排
    [temp addObject:@(LKMyServerType_date)];
    
    self.cellDatas = [NSArray getArray:[temp copy]];
}


///保存我的服务接口
- (void)saveMyServerData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/CosSrvice/save" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadMyServerData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

@end



@implementation LKMyServerTypeModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKMyServerTypeModel *item = [LKMyServerTypeModel new];
        item.type = [[NSString stringValue:[dict valueForKey:@"type"]] integerValue];
        item.title = [NSString stringValue:[dict valueForKey:@"title"]];

        NSMutableArray *temp = [NSMutableArray array];
        NSArray *arr = [NSArray getArray:[dict valueForKey:@"citys"]];
        for (NSDictionary *dic in arr) {
            LKMyServerCityModel *model = [LKMyServerCityModel modelWithDict:dic];
            if (model) {
                [temp addObject:model];
            }
        }
        item.citys = [NSArray getArray:[temp copy]];
        
        NSInteger row =(item.citys.count/column) +(item.citys.count%column==0?0:1);
        CGFloat shopHeight = itemHeight*row+itemLineSpacing*row;
        item.itemsHeight = shopHeight;
        
        return item;
    }
    return nil;
}

- (void)refreshItemHeight {
    NSInteger row =(self.citys.count/column) +(self.citys.count%column==0?0:1);
    CGFloat shopHeight = itemHeight*row+itemLineSpacing*row;
    self.itemsHeight = shopHeight;
}

@end

@implementation LKMyServerCityModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKMyServerCityModel *item = [LKMyServerCityModel new];
        item.city_id = [NSString stringValue:[dict valueForKey:@"codDestinationPointNo"]];
        item.city_name = [NSString stringValue:[dict valueForKey:@"codDestinationPointName"]];
        item.city_icon = [NSString stringValue:[dict valueForKey:@"codDestinationPointLogo"]];
        
        item.dict = dict;
        return item;
    }
    return nil;
}

@end

