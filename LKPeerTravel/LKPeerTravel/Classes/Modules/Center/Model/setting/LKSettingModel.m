//
//  LKSettingModel.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSettingModel.h"

@class LKSettingRowModel;
@implementation LKSettingModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSMutableArray *temp = [NSMutableArray array];
        for (int i=0; i<4; i++) {
            NSString *title = @"";
            LKSettingRowType rowType = LKSettingRowType_about;
            if (i==0) {
                title = LKLocalizedString(@"LKSetting_about");//关于我们
                rowType = LKSettingRowType_about;
            }
            if (i==1) {
                title = LKLocalizedString(@"LKSetting_feedback");//意见反馈
                rowType = LKSettingRowType_feedback;
            }
            if (i==2) {
                title = LKLocalizedString(@"LKSetting_support");//支持我们
                rowType = LKSettingRowType_support;
            }
            if (i==3) {
                title = LKLocalizedString(@"LKSetting_share");//分享给朋友
                rowType = LKSettingRowType_share;
            }
            LKSettingRowModel *row = [LKSettingRowModel modelWithDict:@{@"title":title}];
            row.rowType = rowType;
            if (row) {
                [temp addObject:row];
            }
        }
        self.sections = @[[temp copy]];
    }
    return self;
}

@end


@implementation LKSettingRowModel

+ (id)modelWithDict:(NSDictionary *)dict{
    if ([NSDictionary isNotEmptyDict:dict]) {
        LKSettingRowModel *item = [LKSettingRowModel new];
        item.title = [NSString stringValue:[dict valueForKey:@"title"]];
        item.subTitle = [NSString stringValue:[dict valueForKey:@"subTitle"]];
        return item;
    }
    return nil;
}

@end

