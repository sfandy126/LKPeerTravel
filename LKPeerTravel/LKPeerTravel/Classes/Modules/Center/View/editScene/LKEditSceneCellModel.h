//
//  LKEditSceneCellModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/22.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LKEditRowType) {
    LKEditRowType_pic = 100,
    LKEditRowType_text = 200,
};

@interface LKEditSceneCellModel : NSObject

@property (nonatomic, assign) LKEditRowType type;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *picurl;


@property (nonatomic, strong) NSString *codDestinationImageNo;//String;    图片编号
@property (nonatomic, strong) NSString *txtImageDesc;//    String    图片说明
@property (nonatomic, strong) NSString *codImageUrl;//    String    图片链接
@property (nonatomic, strong) NSString *imgHeight;//    String    图片高度
@property (nonatomic, strong) NSString *imgWidth;//    String    图片宽度


- (void)juageCellHeight;


@end
