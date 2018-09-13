//
//  LKCenterModel.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/3.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCenterModel.h"

@implementation LKCenterModel

- (instancetype)initWithUserType:(LKCenterModelType)userType
{
    self = [super init];
    if (self) {
//        [self setUpUserRowInfos];
    }
    return self;
}

- (void)obtainUserDataFinished:(LKFinishedBlock)finished failed:(LKFailedBlock)failed {
    NSString *customerNumber = [NSString stringValue:[LKUserInfoUtils getUserNumber]];
     @weakify(self);
    [self requestDataWithParams:@{@"customerNumber":customerNumber} forPath:@"tx/cif/customer/page" httpMethod:LKRequestMethodPOST finished:^(LKBaseModel *item, LKResult *response) {
        @strongify(self);
        [self modelSetWithDictionary:response.data[@"data"]];
        if ([self.customerType integerValue]==1) { // 下游用户
            [self setDownUserRowInfos];
        } else {
           [self setUpUserRowInfos];
        }

        finished(self,response);
    } failed:^(LKBaseModel *item, NSError *error) {
        failed(self,error);
    }];
}

// 上游用户信息
- (void)setUpUserRowInfos {
    LKCenterSectionModel *section1 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row1 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_authentication" title:@"认证" desc:@"未认证" rowType:LKCenterRowType_certify];
    if (self.carStatus==1) {
        row1.desc = @"已认证";
    }
    LKCenterRowModel *row2 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_service" title:@"我的服务" desc:@"去发布" rowType:LKCenterRowType_myService];
    LKCenterRowModel *row3 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_protocol" title:@"服务协议" desc:@"" rowType:LKCenterRowType_serviceProtocol];
    section1.rows = @[row1,row2,row3];
    
    
    LKCenterSectionModel *section2 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row4 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_Invitation" title:@"我的邀请码" desc:@"" rowType:LKCenterRowType_inviteCode];
    LKCenterRowModel *row5 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_list" title:@"邀请列表" desc:@"" rowType:LKCenterRowType_inviceList];
    section2.rows = @[row4,row5];
    
    LKCenterSectionModel *section3 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row6 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_phone" title:@"手机号码" desc:self.customerMobile rowType:LKCenterRowType_phone];
    LKCenterRowModel *row7 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_wechat" title:@"微信" desc:@"" rowType:LKCenterRowType_wechat];
    LKCenterRowModel *row8 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_facebook" title:@"Facebook" desc:@"" rowType:LKCenterRowType_facebook];
    section3.rows = @[row6,row7,row8];
    
    self.sections = @[section1,section2,section3];
}

// 下游用户信息
- (void)setDownUserRowInfos {
    LKCenterSectionModel *section1 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row1 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_wish" title:@"心愿单" desc:@"" rowType:LKCenterRowType_wish];
    LKCenterRowModel *row2 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_protocol" title:@"服务协议" desc:@"" rowType:LKCenterRowType_serviceProtocol];
    section1.rows = @[row1,row2];
    
    
    LKCenterSectionModel *section2 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row4 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_Invitation" title:@"我的邀请码" desc:self.prsCode rowType:LKCenterRowType_inviteCode];
    LKCenterRowModel *row5 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_list" title:@"邀请列表" desc:@"" rowType:LKCenterRowType_inviceList];
    section2.rows = @[row4,row5];
    
    LKCenterSectionModel *section3 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row6 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_phone" title:@"手机号码" desc:self.customerMobile rowType:LKCenterRowType_phone];
    LKCenterRowModel *row7 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_wechat" title:@"微信" desc:@"" rowType:LKCenterRowType_wechat];
    LKCenterRowModel *row8 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_facebook" title:@"Facebook" desc:@"" rowType:LKCenterRowType_facebook];
    section3.rows = @[row6,row7,row8];
    
    
    LKCenterSectionModel *section4 = [[LKCenterSectionModel alloc] init];
    LKCenterRowModel *row9 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_travels" title:@"我的游记" desc:@"" rowType:LKCenterRowType_myTravelList];
    LKCenterRowModel *row10 = [[LKCenterRowModel alloc] initWithIcon:@"img_my_answer" title:@"我的问答" desc:@"" rowType:LKCenterRowType_myAnswer];
    section4.rows = @[row9,row10];
    
    self.sections = @[section1,section2,section4,section3];
}

@end


@implementation LKCenterSectionModel

@end

@implementation LKCenterRowModel

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title desc:(NSString *)desc rowType:(LKCenterRowType)rowType{
    if (self = [super init]) {
        _icon = icon;
        _title = title;
        _desc = desc;
        _rowType = rowType;
    }
    return self;
}

@end
