//
//  LKTrackModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKTrackModel.h"

@implementation LKTrackModel

///获取banner
- (void)loadTrackBannerDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/footprint/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadBannerData:response.data];
        }
        finishedBlock(response,response.success);
        
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadCityClassDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/city/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            [self loadCityClassData:response.data];
        }
        finishedBlock(response,response.success);

    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadTrackListDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    @weakify(self);
    [self requestDataWithParams:params forPath:@"tx/cif/footprint/list/inquiry" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        if (response.success) {
            BOOL isHot = [[params valueForKey:@"orderBy"] isEqualToString:@"1"];
            [self loadTrackListData:response.data isHot:isHot];
            finishedBlock(response,YES);
        }else{
            finishedBlock(response,NO);
        }
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadBannerData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in dataList) {
        LKTrackCityModel *item = [LKTrackCityModel modelWithDict:dic];
        if (item) {
            [temp addObject:item];
        }
    }
    
    self.headerModel = [temp objectAt:0];
}

///处理城市分类接口数据
- (void)loadCityClassData:(NSDictionary *)dict{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray array];
    NSInteger index = 0;
    for (NSDictionary *dic in dataList) {
        LKTrackCityModel *item = [LKTrackCityModel modelWithDict:dic];
        if (item && index<4) {
            [temp addObject:item];
        }
        index++;
    }
    
    //最多展示4个，第5个显示更多
    if (temp.count>0) {
        NSDictionary *moreDic = @{@"is_more":@(YES)};
        LKTrackCityModel *item = [LKTrackCityModel modelWithDict:moreDic];
        [temp addObject:item];
    }
    self.cityClassifys = [NSArray getArray:[temp copy]];
}

///处理足迹接口数据
- (void)loadTrackListData:(NSDictionary *)dict isHot:(BOOL)isHot{
    NSArray *dataList = [NSArray getArray:[dict valueForKey:@"dataList"]];
    NSMutableArray *temp = [NSMutableArray array];
    NSInteger index=0;
    for (NSDictionary *dic in dataList) {
        LKTrackCityModel *item = [LKTrackCityModel modelWithDict:dic];
        if (item) {
            item.itemIndex = index;
            [item calculateLayoutViewFrame];
            [temp addObject:item];
        }
        index++;
    }
    if (isHot) {
        self.hotCitys = [NSArray getArray:[temp copy]];
        self.isHotLastPage = self.hotCitys.count==0;
    }else{
        self.newestCitys = [NSArray getArray:[temp copy]];
        self.isNewestLastPage = self.newestCitys.count==0;
    }
}

@end

@implementation LKTrackCityModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemFrame = [LKBaseFrame new];
        self.iconFrame = [LKBaseFrame new];
        self.contentFrame = [LKBaseFrame new];
        self.userFrame = [LKBaseFrame new];
        
        self.lookFrame = [LKBaseFrame new];
        self.commentFrame = [LKBaseFrame new];

    }
    return self;
}

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKTrackCityModel *item = [LKTrackCityModel new];
        item.city_id = [NSString stringValue:[dict valueForKey:@"cityNo"]];
        item.city_country = [NSString stringValue:[dict valueForKey:@"nationalName"]];
        item.city_name = [NSString stringValue:[dict valueForKey:@"cityName"]];
        item.city_icons = [NSArray getArray:[dict valueForKey:@"cityImageList"]];
        item.is_more = [[NSString stringValue:[dict valueForKey:@"is_more"]] boolValue];
        item.city_icon = [NSString stringValue:[dict valueForKey:@"imageUrl"]];
        item.city_icon_width = [[NSString stringValue:[dict valueForKey:@"imgWidth"]] floatValue];
        item.city_icon_height = [[NSString stringValue:[dict valueForKey:@"imgHeight"]] floatValue];

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

///计算足迹（tabbar）界面的UI
- (void)calculateLayoutViewFrame{
    //布局模型frame
    
    //计算icon图片大小
//    self.iconFrame.width = 200;//itemwidth是外部colloectionView的layout动态计算的。
    self.iconFrame.width = (kScreenWidth - 10 -10-10)/2;
#pragma mark - -  TODO 存在耗时操作，需要后台返回图片宽高
    CGSize iconSize = CGSizeMake(self.city_icon_width, self.city_icon_height);//[LKUtils getImageSizeWithURL:self.city_icon];
    if (iconSize.width>0 && iconSize.height>0) {
        //真是高度/真是宽度=图片高度/图片宽度
        self.iconFrame.height = 1.0*iconSize.height/iconSize.width*self.iconFrame.width;
    }else{
        if (self.itemIndex%2 ==1) {
            self.iconFrame.height = 267;
        }else{
            self.iconFrame.height = 167;
        }
    }
    
    //正文的frame
    self.contentFrame.font = [UIFont boldSystemFontOfSize:12.0];
    self.contentFrame.lineSpace = 3;
    self.contentFrame.topInval = 10;
    self.contentFrame.leftInval = 10;
    self.contentFrame.width = self.iconFrame.width - self.contentFrame.leftInval*2;
    
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = self.contentFrame.lineSpace;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.content];
        [attri addAttributes:@{NSFontAttributeName : self.contentFrame.font,
                               NSParagraphStyleAttributeName:style
                               } range:NSMakeRange(0, attri.length)];
        self.contentAttri = attri;
        CGSize contentSize = [LKUtils sizeAttributedString:attri withUIFont:self.contentFrame.font withFitWidth:self.contentFrame.width withFitHeight:1000];
        //最多显示2行
        CGFloat signleHeight = ceil(self.contentFrame.font.lineHeight);
        CGFloat twoRowHeight = signleHeight*2+self.contentFrame.lineSpace;
        if (contentSize.height>signleHeight) {
            self.contentFrame.height = twoRowHeight;
            self.contentFrame.rowCount = 2;
        }else{
            self.contentFrame.height =signleHeight;
            self.contentFrame.rowCount = 1;
        }
    }
    
    //用户信息frame
    self.userFrame.topInval = 10.0;
    self.userFrame.leftInval = 10.0;
    self.userFrame.width = self.iconFrame.width -self.userFrame.leftInval*2;
    self.userFrame.height = 20.0;
    
    //cell 总容器的frame
    CGFloat footerHeight = 15.0;
    self.itemFrame.width = self.iconFrame.width;
    self.itemFrame.height = self.iconFrame.height +(self.contentFrame.topInval+self.contentFrame.height) +(self.userFrame.topInval+self.userFrame.height) +footerHeight;

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

