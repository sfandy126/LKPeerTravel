//
//  LKGuideListModel.m
//  LKPeerTravel
//
//  Created by LK on 2018/8/1.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKGuideListModel.h"

@interface LKGuideListModel ()
@property (nonatomic,strong) NSMutableArray *tempLists;
@end

@implementation LKGuideListModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.tempLists = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)list{
    return [NSArray getArray:[self.tempLists copy]];
}

///城市中的导游列表接口
- (void)obtainGuideListData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/city/listByCity" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        if (response.success) {
            [self loadGuideListData:response.data];
        }
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loadGuideListData:(NSDictionary *)dict{
    NSArray *datalist = [NSArray getArray:[dict valueForKey:@"dataList"]];
    if (datalist.count>0) {
        if (self.page==1) {
            [self.tempLists removeAllObjects];
        }
        for (NSDictionary *dic in datalist) {
            LKGuideListItemModel *item = [LKGuideListItemModel modelWithDict:dic];
            if (item) {
                [item calculateLayoutViewFrame];
                [self.tempLists addObject:item];
            }
        }
        
        self.page++;
    }
    
    self.isLastPage = datalist.count==0;
}

@end



@implementation LKGuideListItemModel

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
        LKGuideListItemModel *item = [LKGuideListItemModel new];
        item.uid = [NSString stringValue:[dict valueForKey:@"customerNumber"]];
        item.face = [NSString stringValue:[dict valueForKey:@"portraitPic"]];
        item.nick_name = [NSString stringValue:[dict valueForKey:@"customerName"]];
        
        item.location = [NSString stringValue:[dict valueForKey:@"codCity"]];
        item.voiceUrl = [NSString stringValue:[dict valueForKey:@"speechIntroduction"]];
        item.isVoice = item.voiceUrl.length>0;
        item.content = [NSString stringValue:[dict valueForKey:@"txtDesc"]];
        item.server_num = [NSString stringValue:[dict valueForKey:@"orderNum"]];
        item.comments = [NSString stringValue:[dict valueForKey:@"commentNum"]];
        item.star = [NSString stringValue:[dict valueForKey:@"starLevel"]];
        
        NSArray *tagArr = [NSArray getArray:[dict valueForKey:@"hobby"]];
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
