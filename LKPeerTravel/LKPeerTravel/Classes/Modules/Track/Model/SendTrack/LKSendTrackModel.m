//
//  LKSendTrackModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackModel.h"


@implementation LKSendTrackModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.infoModel = [[LKSendTrackInfoModel alloc] init];
        
        LKSendTrackAddModel *item2 = [LKSendTrackAddModel modelWithDict:@{@"is_add":@"1"}];
        [item2 calculateLayoutViewFrame];
        self.addItems = @[item2];
    }
    return self;
}

- (void)sendFootprintData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock)failedBlock{
    [super requestDataWithParams:params forPath:@"tx/cif/customer/footprint/addition" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        finishedBlock(response,response.success);
    } failed:^(LKBaseModel *item, NSError *error) {
        failedBlock(error);
    }];
}


@end

@implementation  LKSendTrackInfoModel

@end

@implementation  LKSendTrackPicModel

@end


@implementation LKSendTrackAddModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemFrame = [LKBaseFrame new];
        self.iconFrame = [LKBaseFrame new];
        self.contentFrame = [LKBaseFrame new];
    }
    return self;
}

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKSendTrackAddModel *model = [LKSendTrackAddModel new];
        model.is_add = [[NSString stringValue:[dict valueForKey:@"is_add"]] boolValue];
        model.city_icon = [NSString stringValue:[dict valueForKey:@"city_icon"]];
        model.content = [NSString stringValue:[dict valueForKey:@"content"]];

        return model;
    }
    return nil;
}

- (void)calculateLayoutViewFrame{
    //布局模型frame
    
    //计算icon图片大小
    //    self.iconFrame.width = 200;//itemwidth是外部colloectionView的layout动态计算的。
    self.iconFrame.width = (kScreenWidth - 10 -10-10)/2;
    if (self.itemIndex %2 ==1) {
        self.iconFrame.height = 267;
        
    }else{
        self.iconFrame.height = 167;
    }
    
    //正文的frame
    self.contentFrame.font = [UIFont boldSystemFontOfSize:12.0];
    self.contentFrame.lineSpace = 3;
    self.contentFrame.topInval = 10;
    self.contentFrame.leftInval = 10;
    self.contentFrame.width = self.iconFrame.width - self.contentFrame.leftInval*2;
    
    if (self.content.length>0) {
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

    
    //cell 总容器的frame
    CGFloat footerHeight = 15.0;
    self.itemFrame.width = self.iconFrame.width;
    self.itemFrame.height = self.iconFrame.height +(self.contentFrame.topInval+self.contentFrame.height) +footerHeight;
    if (self.is_add) {
        self.itemFrame.height = 191;
    }
}

@end

