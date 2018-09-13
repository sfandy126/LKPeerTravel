//
//  LKWishMainModel.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/13.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKWishLanguageInfo : NSObject
@property (nonatomic, assign) NSInteger codId;//": 22,
@property (nonatomic, strong) NSString *codLabelNo;//": "874220fd6d8c11e8b88300163e32df72",
@property (nonatomic, strong) NSString *codLabelName;//": "英语",
@property (nonatomic, strong) NSString *codLabelTypeNo;//": "language",
@property (nonatomic, assign) NSInteger datCreate;//": 1528729017000,
@property (nonatomic, strong) NSString *codCreateUser;//": "tongxing",
@property (nonatomic, strong) NSString *codCreateOrg;//": "tongxing",
@property (nonatomic, assign) NSInteger datModify;//": 1528729027000,
@property (nonatomic, strong) NSString *codModifyUser;//": "tongxing",
@property (nonatomic, strong) NSString *codModifyOrg;//": "tongxing",
@property (nonatomic, assign) NSInteger ctrUpdateSrlno;//": 1
@end

@interface LKWishLabelInfo : NSObject

@property (nonatomic, strong) NSString *pointType;//": null,
@property (nonatomic, assign) NSInteger codId;//": 1,
@property (nonatomic, strong) NSString *codDestinationPointNo;//": "4324234",
@property (nonatomic, strong) NSString *codDestinationPointName;//": "世界之窗",
@property (nonatomic, strong) NSString *codDestinationNo;//": "69a2bfac6d8f11e8b88300163e32df72",
@property (nonatomic, strong) NSString *txtDestinationPointDesc;//": "rwer4234",
@property (nonatomic, strong) NSString *codDestinationPointLogo;//": "1.jpg",
@property (nonatomic, assign) NSInteger codSort;//": 1,
@property (nonatomic, strong) NSString *datCreate;//": 1530435641000,
@property (nonatomic, assign) NSInteger footprint;//": 0

@end


@interface LKWishListModel : NSObject

@property (nonatomic, assign) NSInteger codId;//": 5,
@property (nonatomic, strong) NSString *codWishNo;//": "0D958EF8A5AE41579C0AE09C3354F04C",
@property (nonatomic, strong) NSString *codCustomerNumber;//": "E1E90B7AAAE3404CA05F9ACB09300E86",
@property (nonatomic, assign) NSInteger codPeopleCount;//": 4,
@property (nonatomic, assign) CGFloat codBudgetAmount;//": 5000,
@property (nonatomic, strong) NSString *flgCar;//": "1",
@property (nonatomic, strong) NSString *flagPickUp;//": "1",
@property (nonatomic, strong) NSString *codCityNo;//": "69b581746d8f11e8b88300163e32df72",
@property (nonatomic, strong) NSString *datCreate;//": 1530947058000,
@property (nonatomic, strong) NSString *codCreateUser;//": "2926A782BA3C4B5114DB667B086C7BCD",
@property (nonatomic, strong) NSString *codCreateOrg;//": "tongxing",
@property (nonatomic, assign) NSInteger datModify;//": 1530953774000,
@property (nonatomic, strong) NSString *codModifyUser;//": "2926A782BA3C4B5114DB667B086C7BCD",
@property (nonatomic, strong) NSString *codModifyOrg;//": "tongxing",
@property (nonatomic, strong) NSString *ctrUpdateSrlno;//": null,
@property (nonatomic, assign) NSInteger beginTime;//": 1515513600000,
@property (nonatomic, assign) NSInteger endTime;//": 1514736000000,
@property (nonatomic, strong) NSString *language;//": "874220fd6d8c11e8b88300163e32df72,875e59266d8c11e8b88300163e32df72",
@property (nonatomic, strong) NSString *wishLabel;//": "4324234",
@property (nonatomic, strong) NSString *codCityName;//": "武汉",

@property (nonatomic, strong) NSString *wishStatus;//    String    心愿状态(0 正常状态，1 失效)
@property (nonatomic, strong) NSString *expTime;//    String    过期时间

@property (nonatomic, strong) NSArray <LKWishLanguageInfo *>*languageList;
@property (nonatomic, strong) NSArray <LKWishLabelInfo *>*wishLabelList;

@end




@interface LKWishMainModel : NSObject

@property (nonatomic, strong) NSArray <LKWishListModel *>*dataList;

@end




