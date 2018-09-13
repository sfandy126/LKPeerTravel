//
//  LKSearchModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/7/23.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSearchModel.h"

@interface LKSearchModel ()

@end

@implementation LKSearchModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.guideListModel = [[LKSearchListModel alloc] init];
        self.trackListModel = [[LKSearchListModel alloc] init];
        self.answerListModel = [[LKSearchListModel alloc] init];
    }
    return self;
}

- (void)obtainSearchListDataWithParams:(NSDictionary *)params finishedBlock:(LKFinishedBlock)finishedBlock failedBlock:(LKFailedBlock)failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/search/item" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadData:response.data params:params];
        }
        finishedBlock(item,response);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(item,error);
    }];
}

- (void)loadData:(NSDictionary *)dict params:(NSDictionary *)params{
//    searchType 搜索类型 （1 导游，2 足迹，3 问答）
    NSInteger searchType = [[NSString stringValue:[params valueForKey:@"searchType"]] integerValue];
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (searchType ==1) {//导游
        if (self.guideListModel.page==1) {
            [self.guideListModel.tempList removeAllObjects];
        }
        if (dataList.count>0) {
   
            for (NSDictionary *dic in dataList) {
                LKSearchGuideModel *item = [LKSearchGuideModel modelWithDict:dic];
                if (item) {
                    [item calculateLayoutViewFrame];
                    [self.guideListModel.tempList addObject:item];
                }
            }
            self.guideListModel.page++;
        }
        self.guideListModel.isLastPage = dataList.count==0;
    }
    
    else if (searchType ==2) {//足迹
//        dataList = @[@{@"footprintNo":@"2121",
//                       @"footprintTitle":@"在书中，我对高加林的选择在感到气愤之余又觉得是人之常情。",
//                       @"replyCount":@"600",
//                       @"pageViews":@"90",
//                       @"customerNm":@"旅行者",
//                       @"portraitPic":@"",
//                       @"cityImageList":@[@{@"imageUrl":@"3123"},@{@"imageUrl":@"32"},@{@"imageUrl":@"321"}]},
//                     @{@"footprintNo":@"2121",
//                       @"footprintTitle":@"在书中，我对高加林的选择在感到气愤之余又觉得是人之常情。",
//                       @"replyCount":@"600",
//                       @"pageViews":@"90",
//                       @"customerNm":@"旅行者",
//                       @"portraitPic":@"",
//                       @"cityImageList":@[@{@"imageUrl":@"3123"},@{@"imageUrl":@"32"},@{@"imageUrl":@"321"}]}
//                     ];
        if (self.trackListModel.page==1) {
            [self.trackListModel.tempList removeAllObjects];
        }
        if (dataList.count>0) {
          
            for (NSDictionary *dic in dataList) {
                LKSearchTrackModel *item = [LKSearchTrackModel modelWithDict:dic];
                if (item) {
                    [self.trackListModel.tempList addObject:item];
                }
            }
            self.trackListModel.page++;
        }
        self.trackListModel.isLastPage = dataList.count==0;
        
    }
    
    else if (searchType ==3) {//问答
        if (self.answerListModel.page==1) {
            [self.answerListModel.tempList removeAllObjects];
        }
        if (dataList.count>0) {
          
            for (NSDictionary *dic in dataList) {
                LKSearchAnswerModel *item = [LKSearchAnswerModel modelWithDict:dic];
                if (item) {
                    [item calculateLayoutViewFrame];
                    [self.answerListModel.tempList addObject:item];
                }
            }
            self.answerListModel.page++;
        }
        self.answerListModel.isLastPage = dataList.count==0;
    }
}

@end


@implementation LKSearchListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.tempList = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)datalists{
    return [NSArray getArray:[self.tempList copy]];
}

@end

@implementation LKSearchGuideModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellFrame = [LKBaseFrame new];
        self.bgFrame = [LKBaseFrame new];
        self.iconFrame = [LKBaseFrame new];
        self.nameFrame = [LKBaseFrame new];
        self.contentFrame = [LKBaseFrame new];
        self.tagFrame = [LKBaseFrame new];
        self.bottomFrame = [LKBaseFrame new];
    }
    return self;
}

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKSearchGuideModel *item = [LKSearchGuideModel new];
        item.uid = [NSString stringValue:[dict valueForKey:@"codCustomerNumber"]];
        item.face = [NSString stringValue:[dict valueForKey:@"codPortraitPic"]];
        item.nick_name = [NSString stringValue:[dict valueForKey:@"codCustomerName"]];
        
        item.location = [NSString stringValue:[dict valueForKey:@"codCity"]];
        item.voiceUrl = [NSString stringValue:[dict valueForKey:@"codSpeechIntroduction"]];
        item.isVoice = item.voiceUrl.length>0;
        item.content = [NSString stringValue:[dict valueForKey:@"content"]];
        item.server_num = [NSString stringValue:[dict valueForKey:@"serviceNum"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"commentsNum"]];
        item.star = [NSString stringValue:[dict valueForKey:@"star"]];
        
        NSArray *tagArr = [NSArray getArray:[dict valueForKey:@"labels"]];
        NSMutableArray *tempTags = [NSMutableArray array];
        for (NSDictionary *dic in tagArr) {
            NSString *tagName = [NSString stringValue:[dic valueForKey:@"labelName"]];
            if (tagName.length>0) {
                [tempTags addObject:tagName];
            }
        }
        item.tags = [NSArray getArray:[tempTags copy]];
        
        return item;
    }
    return nil;
}

