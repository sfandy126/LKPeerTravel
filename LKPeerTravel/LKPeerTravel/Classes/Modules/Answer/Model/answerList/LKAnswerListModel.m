//
//  LKAnswerListModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/17.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerListModel.h"

@interface LKAnswerListModel ()
@property (nonatomic,strong) NSMutableArray *tempDataList;

@end

@implementation LKAnswerListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempDataList = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)datalist{
    return [NSArray getArray:[self.tempDataList copy]];
}

///获取问答列表接口
- (void)obtainAnswerListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/home/question/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

///我的问答列表接口
- (void)obtainMineAnswerListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/question/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}


- (void)loadData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (datalist.count>0) {
        if (self.page==1) {
            [self.tempDataList removeAllObjects];
        }
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in datalist) {
            LKAnswerSingleModel *item = [LKAnswerSingleModel modelWithDict:dic];
            if (item) {
                [item calculateLayoutViewFrame];
                [temp addObject:item];
            }
        }
        [self.tempDataList addObjectsFromArray:[temp copy]];
        
        self.page++;
    }
    self.isLastPage = datalist.count==0;
}

@end
