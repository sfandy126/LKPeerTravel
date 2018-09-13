//
//  LKPersonInfoMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKPersonInfoMainView.h"
#import "LKPersonInfoCell.h"
#import "LKDatePickerView.h"

#import "LKUploadManager.h"
#import "LKSelectCityViewController.h"

@interface LKPersonInfoMainView ()<UITableViewDelegate,UITableViewDataSource,LKDatePickerViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) LKDatePickerView *datePickerView;
@end

@implementation LKPersonInfoMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[LKPersonInfoCell class] forCellReuseIdentifier:kLKPersonInfoCellIdentify];
    }
    return _tableView;
}

- (LKDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[LKDatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 264)];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.model.customerType.integerValue==1) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.model.customerType.integerValue==1) {
            return 6;
        }
        return 7;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LKPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKPersonInfoCellIdentify forIndexPath:indexPath];
    [cell configData:self.model indexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LKPersonInfoCell getCellHeight:self.model indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section==0) {
        if (row==0) { // 头像
            [self editAvater];
        } else if (row==1) { // 姓名
            [self editName];
        } else if (row==2) { // 性别
            [self editGentle];
        } else if (row==3) { // 年龄
            [self.datePickerView show];
        } else if (row==4) { // 语言 / 职业
            [self editLanguageOrJobType:self.model.customerType.integerValue];

        } else if (row==5) { // 城市 / 语言
            if (self.model.customerType.integerValue==1) {
                [self editCity];
            } else {
                [self editLanguageOrJobType:1];
            }
        } else if (row==6) { // 城市
            [self editCity];
        }
    } else {
        if (row==0) { // 特长
            [self editLanguageOrJobType:3];
        } else if (row==1) { // 录音
            [self addRecord];
        } else if (row==2) { // 自我介绍
            [self editDesc];
        }
    }
}

