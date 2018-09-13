//
//  LKAnswerDetailModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/20.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerDetailModel.h"

@interface LKAnswerDetailModel ()
@property (nonatomic,strong) NSMutableArray *tempDatalist;

@end

@implementation LKAnswerDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempDatalist = [NSMutableArray array];
        self.page = 1;
        //测试数据
//        NSArray *arr = @[@{@"key":@"1",@"comments":@[@{@"key":@"1"},@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"},@{@"key":@"1"},@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"}]},
//                         @{@"key":@"1",@"comments":@[@{@"key":@"1"},@{@"key":@"1"},@{@"key":@"1"},@{@"key":@"1"}]}];
//        for (NSDictionary *dic in arr) {
//            LKAnswerCommentModel *item = [LKAnswerCommentModel modelWithDict:dic];
//            [self.tempDatalist addObject:item];
//        }
    }
    return self;
}

- (NSArray *)comments{
    return [NSArray getArray:[self.tempDatalist copy]];
}

- (void)reportedAnswerDetailWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self requestDataWithParams:params forPath:@"tx/cif/buss/add/count" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)addCommentWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [self requestDataWithParams:params forPath:@"tx/cos/answer/addition" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadCommentsWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/answer/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadCommentData:response.data];
        }
        finishedBlock(response,response.success);
        
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadCommentData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (datalist.count>0 ) {
        if (self.page==1) {
            [self.tempDatalist removeAllObjects];
        }
        for (NSDictionary *dic in datalist) {
            LKAnswerCommentModel *model = [LKAnswerCommentModel modelWithDict:dic];
            if (model) {
                [self.tempDatalist addObject:model];
            }
        }
        
        self.page++;
    }
    self.isLastPage = datalist.count==0;
}


@end

@implementation LKAnswerCommentModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKAnswerCommentModel *item = [LKAnswerCommentModel new];
        item.answerNo = [NSString stringValue:[dict valueForKey:@"answerNo"]];
        item.questionNo = [NSString stringValue:[dict valueForKey:@"questionNo"]];
        item.answerContent = [NSString stringValue:[dict valueForKey:@"answerContent"]];
        item.datCreate = [NSString stringValue:[dict valueForKey:@"datCreate"]];
        item.customerNumber = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        item.customerNm = [NSString stringValue:[dict valueForKey:@"customerNm"]];
        item.portraitPic = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.commentStatus = [NSString stringValue:[dict valueForKey:@"commentStatus"]];
        
        NSArray *tempComment = [NSArray getArray:[dict valueForKey:@"comments"]];
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in tempComment) {
            LKAnswerCommentModel *model = [LKAnswerCommentModel modelWithDict:dic];
            if (model) {
                model.answerContent = [NSString stringWithFormat:@"%@ : %@",model.customerNm,model.answerContent];
                [temp addObject:model];
            }
        }
        item.comments = [NSArray getArray:[temp copy]];
        return item;
    }
    return nil;
}


@end

