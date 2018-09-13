//
//  LKSettingModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

typedef NS_ENUM(NSInteger,LKSettingRowType) {
    LKSettingRowType_about, //关于我们
    LKSettingRowType_feedback, //意见反馈
    LKSettingRowType_support,//支持我们
    LKSettingRowType_share,//分享给朋友
    LKSettingRowType_nocation,  //通知
    LKSettingRowType_switchLanguage, //切换语言
    LKSettingRowType_clearCache,    //清除缓存
};

@interface LKSettingModel : LKBaseModel

@property (nonatomic,copy) NSArray *sections;

@end

@interface LKSettingRowModel : LKBaseModel
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) LKSettingRowType rowType;
@property (nonatomic,copy) NSString *subTitle;

@end
