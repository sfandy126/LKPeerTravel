//
//  LKPersonInfoModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@interface LKPersonInfoModel : LKBaseModel

@property (nonatomic,copy) NSString *face;  ///头像
@property (nonatomic,copy) NSString *name;  ///名称
@property (nonatomic,copy) NSString *sex;   ///性别
@property (nonatomic,copy) NSString *age;   ///年龄
@property (nonatomic,copy) NSString *profession;    ///职业
@property (nonatomic,copy) NSString *language;  ///语言
@property (nonatomic,copy) NSString *city;  ///城市
@property (nonatomic,copy) NSString *interest;///爱好
@property (nonatomic,copy) NSString *voice;///语音介绍
@property (nonatomic,copy) NSString *introduce;///自我介绍
@property (nonatomic,copy) NSAttributedString *introduceAttri;///自我介绍


@end
