//
//  LKHomeModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKHomeModel.h"

@implementation LKHomeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

///banner接口
- (void)obtainHomeBanerData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cos/banner/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadBannerData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadBannerData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray  array];
    for (NSDictionary *dic in dataList) {
        LKBannerPicModel *item = [LKBannerPicModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    self.banners = [NSArray getArray:[temp copy]];
}

///热门城市接口
- (void)obtainHomeHotCityData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/city/criteria/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadHotCityData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadHotCityData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray  array];
    for (NSDictionary *dic in dataList) {
        LKHomeHotCityModel *item = [LKHomeHotCityModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    self.hotCitys = [NSArray getArray:[temp copy]];
}


///私人导游接口
- (void)obtainHomePrivateGuiderData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/CifCustomerGuide/list" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadPrivateGuiderData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadPrivateGuiderData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray  array];
    for (NSDictionary *dic in dataList) {
        LKHomeGuideModel *item = [LKHomeGuideModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    self.helpers = [NSArray getArray:[temp copy]];
}


///热门导游接口
- (void)obtainHomeHotGuiderData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/CifCustomerGuide/listHot" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadHotGuiderData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadHotGuiderData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray  array];
    for (NSDictionary *dic in dataList) {
        LKHomeGuideModel *item = [LKHomeGuideModel modelWithDict:dic];
        if (item) {
            [item calculateLayoutViewFrame];
            [temp addObject:item];
        }
    }
    self.hotGuides = [NSArray getArray:[temp copy]];
}

@end

@implementation LKHomeGuideModel

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
        LKHomeGuideModel *item = [LKHomeGuideModel new];
        item.uid = [NSString stringValue:[dict valueForKey:@"codCustomerNumber"]];
        item.face = [NSString stringValue:[dict valueForKey:@"codPortraitPic"]];
        item.nick_name = [NSString stringValue:[dict valueForKey:@"customerName"]];
        
        item.location = [NSString stringValue:[dict valueForKey:@"codCity"]];
        item.voiceUrl = [NSString stringValue:[dict valueForKey:@"codSpeechIntroduction"]];//@"http://boscdn.bpc.baidu.com/v1/developer/dece7401-a1bb-4504-8523-83aa78f1e606.mp3"
        item.isVoice = item.voiceUrl.length>0;
        item.content = [NSString stringValue:[dict valueForKey:@"content"]];
        item.server_num = [NSString stringValue:[dict valueForKey:@"serviceNum"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"commentsNum"]];
        item.star = [NSString stringValue:[dict valueForKey:@"starLevel"]];
        
        NSString *name = [NSString stringValue:[dict valueForKey:@"codCustomerName"]];
        if (name.length>0) {
            item.nick_name = name;
        }
        NSString *txtDesc = [NSString stringValue:[dict valueForKey:@"txtDesc"]];
        if (txtDesc.length>0) {
            item.content = txtDesc;
        }
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
    
    CGFloat footerHeight = self.isHideFooter?:10.0;
    self.cellFrame.width = kScreenWidth;
    self.cellFrame.height = allViewHeight +footerHeight;
    
}

@end


@implementation LKHomeHotCityModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKHomeHotCityModel *item = [LKHomeHotCityModel new];
        item.city_id = [NSString stringValue:[dict valueForKey:@"cityNo"]];
        item.city_icon = [NSString stringValue:[dict valueForKey:@"cityImagesUrl"]];
        item.city_name = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.likes = [NSString stringValue:[dict valueForKey:@"wishNum"]];
        return item;
    }
    return nil;
}

@end
