//
//  LKBusinessMacro.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#ifndef LKBusinessMacro_h
#define LKBusinessMacro_h

/**
 *  业务相关的宏定义
 *
 *
 *
 **/

#define kBaseURL @"http://120.25.0.202:8081/"


///用户默认头像（性别：0-woman,1-man）
#define kDefaultUserImage(sex) (sex==1?[UIImage imageNamed:@"head_man"]:[UIImage imageNamed:@"head_female"])


///图片上传进度
typedef NS_ENUM(NSInteger,LKImageUploadProccess) {
    LKImageUploadProccess_default=0,
    LKImageUploadProccess_uploading,
    LKImageUploadProccess_finished,
    LKImageUploadProccess_failed,
};

#endif /* LKBusinessMacro_h */
