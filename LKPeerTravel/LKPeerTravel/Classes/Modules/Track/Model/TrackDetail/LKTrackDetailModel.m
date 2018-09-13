//
//  LKTrackDetailModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackDetailModel.h"

@interface LKTrackDetailModel ()
@property (nonatomic,strong) NSMutableArray *tempDatalist;
@end


@implementation LKTrackDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempDatalist = [NSMutableArray array];
        //测试数据
//        NSArray *arr = @[@{@"key":@"1",@"comments":@[@{@"key":@"1"},@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"},@{@"key":@"1"},@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"},@{@"key":@"1"},@{@"key":@"1"},@{@"key":@"1"}]}];
//        for (NSDictionary *dic in arr) {
//            LKTrackCommentModel *item = [LKTrackCommentModel modelWithDict:dic];
//            [self.tempDatalist addObject:item];
//        }
    }
    return self;
}

- (NSArray *)comments{
    return [NSArray getArray:[self.tempDatalist copy]];
}


- (void)reportedTrackDetailWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self requestDataWithParams:params forPath:@"tx/cif/buss/add/count" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadTrackInfoDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/customer/footprint/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadTrackInfoData:response.data];
        }
        finishedBlock(response,response.success);
        
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self requestDataWithParams:params forPath:@"tx/cif/customer/footprintComment/addition" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadCommentsWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/customer/footprintComment/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadCommentData:response.data];
        }
        finishedBlock(response,response.success);
        
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadTrackInfoData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSDictionary *infoDic = [NSDictionary getDictonary:[datalist firstObject]];
    self.infoModel = [LKTrackInfoModel modelWithDict:infoDic];
}

- (void)loadCommentData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (datalist.count>0 ) {
        if (self.page==1) {
            [self.tempDatalist removeAllObjects];
        }
        for (NSDictionary *dic in datalist) {
            LKTrackCommentModel *model = [LKTrackCommentModel modelWithDict:dic];
            if (model) {
                [self.tempDatalist addObject:model];
            }
        }
        
        self.page++;
    }
}

@end

@implementation LKTrackInfoModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKTrackInfoModel *item = [LKTrackInfoModel new];
        item.city_id = [NSString stringValue:[dict valueForKey:@"cityNo"]];
        item.city_country = [NSString stringValue:[dict valueForKey:@"nationalName"]];
        item.city_name = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.city_icons = [NSArray getArray:[dict valueForKey:@"cityImageList"]];
        item.city_icon = [NSString stringValue:[dict valueForKey:@"imageUrl"]];
        
        item.uid = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        item.nick_name = [NSString stringValue:[dict valueForKey:@"customerNm"]];
        item.face = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.content = [NSString stringValue:[dict valueForKey:@"footprintTitle"]];
        item.looks = [NSString stringValue:[dict valueForKey:@"pageViews"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"replyCount"]];
        item.footprintNo = [NSString stringValue:[dict valueForKey:@"footprintNo"]];
        
        item.datTravel = [NSString stringValue:[dict valueForKey:@"datTravel"]];
        item.datTravelStr = [LKUtils dateStringFromTimeIntervalStr:item.datTravel];
        item.days = [NSString stringValue:[dict valueForKey:@"days"]];
        item.peoples = [NSString stringValue:[dict valueForKey:@"peoples"]];
        item.perCapital = [NSString stringValue:[dict valueForKey:@"perCapital"]];
        item.perCapitalMax = [NSString stringValue:[dict valueForKey:@"perCapitalMax"]];
        
        return item;
    }
    return nil;
}

@end


@implementation LKTrackCommentModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKTrackCommentModel *item = [LKTrackCommentModel new];
        item.commentNo = [NSString stringValue:[dict valueForKey:@"commentNo"]];
        item.commentContent = [NSString stringValue:[dict valueForKey:@"commentContent"]];
        item.datCreate = [NSString stringValue:[dict valueForKey:@"datCreate"]];
        item.commentCustomerNumber = [NSString stringValue:[dict valueForKey:@"commentCustomerNumber"]];
        item.customerNm = [NSString stringValue:[dict valueForKey:@"customerNm"]];
        item.portraitPic = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.footprintNo = [NSString stringValue:[dict valueForKey:@"footprintNo"]];
        item.commentStatus = [NSString stringValue:[dict valueForKey:@"commentStatus"]];
        
        NSArray *tempComment = [NSArray getArray:[dict valueForKey:@"comments"]];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in tempComment) {
            LKTrackCommentModel *model = [LKTrackCommentModel modelWithDict:dic];
            if (model) {
                model.commentContent = [NSString stringWithFormat:@"%@ : %@",model.customerNm,model.commentContent];
                [temp addObject:model];
            }
        }
        item.comments = [NSArray getArray:[temp copy]];
        return item;
    }
    return nil;
}

@end
