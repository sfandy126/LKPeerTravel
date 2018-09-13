//
//  LKTrackModel.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseModel.h"

@class LKTrackCityModel;
@interface LKTrackModel : LKBaseModel

///头部城市
@property (nonatomic,strong) LKTrackCityModel *headerModel;
///城市分类
@property (nonatomic,strong) NSArray *cityClassifys;

///热门城市
@property (nonatomic,strong) NSArray *hotCitys;
@property (nonatomic,assign) BOOL isHotLastPage;

///最新城市
@property (nonatomic,strong) NSArray *newestCitys;
@property (nonatomic,assign) BOOL isNewestLastPage;

///获取banner
- (void)loadTrackBannerDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取城市分类列表数据
- (void)loadCityClassDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;

///获取足迹列表接口数据
- (void)loadTrackListDataWithParams:(NSDictionary *)params finishedBlock:(LKServerFinishedBlock )finishedBlock failedBlock:(LKServerFailedBlock )failedBlock;
@end

///城市model
@interface LKTrackCityModel : LKBaseModel

@property (nonatomic,copy) NSString *city_id;///城市编号
@property (nonatomic,copy) NSString *city_country;//城市所属国家
@property (nonatomic,copy) NSString *city_name;//城市名称
@property (nonatomic,copy) NSString *city_icon;//城市背景
@property (nonatomic,assign) CGFloat city_icon_width;
@property (nonatomic,assign) CGFloat city_icon_height;
@property (nonatomic,copy) NSArray *city_icons;//城市背景多图

@property (nonatomic,assign) BOOL is_more;//是否展示更多

@property (nonatomic,copy) NSString *uid;//导游
@property (nonatomic,copy) NSString *nick_name;
@property (nonatomic,copy) NSString *face;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSAttributedString *contentAttri;
@property (nonatomic,copy) NSString *looks;
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) NSString *footprintNo;///足迹编号

@property (nonatomic,copy) NSString *datTravel;///出发时间
@property (nonatomic,copy) NSString *datTravelStr;///转换后的出发时间
@property (nonatomic,copy) NSString *days;///天数
@property (nonatomic,copy) NSString *peoples;///人数
@property (nonatomic,copy) NSString *perCapital;///最低人均消费
@property (nonatomic,copy) NSString *perCapitalMax;///最高人均消费


///瀑布流的下表(NSIndexPath.item)
@property (nonatomic,assign) NSInteger itemIndex;

//足迹-瀑布流-布局模型
////容器frame
@property (nonatomic,strong) LKBaseFrame *itemFrame;
///icon图片frme
@property (nonatomic,strong) LKBaseFrame *iconFrame;
///正文frame
@property (nonatomic,strong) LKBaseFrame *contentFrame;
///用户信息frame
@property (nonatomic,strong) LKBaseFrame *userFrame;

///查看frame
@property (nonatomic,strong) LKBaseFrame *lookFrame;
///回复frame
@property (nonatomic,strong) LKBaseFrame *commentFrame;


@end
