//
//  LKWishEditMainView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWishEditMainView.h"

#import "LKWishEditRowCell.h"
#import "LKWishEditMarkCell.h"

#import "LKSelectCityViewController.h"
#import "LKCalendarPickerViewController.h"

@interface LKWishEditMainView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;


@end


@implementation LKWishEditMainView



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LKWishEditRowCell class] forCellReuseIdentifier:LKWishEditRowCellReuseIndentifier];
        [_tableView registerClass:[LKWishEditMarkCell class] forCellReuseIdentifier:LKWishEditMarkCellReuseIdentifier];
    }
    return _tableView;
}

- (NSMutableArray *)selectedWishLabels {
    if (!_selectedWishLabels) {
        _selectedWishLabels = [NSMutableArray array];
    }
    return _selectedWishLabels;
}

- (void)setIsReEdit:(BOOL)isReEdit {
    _isReEdit = isReEdit;
    
    [self settingDataWithModel:_model];
 
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)settingDataWithModel:(LKWishListModel *)model {
    LKWishEditRowModel *row1 = [LKWishEditRowModel modelWithTitle:@"目的地" desc:model.codCityName showArrow:YES showSwitch:NO];
    _editModel.codCityNo = model.codCityNo;
    
    NSString *beginTime = [LKUtils dateToString:[NSDate dateWithTimeIntervalSince1970:model.beginTime] withDateFormat:@"yyyy-MM-dd"];
    NSString *endTime = [LKUtils dateToString:[NSDate dateWithTimeIntervalSince1970:model.endTime] withDateFormat:@"yyyy-MM-dd"];
    LKWishEditRowModel *row2 = [LKWishEditRowModel modelWithTitle:@"出行时间" desc:model?[NSString stringWithFormat:@"%@~%@",beginTime,endTime]:@"" showArrow:YES showSwitch:NO];
    _editModel.beginTime = beginTime;
    _editModel.endTime = endTime;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (LKWishLanguageInfo *info in model.languageList) {
        [temp addObject:[NSString stringValue:info.codLabelName]];
    }
    LKWishEditRowModel *row3 = [LKWishEditRowModel modelWithTitle:@"语言要求" desc:model?[temp componentsJoinedByString:@","]:@"" showArrow:YES showSwitch:NO];
    _editModel.language = model.language;
    
    LKWishEditRowModel *row4 = [LKWishEditRowModel modelWithTitle:@"同行人数" desc:model?[NSString stringWithFormat:@"%ld人",(long)model.codPeopleCount]:@"" showArrow:YES showSwitch:NO];
    _editModel.codPeopleCount = model.codPeopleCount;
    
    LKWishEditRowModel *row5 = [LKWishEditRowModel modelWithTitle:@"预算" desc:model?[NSString stringWithFormat:@"¥%ld元",(long)model.codBudgetAmount]:@"" showArrow:YES showSwitch:NO];
    _editModel.codBudgetAmount = model.codBudgetAmount;
    
    LKWishEditRowModel *row6 = [LKWishEditRowModel modelWithTitle:@"接机优先" desc:@"" showArrow:NO showSwitch:YES];
    row6.switchState = model?model.flagPickUp.boolValue:NO;
    _editModel.flagPickUp = model.flagPickUp;
    
    LKWishEditRowModel *row7 = [LKWishEditRowModel modelWithTitle:@"有车优先" desc:@"" showArrow:NO showSwitch:YES];
    _editModel.flgCar = model.flgCar;
    row7.switchState = model?model.flgCar.boolValue:NO;
    
    self.datas = @[row1,row2,row3,row4,row5,row6,row7];
    
    
    for (LKWishEditRowModel *model in self.datas) {
        model.rowType = [self.datas indexOfObject:model]+1;
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 7;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section==0) {
        LKWishEditRowCell *cell = [tableView dequeueReusableCellWithIdentifier:LKWishEditRowCellReuseIndentifier];
        LKWishEditRowModel *model = self.datas[indexPath.row];
        cell.model = model;
         @weakify(self);
        cell.switchValueChanged = ^(BOOL on,LKWishEditRowModel *row) {
            @strongify(self);
            if ([row.title isEqualToString:@"接机优先"]) {
                self.editModel.flagPickUp = [NSString stringWithFormat:@"%@",@(on)];
            } else if ([row.title isEqualToString:@"有车优先"]) {
                self.editModel.flgCar = [NSString stringWithFormat:@"%@",@(on)];
            }
        };
        return cell;
    } else {
        LKWishEditMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:LKWishEditMarkCellReuseIdentifier];
        cell.tags = self.selectedWishLabels;
         @weakify(self);
        cell.addWishBlock = ^{
            @strongify(self);
            [self addWishLabel];
        };
        cell.deleteWishBlock = ^(NSDictionary *dict) {
            @strongify(self);
            [self.selectedWishLabels removeObject:dict];
            [self.tableView reloadData];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section==0) {
        LKWishEditRowModel *model = self.datas[indexPath.row];
        switch (model.rowType) {
            case LKWishEditRowType_language:
            {
                [self alertWithTitle:@"输入语言" type:LKDialogType_language model:model];
    
            }
                break;
            case LKWishEditRowType_money:
            {
                [self alertWithTitle:@"输入预算" type:LKDialogType_budget model:model];
            }
                break;
            case LKWishEditRowType_people:
            {
                  [self alertWithTitle:@"输入人数" type:LKDialogType_person model:model];
            }
                break;
            case LKWishEditRowType_destination:
            {
                LKSelectCityViewController *vc = [[LKSelectCityViewController alloc] init];
                vc.isChoose = YES;
                 @weakify(self);
                vc.selectCityBlock = ^(NSString *city_id, NSString *city_name) {
                    @strongify(self);
                    if (city_id.length>0) {
                        self.editModel.codCityNo = city_id;
                        model.desc = city_name;
                        [self.tableView reloadData];
                    }
                };
                [self.lk_viewController.navigationController pushViewController:vc animated:YES];
            }
                break;
            case LKWishEditRowType_time:
            {
                LKCalendarPickerViewController *vc = [[LKCalendarPickerViewController alloc] init];
                 @weakify(self);
                vc.selectCalendarBlock = ^(NSString *beginTime, NSString *endTime) {
                    @strongify(self);
                    self.editModel.beginTime = beginTime;
                    self.editModel.endTime = endTime;
                    model.desc = [NSString stringWithFormat:@"%@~%@",beginTime,endTime];
                    [self.tableView reloadData];
                };
                [self.lk_viewController presentViewController:vc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50;
    } else {
        return [LKWishEditMarkCell cellHeightWidthTags:self.selectedWishLabels];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (void)alertWithTitle:(NSString *)title type:(LKDialogType)type model:(LKWishEditRowModel *)model {
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:type title:title];
    @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        model.desc = inputStr;
        if (type==LKDialogType_budget) {
            self.editModel.codBudgetAmount = [inputStr floatValue];
        } else if (type==LKDialogType_person) {
            self.editModel.codPeopleCount = [inputStr integerValue];
        }
        [self.tableView reloadData];
    };
    vc.selectedLanguageBlock = ^(NSArray *datas) {
        @strongify(self);
        NSMutableArray *temp = [NSMutableArray array];
        NSMutableArray *temp2 = [NSMutableArray array];
        for (NSDictionary *dict in datas) {
            [temp addObject:dict[@"codLabelName"]];
            [temp2 addObject:dict[@"codLabelNo"]];
        }
        model.desc = [temp componentsJoinedByString:@","];
        self.editModel.language = [temp2 componentsJoinedByString:@","];
        NSLog(@"codLabelNo__%@",[temp2 componentsJoinedByString:@","]);
        [self.tableView reloadData];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

- (void)addWishLabel {
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_wishLabel title:@"添加心愿标签"];
     @weakify(self);
    vc.selectedLanguageBlock = ^(NSArray *datas) {
        @strongify(self);
        [self.selectedWishLabels addObjectsFromArray:datas];
        [self.tableView reloadData];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

@end