- (void)editAvater {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     @weakify(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LKImagePicker getPictureWithBlock:^(UIImage *image) {
            @strongify(self);
            [self uploadImage:image];
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LKImagePicker getCameraWithBlock:^(UIImage *image) {
            @strongify(self);
            [self uploadImage:image];
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];

    [self.lk_viewController presentViewController:alert animated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image {
     @weakify(self);
    [LKUploadManager uploadImage:image completeBlock:^(LKResult *ret, NSError *error) {
        @strongify(self);
        if (ret.success) {
            NSString *url = ret.data[@"data"];
            if (url.length) {
                self.model.portraitPic = url;
            }
           [self finishedEdit];
        }
    }];
}

// 编辑昵称
- (void)editName {
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_nickname title:@"编辑昵称"];
     @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            self.model.customerName = inputStr;
        } else {
            self.model.customerNm = inputStr;
        }
        [self finishedEdit];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

// 编辑性别
- (void)editGentle {
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_gentle title:@"编辑性别"];
     @weakify(self);
    vc.gentleBlock = ^(NSInteger type) {
        @strongify(self);
        self.model.gender = [NSString stringWithFormat:@"%ld",(long)type];
        [self finishedEdit];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

/// 编辑语言/职业 1 语言 2 职业 3 特长
- (void)editLanguageOrJobType:(NSInteger)type {
    LKDialogType dialog = LKDialogType_language;
    NSString *title = @"选择语言";
    if (type==2) {
        dialog = LKDialogType_job;
        title = @"选择职业";
    } else if (type==3) {
        dialog = LKDialogType_hobby;
        title = @"选择特长";
    }
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:dialog title:title];
     @weakify(self);
    vc.selectedLanguageBlock = ^(NSArray *datas) {
        @strongify(self);
        NSString *type = @"1";
        NSMutableArray *temp = [NSMutableArray array];
        
        for (NSDictionary *dict in datas) {
            NSDictionary *info = @{@"labelName":[NSString stringValue:dict[@"codLabelName"]],@"labelNo":[NSString stringValue:dict[@"codLabelNo"]]};
            [temp addObject:info];
        }
        if (dialog==LKDialogType_job) {
            self.model.job = datas;
            type = @"3";
        } else if (dialog==LKDialogType_language) {
            self.model.language = datas;
            type = @"2";
        } else if (dialog==LKDialogType_hobby) {
            self.model.hobby = datas;
            type = @"1";
        }
        [LKHttpClient POST:@"tx/cif/customer/saveLable" parameters:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"labelType":type,@"labes":[temp modelToJSONObject]} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
//        [self finishedEdit];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

/// 编辑城市
- (void)editCity {
    LKSelectCityViewController *vc = [[LKSelectCityViewController alloc] init];
    vc.isChoose = YES;
    
     @weakify(self);
    vc.selectCityBlock = ^(NSString *city_id, NSString *city_name) {
        @strongify(self);
        if (city_id.length>0) {
            self.model.city = city_id;
            self.model.cityName = city_name;
            [self finishedEdit];
        }
    };
    [LKMediator pushViewController:vc animated:YES];
}

/// 自我介绍
- (void)editDesc {
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_desc title:@"输入自我介绍"];
     @weakify(self);
    vc.sureBlock = ^(NSString *inputStr) {
        @strongify(self);
        self.model.txtDesc = inputStr;
        [self finishedEdit];
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}

/// 添加录音
- (void)addRecord {
    LKDialogViewController *vc = [LKDialogViewController alertWithDialogType:LKDialogType_record title:@"更新语音介绍"];
     @weakify(self);
    vc.recordFinishBlock = ^(NSString *recordUrl) {
        @strongify(self);
        NSData *data = [NSData dataWithContentsOfFile:recordUrl];
        if (data) {
            [LKUploadManager uploadData:data completeBlock:^(LKResult *ret, NSError *error) {
                @strongify(self);
                self.model.speechIntroduction = [NSString stringValue:ret.data[@"data"]];
                [self finishedEdit];
            }];
        }
    };
    [self.lk_viewController presentViewController:vc animated:YES completion:nil];
}


- (void)doneLoading{
    [self.tableView reloadData];
}

- (void)finishedEdit {
    [self.tableView reloadData];
    NSMutableDictionary *parar = [NSMutableDictionary dictionary];
    [parar setValue:[LKUserInfoUtils getUserNumber] forKey:@"customerNumber"];
    [parar setValue:self.model.customerName forKey:@"customerName"];
    [parar setValue:[LKUserInfoUtils getUserType]==LKUserType_Traveler?@"1":@"2" forKey:@"customerType"];
    [parar setValue:self.model.portraitPic forKey:@"portraitPic"];
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        [parar setValue:self.model.customerName forKey:@"customerName"];
    } else {
        [parar setValue:self.model.customerNm forKey:@"customerNm"];
        
    }
    [parar setValue:self.model.customerMobile forKey:@"customerMobile"];
    [parar setValue:self.model.icType forKey:@"icType"];
    [parar setValue:self.model.icNo forKey:@"icNo"];
    [parar setValue:@(self.model.age) forKey:@"age"];
    [parar setValue:self.model.city forKey:@"city"];
    [parar setValue:self.model.mail forKey:@"mail"];
    [parar setValue:self.model.maritalstatus forKey:@"maritalstatus"];
    [parar setValue:self.model.gender forKey:@"gender"];
    [parar setValue:self.model.status forKey:@"status"];
    [parar setValue:self.model.txtDesc forKey:@"txtDesc"];
    [parar setValue:self.model.txtRemark forKey:@"txtRemark"];
    [parar setValue:self.model.speechIntroduction forKey:@"speechIntroduction"];

    [parar setValue:self.model.rcmCode forKey:@"rcmCode"];
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        [parar setValue:self.model.rcmCode forKey:@"rcmCode"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:parar];
    [LKHttpClient POST:@"tx/cif/customer/maintenance" parameters:dict progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - LKDatePickerViewDelegate

- (void)clickSureBtn:(NSString *)age constellation:(NSString *)constellation birthday:(NSString *)birthday {
    self.model.age = [age integerValue];
    [self finishedEdit];
    [self.datePickerView hide];
}

@end
