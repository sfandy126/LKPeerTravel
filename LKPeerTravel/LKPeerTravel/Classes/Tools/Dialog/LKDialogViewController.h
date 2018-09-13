//
//  LKDialogViewController.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LKDialogType) {
    LKDialogType_language, // 填写语言
    LKDialogType_person, //人数
    LKDialogType_budget, //预算
    LKDialogType_wishLabel, //心愿标签
    LKDialogType_nickname, // 昵称
    LKDialogType_gentle, // 性别
    LKDialogType_job, // 职业
    LKDialogType_hobby, // 特长
    LKDialogType_desc, // 自我介绍
    LKDialogType_record, // 录音
};

@interface LKDialogViewController : UIViewController

@property (nonatomic, copy) void (^selectedLanguageBlock)(NSArray *datas);
@property (nonatomic, copy) void (^gentleBlock) (NSInteger type);
@property (nonatomic, copy) void (^sureBlock)(NSString *inputStr);
@property (nonatomic, assign) LKDialogType type;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) void (^recordFinishBlock)(NSString *recordUrl);


+ (instancetype)alertWithDialogType:(LKDialogType)type title:(NSString *)title;

@end
