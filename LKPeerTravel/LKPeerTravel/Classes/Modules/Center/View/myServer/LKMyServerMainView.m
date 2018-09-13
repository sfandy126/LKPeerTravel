//
//  LKMyServerMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKMyServerMainView.h"
#import "LKMyServerInfoCell.h"
#import "LKMyServerSceneCell.h"
#import "LKMyServerDateCell.h"


@interface LKMyServerMainView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *datalists;
@property (nonatomic,strong) LKMyServerInfoCell *discountCell;
@property (nonatomic,strong) LKMyServerDateCell *dateCell;


@end

@implementation LKMyServerMainView

- (LKEditServerModel *)editModel {
    if (!_editModel) {
        _editModel = [[LKEditServerModel alloc] init];
    }
    return _editModel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
    }
    return self;
}

- (void)complishEdit {
    NSString *message;
    if (self.server.model.point) {
        self.editModel.point = [self.server.model.point doubleValue];
    } else {
        message = @"请输入价格";
    }
    if (self.server.model.pmax) {
        self.editModel.pmax = [self.server.model.pmax integerValue];
    } else {
        message = @"请输入服务人数";
    }
    self.editModel.flagCar = self.server.model.flagCar?@"1":@"0";
    self.editModel.flagPlane = self.server.model.flagPlane?@"1":@"0";
    
    self.editModel.discounts = [self.discountCell obtainDiscoutData];
    
    self.editModel.dateSets = [self.dateCell getDateOffs];
    
    self.editModel.serviceNo = self.server.model.serviceNo;
    
    /// 景点
    NSMutableArray *temp1 = [NSMutableArray array];
    LKMyServerTypeModel *scene = [self.datalists objectAt:1];
    for (LKMyServerCityModel *city in scene.citys) {
        [temp1 addObject:[city.dict modelToJSONObject]];
    }
    self.editModel.attractions = [NSArray arrayWithArray:temp1];
    
    /// 美食
    NSMutableArray *temp2 = [NSMutableArray array];
    LKMyServerTypeModel *foods = [self.datalists objectAt:2];
    for (LKMyServerCityModel *city in foods.citys) {
        [temp2 addObject:[city.dict modelToJSONObject]];
    }
    self.editModel.foods = [NSArray arrayWithArray:temp2];
    
    /// 购物
    NSMutableArray *temp3 = [NSMutableArray array];
    LKMyServerTypeModel *shops = [self.datalists objectAt:3];
    for (LKMyServerCityModel *city in shops.citys) {
        [temp3 addObject:[city.dict modelToJSONObject]];
    }
    self.editModel.shopps = [NSArray arrayWithArray:temp3];
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.delegate = self;
        _tableview.dataSource =self;
        _tableview.tableFooterView = [UIView new];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerClass:[LKMyServerInfoCell class] forCellReuseIdentifier:kMyServerInfoCellIdentify];
        [_tableview registerClass:[LKMyServerSceneCell class] forCellReuseIdentifier:kMyServerSceneCellIdentify];
        [_tableview registerClass:[LKMyServerDateCell class] forCellReuseIdentifier:kMyServerDateCellIdentify];

    }
    return _tableview;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datalists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LKMyServerType cellType = [self.server getCellType:section];
    if (cellType == LKMyServerType_Info) {
        return 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKMyServerType cellType = [self.server getCellType:indexPath.section];
    if (cellType == LKMyServerType_Info) {
        LKMyServerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyServerInfoCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model indexPath:indexPath];
        if (indexPath.row==4) {
            self.discountCell = cell;
        }
        return cell;
    }
    
    if (cellType == LKMyServerType_scene || cellType == LKMyServerType_cate || cellType == LKMyServerType_shop) {
        LKMyServerSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyServerSceneCellIdentify forIndexPath:indexPath];
        cell.mainView = self;
        LKMyServerTypeModel *typeModel = [self.datalists objectAt:indexPath.section];
        [cell configData:typeModel indexPath:indexPath];
         @weakify(self);
        cell.deleteItemBlock = ^(LKMyServerCityModel *itemModel, LKMyServerTypeModel *typeModel) {
            @strongify(self);
            NSMutableArray *temp = [NSMutableArray arrayWithArray:typeModel.citys];
            [temp removeObject:itemModel];
            typeModel.citys = [NSArray arrayWithArray:temp];
            [self.tableview reloadData];
        };
        return cell;
    }

    if (cellType == LKMyServerType_date) {
        LKMyServerDateCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyServerDateCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model indexPath:indexPath];
        self.dateCell = cell;
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCellIdentify"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCellIdentify"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKMyServerType cellType = [self.server getCellType:indexPath.section];
    CGFloat cellHeight = CGFLOAT_MIN;
    if (cellType == LKMyServerType_Info) {
        cellHeight = [LKMyServerInfoCell getCellHeight:self.server.model indexPath:indexPath];
    }
    
    if (cellType == LKMyServerType_scene || cellType == LKMyServerType_cate || cellType == LKMyServerType_shop) {
        LKMyServerTypeModel *typeModel = [self.datalists objectAt:indexPath.section];
        cellHeight = [LKMyServerSceneCell getCellHeight:typeModel indexPath:indexPath];
    }
    
    if (cellType == LKMyServerType_date) {
        cellHeight = [LKMyServerDateCell getCellHeight:self.server.model indexPath:indexPath];
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LKMyServerType cellType = [self.server getCellType:indexPath.section];
    NSInteger row = indexPath.row;
    
    if (cellType==LKMyServerType_Info) {
        if (row==0||row==1) { // 价格 服务人数
            [self dialogWithRow:row];
        }
    }
}

- (void)dialogWithRow:(NSInteger)row {
    NSString *title = row==0?@"修改价格":@"修改服务人数";
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_person title:title];
     @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        if (row==0) {
            self.server.model.point = inputStr;
        } else {
            self.server.model.pmax = inputStr;
        }
        [self.tableview reloadData];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

- (void)doneLoading{
    [self.tableview endRefreshing];
    
    self.datalists = [NSArray getArray:self.server.cellLists];
    [self.tableview reloadData];
}


- (void)editSceneFinishedType:(NSInteger)editType data:(NSDictionary *)data {
    NSInteger index = 1;
    if (editType==1) {
        index = 1;
    } else if (editType==2) {
        index = 3;
    } else if (editType==3) {
        index = 2;
    }
    LKMyServerTypeModel *model = [self.datalists objectAt:index];
    if (model && [model isKindOfClass:LKMyServerTypeModel.class]) {
        NSMutableArray *shops = [NSMutableArray arrayWithArray:model.citys];
        LKMyServerCityModel *city = [LKMyServerCityModel modelWithDict:data];
        [shops addObject:city];
        model.citys = [NSArray arrayWithArray:shops];
        
        [model refreshItemHeight];
        
        [self.tableview reloadData];
    }
}

@end
