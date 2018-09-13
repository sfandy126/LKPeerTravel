//
//  LKSceneDetailModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKSceneDetailPicModel : NSObject

@property (nonatomic, strong) NSString *codDestinationImageNo;//": "2DBCD28308CD4846BCAFD140841BA1AF",
@property (nonatomic, strong) NSString *txtImageDesc;//": "4234234",
@property (nonatomic, strong) NSString *codImageUrl;//": "http://baidu.con/jpg"

@property (nonatomic, assign) CGFloat pic_width;
@property (nonatomic, assign) CGFloat pic_height;
@property (nonatomic, assign) CGFloat test_height;
@property (nonatomic, assign) CGFloat cell_height;

@end

@interface LKSceneDetailModel : NSObject


@property (nonatomic, assign) NSInteger pointType;//": 1,
@property (nonatomic, assign) NSInteger codId;//": 5,
@property (nonatomic, strong) NSString *codDestinationPointNo;//": "C4D82B0382A24A5D88B8CDCE46EB7574",
@property (nonatomic, strong) NSString *codDestinationPointName;//": "深圳",
@property (nonatomic, strong) NSString *codDestinationNo;//": "123456",
@property (nonatomic, assign) NSInteger codSort;//": 0,
@property (nonatomic, assign) NSInteger datCreate;//": 1530668653000,
@property (nonatomic, assign) NSInteger footprint;//": 0,

@property (nonatomic, strong) NSArray <LKSceneDetailPicModel *> *images;

@end