///计算热门导游cell中控件的frame
- (void)calculateLayoutViewFrame{
    //背景frame
    self.bgFrame.leftInval = 10.0;
    self.bgFrame.width = kScreenWidth -self.bgFrame.leftInval*2;
    
    //icon frame
    self.iconFrame.leftInval = 15.0;
    self.iconFrame.topInval = 17.0;
    self.iconFrame.width = self.iconFrame.height = 70.0;
    
    //标题frame
    self.nameFrame.font = [UIFont boldSystemFontOfSize:16.0];
    self.nameFrame.leftInval =10.0;
    self.nameFrame.topInval = self.iconFrame.topInval;
    self.nameFrame.height = ceil(self.nameFrame.font.lineHeight);
    CGSize nickSize = [LKUtils sizeFit:self.nick_name withUIFont:self.nameFrame.font withFitWidth:100 withFitHeight:self.nameFrame.height];
    self.nameFrame.width = nickSize.width;
    
    //正文frame(最多展示4行)
    self.contentFrame.font = [UIFont systemFontOfSize:12.0];
    self.contentFrame.topInval = 10.0;
    self.contentFrame.leftInval = 10.0;
    self.contentFrame.width = self.bgFrame.width - (self.iconFrame.leftInval +self.iconFrame.width)-self.nameFrame.leftInval*2;
    self.contentFrame.lineSpace = 3;
    
    NSMutableParagraphStyle *contentStyle = [[NSMutableParagraphStyle alloc] init];
    contentStyle.lineSpacing = self.contentFrame.lineSpace;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringValue:self.content]];
    [attri addAttributes:@{NSFontAttributeName : self.contentFrame.font,
                           NSParagraphStyleAttributeName:contentStyle
                           } range:NSMakeRange(0, attri.length)];
    self.contentAttri = attri;
    CGSize contentSize = [LKUtils sizeAttributedString:attri withUIFont:self.contentFrame.font withFitWidth:self.contentFrame.width withFitHeight:1000];
    CGFloat sigleHeight = ceil(self.contentFrame.font.lineHeight);
    NSInteger row = 1;
    if (contentSize.height>sigleHeight*4) {
        row = 4;
    }else if (contentSize.height>sigleHeight*3) {
        row = 3;
    } else if (contentSize.height>sigleHeight*2) {
        row = 2;
    }
    self.contentFrame.height = sigleHeight*row+self.contentFrame.lineSpace*(row-1);
    self.contentFrame.rowCount = row;
    
    //标签frame
    self.tagFrame.topInval = 20;
    self.tagFrame.width = self.contentFrame.width;
    self.tagFrame.height = 15.0;
    
    //底部视图frame
    self.bottomFrame.topInval = 0;
    self.bottomFrame.width = self.contentFrame.width;
    self.bottomFrame.height = 40.0;
    
    //cell frame
    CGFloat allViewHeight = (self.nameFrame.topInval+self.nameFrame.height) +(self.contentFrame.topInval+self.contentFrame.height) +(self.tagFrame.topInval+self.tagFrame.height) +(self.bottomFrame.topInval+self.bottomFrame.height);
    self.bgFrame.height = allViewHeight;
    
    self.cellFrame.width = kScreenWidth;
    self.cellFrame.height = allViewHeight;
    
}

@end

@implementation LKSearchTrackModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKSearchTrackModel *item = [LKSearchTrackModel new];
        item.footprintNo = [NSString stringValue:[dict valueForKey:@"footprintNo"]];
        item.footprintTitle = [NSString stringValue:[dict valueForKey:@"footprintTitle"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"replyCount"]];
        item.looks = [NSString stringValue:[dict valueForKey:@"pageViews"]];
        item.customerNm = [NSString stringValue:[dict valueForKey:@"customerNm"]];
        item.portraitPic = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.customerNumber = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        item.cityNo = [NSString stringValue:[dict valueForKey:@"cityNo"]];
        item.cityName = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.cityImageList = [NSArray getArray:[dict valueForKey:@"cityImageList"]];
        return item;
    }
    return nil;
}

@end

@implementation LKSearchAnswerModel

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
        LKSearchAnswerModel *item = [LKSearchAnswerModel new];
        item.questionNo = [NSString stringValue:[dict valueForKey:@"questionNo"]];
        item.uid = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        item.nick_name = [NSString stringValue:[dict valueForKey:@"customerNm"]];
        item.face = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.title = [NSString stringValue:[dict valueForKey:@"questionTitle"]];
        item.content = [NSString stringValue:[dict valueForKey:@"questionContent"]];
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
    self.newestCellFrame.height = self.newesBgFrame.height;
    
    
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

