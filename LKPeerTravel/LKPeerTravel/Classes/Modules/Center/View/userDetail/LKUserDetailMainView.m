//
//  LKUserDetailMainView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUserDetailMainView.h"

#import "LKUserDetailHeaderView.h"
#import "LKUserDetailInfoCell.h"
#import "LKUserDetailServiceCell.h"
#import "LKUserDetailPhotoCell.h"
#import "LKUserDetailCanlenderCell.h"
#import "LKUserDetailServiceCell.h"

#import "LKUserDetalSectedPhotoCell.h"

@interface LKUserDetailMainView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LKUserDetailHeaderView *headerView;
@property (nonatomic, strong) LKUserDetailCanlenderCell *canlenderCell;
@property (nonatomic, strong) LKUserDetailServiceCell *serviceCell;

@property (nonatomic, strong) NSMutableArray *pointType1Arrary;
@property (nonatomic, strong) NSMutableArray *pointType2Arrary;
@property (nonatomic, strong) NSMutableArray *pointType3Arrary;

@end

@implementation LKUserDetailMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        
        LKUserDetailHeaderView *view = [[LKUserDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        self.tableView.tableHeaderView = view;
        self.headerView = view;
    }
    return self;
}

- (LKOrderEditModel *)editModel {
    if (!_editModel) {
        _editModel = [[LKOrderEditModel alloc] init];
        
    }
    return _editModel;
}

- (NSMutableArray *)selectedScenes {
    if (!_selectedScenes) {
        _selectedScenes = [NSMutableArray array];
    }
    return _selectedScenes;
}

- (NSMutableArray *)pointType1Arrary {
    if (!_pointType1Arrary) {
        _pointType1Arrary = [NSMutableArray array];
    }
    return _pointType1Arrary;
}

- (NSMutableArray *)pointType2Arrary {
    if (!_pointType2Arrary) {
        _pointType2Arrary = [NSMutableArray array];
    }
    return _pointType2Arrary;
}

