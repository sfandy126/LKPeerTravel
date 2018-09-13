//
//  LKMyServerModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/19.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

typedef NS_ENUM(NSInteger,LKMyServerType) {
    LKMyServerType_Info,    //基本信息
    LKMyServerType_scene,   //景点
    LKMyServerType_cate,    //美食
    LKMyServerType_shop,    //购物
    LKMyServerType_date,    //日期安排
};

///美食、景点、购物的collcection布局
#define column 4 //列数
///横行间隙
#define itemInterInval (kScreenWidth-20*2 -itemWidth*column)/(column-1)
///垂直间隙
#define itemLineSpacing 10.0
#define itemWidth  71*kWidthRadio
#define itemHeight 94*kWidthRadio

@class LKMyServerTypeModel,LKMyServerCityModel;

@interface LKMyServerModel : LKBaseModel

@property (nonatomic,copy) NSString *serviceNo;///服务编号
@property (nonatomic,copy) NSArray *dateSets;///日期安排
@property (nonatomic,assign) BOOL flagCar;///是否要车, 1-是;0-否
@property (nonatomic,assign) BOOL flagPlane;///是否安排接机, 1-是;0-否
@property (nonatomic,copy) NSString *pmax;//服务人员上限
@property (nonatomic,copy) NSArray *discounts;//折扣信息
@property (nonatomic,copy) NSString *point;///价格

///列表数据源
@property (nonatomic,copy) NSArray *cellDatas;
///是否为编辑状态
@property (nonatomic,assign) BOOL isEditing;

///获取我的服务接口
- (void)obtainMyServerData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///保存我的服务接口
- (void)saveMyServerData:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;
@end


///景点、美食、购物的的数据模型
@interface LKMyServerTypeModel : LKBaseModel
@property (nonatomic,assign) LKMyServerType type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSArray <LKMyServerCityModel *>*citys;
@property (nonatomic,assign) CGFloat itemsHeight;

- (void)refreshItemHeight;

@end

///景点、美食、购物的单个城市的数据模型
@interface LKMyServerCityModel : LKBaseModel
@property (nonatomic,copy) NSString *city_name;
@property (nonatomic,copy) NSString *city_icon;
@property (nonatomic,copy) NSString *city_id;

/// 原始的数据
@property (nonatomic, strong) NSDictionary *dict;
@end
