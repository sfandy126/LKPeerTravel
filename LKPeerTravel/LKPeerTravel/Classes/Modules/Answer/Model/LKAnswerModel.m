//
//  LKAnswerModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/31.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAnswerModel.h"

@interface LKAnswerModel ()
@property (nonatomic,strong) NSMutableArray *tempLastestList;

@end

@implementation LKAnswerModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tempLastestList = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)lastestList{
    return [NSArray getArray:[self.tempLastestList copy]];
}

///获取问答列表接口（热门）
- (void)obtainAnswerHotListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/home/question/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadHotData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadHotData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in datalist) {
        LKAnswerSingleModel *item = [LKAnswerSingleModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    self.hotLists = [NSArray getArray:[temp copy]];
}

///获取问答列表接口（最新）
- (void)obtainAnswerLastestListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/home/question/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadAnswerLastestListData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadAnswerLastestListData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (datalist.count>0) {
        if (self.page==1) {
            [self.tempLastestList removeAllObjects];
        }
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in datalist) {
            LKAnswerSingleModel *item = [LKAnswerSingleModel modelWithDict:dic];
            if (item) {
                [item calculateLayoutViewFrame];
                [temp addObject:item];
            }
        }
        [self.tempLastestList addObjectsFromArray:[temp copy]];
        
        self.page++;
    }
    self.isLastPage = datalist.count==0;
}

@end


@implementation LKAnswerSingleModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.newestCellFrame = [LKBaseFrame new];
        self.newesBgFrame = [LKBaseFrame new];
        self.newesTitleFrame = [LKBaseFrame new];
        self.newestContentFrame = [LKBaseFrame new];
        self.newestUserFrame = [LKBaseFrame new];
        
        self.lookFrame = [LKBaseFrame new];
        self.commentFrame = [LKBaseFrame new];

    }
    return self;
}

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKAnswerSingleModel *item = [LKAnswerSingleModel new];
        item.questionNo = [NSString stringValue:[dict valueForKey:@"questionNo"]];
        item.uid = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        item.nick_name = [NSString stringValue:[dict valueForKey:@"customerNm"]];
        item.face = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.title = [NSString stringValue:[dict valueForKey:@"questionTitle"]];
        item.content = [NSString stringValue:[dict valueForKey:@"questionContent"]];
        item.join_num = [NSString stringValue:[dict valueForKey:@"join_num"]];
        item.location = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.looks = [NSString stringValue:[dict valueForKey:@"pageViews"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"replyCount"]];
        item.datCreate = [NSString stringValue:[dict valueForKey:@"datCreate"]];

        return item;
    }
    return nil;
}


///计算最新列表的单个cell frame
- (void)calculateLayoutViewFrame{
    //背景
    self.newesBgFrame.leftInval = 10;
    self.newesBgFrame.width = kScreenWidth -self.newesBgFrame.leftInval*2;
    
    //标题
    self.newesTitleFrame.leftInval = 10;
    self.newesTitleFrame.topInval = 20;
    self.newesTitleFrame.font = [UIFont boldSystemFontOfSize:16.0];
    self.newesTitleFrame.height = ceil(self.newesTitleFrame.font.lineHeight);
    self.newesTitleFrame.width = 200;
    
    //正文
    self.newestContentFrame.leftInval = 10;
    self.newestContentFrame.topInval = 13;
    self.newestContentFrame.width = self.newesBgFrame.width - self.newestContentFrame.leftInval*2;
    self.newestContentFrame.lineSpace = 3;
    
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = self.newestContentFrame.lineSpace;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.content];
        [attri addAttributes:@{NSFontAttributeName : self.newestContentFrame.font,
                               NSParagraphStyleAttributeName:style
                               } range:NSMakeRange(0, attri.length)];
        self.contentAttri = attri;
        CGSize contentSize = [LKUtils sizeAttributedString:attri withUIFont:self.newestContentFrame.font withFitWidth:self.newestContentFrame.width withFitHeight:1000];
        //最多显示3行
        CGFloat signleHeight = ceil(self.newestContentFrame.font.lineHeight);
        CGFloat twoRowHeight = signleHeight*2+self.newestContentFrame.lineSpace;
        CGFloat threeRowHeight = signleHeight*3+self.newestContentFrame.lineSpace*2;

        if (contentSize.height>twoRowHeight) {
            self.newestContentFrame.height = threeRowHeight;
            self.newestContentFrame.rowCount = 3;
        }else if (contentSize.height>signleHeight) {
            self.newestContentFrame.height = twoRowHeight;
            self.newestContentFrame.rowCount = 2;
        }else{
            self.newestContentFrame.height =signleHeight;
            self.newestContentFrame.rowCount = 1;
        }
    }
    
    //用户信息
    self.newestUserFrame.leftInval = 10;
    self.newestUserFrame.topInval = 15;
    self.newestUserFrame.width = self.newesBgFrame.width;
    self.newestUserFrame.height = 20;
    
    //cell frame
    self.newestCellFrame.width = kScreenWidth;
    self.newesBgFrame.height = (self.newesTitleFrame.topInval+self.newesTitleFrame.height) +(self.newestContentFrame.topInval+self.newestContentFrame.height) +(self.newestUserFrame.topInval+self.newestUserFrame.height) +16;//16用户信息底部间距
    self.newestCellFrame.height = self.newesBgFrame.height +(self.isHideFooter?:10);
    
    
    //查看frame
    self.lookFrame.leftInval = 3.0;
    self.lookFrame.font = [UIFont systemFontOfSize:10.0];
    self.lookFrame.height = ceil(self.lookFrame.font.lineHeight);
    {
        CGSize size = [LKUtils sizeFit:self.looks withUIFont:self.lookFrame.font withFitWidth:60 withFitHeight:self.lookFrame.height];
        self.lookFrame.width = size.width;
    }
    
    //回复frame
    self.commentFrame.leftInval = 3.0;
    self.commentFrame.font = [UIFont systemFontOfSize:10.0];
    self.commentFrame.height = ceil(self.commentFrame.font.lineHeight);
    {
        CGSize size = [LKUtils sizeFit:self.comments withUIFont:self.commentFrame.font withFitWidth:60 withFitHeight:self.commentFrame.height];
        self.commentFrame.width = size.width;
    }
}

@end