- (NSMutableArray *)pointType3Arrary {
    if (!_pointType3Arrary) {
        _pointType3Arrary = [NSMutableArray array];
    }
    return _pointType3Arrary;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        [_tableView registerClass:[LKUserDetailInfoCell class] forCellReuseIdentifier:LKUserDetailInfoCellReuseIndentifier];
        [_tableView registerClass:[LKUserDetailServiceCell class] forCellReuseIdentifier:LKUserDetailServiceCellReuseIndentifier];
        [_tableView registerClass:[LKUserDetailPhotoCell class] forCellReuseIdentifier:LKUserDetailPhotoCellReuseIndentifier];
        [_tableView registerClass:[LKUserDetailCanlenderCell class] forCellReuseIdentifier:LKUserDetailCanlenderCellReuseIdentifier];
        [_tableView registerClass:LKUserDetalSectedPhotoCell.class forCellReuseIdentifier:LKUserDetalSectedPhotoCellCellReuseIndentifier];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (void)obtainEditData {
    self.editModel.no = [LKUserInfoUtils getUserNumber];
    self.editModel.serviceNo = self.serverModel.serviceNo;
    self.editModel.point = self.serverModel.point;
    NSMutableArray *temp1 = [NSMutableArray array];
    for (NSDictionary *dict in self.pointType1Arrary) {
        [temp1 addObject:@{@"codDestinationPointNo":[NSString stringValue:dict[@"codDestinationPointNo"]]}];
    }
    self.editModel.attractions = [NSArray arrayWithArray:temp1];
    NSMutableArray *temp2 = [NSMutableArray array];
    for (NSDictionary *dict in self.pointType2Arrary) {
        [temp2 addObject:@{@"codDestinationPointNo":[NSString stringValue:dict[@"codDestinationPointNo"]]}];
    }
    self.editModel.shopps = [NSArray arrayWithArray:temp2];
    NSMutableArray *temp3 = [NSMutableArray array];
    for (NSDictionary *dict in self.pointType3Arrary) {
        [temp3 addObject:@{@"codDestinationPointNo":[NSString stringValue:dict[@"codDestinationPointNo"]]}];
    }
    self.editModel.foods = [NSArray arrayWithArray:temp3];
    
    self.editModel.dNum = self.canlenderCell.days;
    self.editModel.dateStart = self.canlenderCell.beginDate;
    self.editModel.dateEnd = self.canlenderCell.endDate;
    
    self.editModel.discount = [self.serviceCell getPeopleDiscount];
    self.editModel.pNum = [self.serviceCell getPeopleNumber];
}

- (void)doneLoading {
    self.headerView.detailModel = self.model;
    
    [self.tableView reloadData];
}

- (void)finishAddScenes:(NSArray *)scenes pointType:(NSInteger)pointType {
    for (NSDictionary *dict in scenes) {
        if ([self.selectedScenes containsObject:dict]) {
            
        } else {
            [self.selectedScenes addObject:dict];
            if (pointType==1) {
                [self.pointType1Arrary addObject:dict];
            } else if (pointType==2) {
                [self.pointType2Arrary addObject:dict];
            } else if (pointType==3) {
                [self.pointType3Arrary addObject:dict];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)deleteScene:(NSDictionary *)dict {
    [self.selectedScenes removeObject:dict];
    
    if ([self.pointType1Arrary containsObject:dict]) {
        [self.pointType1Arrary removeObject:dict];
    }
    
    if ([self.pointType2Arrary containsObject:dict]) {
        [self.pointType2Arrary removeObject:dict];
    }
    
    if ([self.pointType3Arrary containsObject:dict]) {
        [self.pointType3Arrary removeObject:dict];
    }
 
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        return 3;
    }
    // 游客查看上游用户需要展示选择地点和日期选择
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    } else if (section==1) {
        return 1;
    } else if (section==2) {
        return 3;
    } else if (section==3) {
        return 1;
    } else if (section==4) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section==0) {
        LKUserDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LKUserDetailInfoCellReuseIndentifier];
        cell.detailModel = self.model;
        cell.mainView = self;
        return cell;
    } else if (section==1) {
        LKUserDetailServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:LKUserDetailServiceCellReuseIndentifier];
        cell.serverModel = self.serverModel;
        self.serviceCell = cell;
        return cell;
    } else if (section==2){
        LKUserDetailPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:LKUserDetailPhotoCellReuseIndentifier];
        cell.serverModel = self.serverModel;

        cell.cellType = indexPath.row+1;
        cell.mainView = self;
        return cell;
    } else if (section==3) {
        LKUserDetalSectedPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:LKUserDetalSectedPhotoCellCellReuseIndentifier];
         @weakify(self);
        cell.deleteItemBlock = ^(NSDictionary *item) {
            @strongify(self);
            [self deleteScene:item];
        };
        cell.scenes = self.selectedScenes;
        return cell;
    }
    else {
        LKUserDetailCanlenderCell *cell = [tableView dequeueReusableCellWithIdentifier:LKUserDetailCanlenderCellReuseIdentifier];
        cell.serverModel = self.serverModel;
        cell.mainView = self;
        self.canlenderCell = cell;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section==0) {
        return [LKUserDetailInfoCell heightWithModel:self.model];
    } else if (section==1) {
        return [LKUserDetailServiceCell heightWithModel:self.serverModel];
    } else if (section==2){
        return [LKUserDetailPhotoCell heightWithModel:self.serverModel];
    } else if (section==3) {
        return [LKUserDetalSectedPhotoCell heightWithScenes:self.selectedScenes];
    }
    else {
        return [LKUserDetailCanlenderCell heightWithModel:self.serverModel];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainViewDidScroll:)]) {
        [self.delegate mainViewDidScroll:scrollView.contentOffset];
    }
}

@end
