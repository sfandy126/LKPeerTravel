//
//  LKSendTrackMainView.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSendTrackMainView.h"
#import "LKSendTrackInfoCell.h"
#import "LKSendTrackInputCell.h"
#import "LKSendTrackTrackCell.h"

#import "LKTrackOrderListViewController.h"

@interface LKSendTrackMainView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation LKSendTrackMainView

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
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[LKSendTrackInfoCell class] forCellReuseIdentifier:kLKSendTrackInfoCellIdentify];
        [_tableView registerClass:[LKSendTrackInputCell class] forCellReuseIdentifier:kLKSendTrackInputCellIdentify];
        [_tableView registerClass:[LKSendTrackTrackCell class] forCellReuseIdentifier:kLKSendTrackTrackCellIdentify];

    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        LKSendTrackInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSendTrackInfoCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model.infoModel];
        return cell;
    }
    if (indexPath.section==1) {
        LKSendTrackInputCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSendTrackInputCellIdentify forIndexPath:indexPath];
        [cell configData:self.server.model.infoModel];
        return cell;
    }
    if (indexPath.section==2) {
        LKSendTrackTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKSendTrackTrackCellIdentify forIndexPath:indexPath];
        cell.addImageBlock = ^(LKSendTrackAddModel *item) {
            [self addImage:item];
        };
        [cell configData:self.server.model.addItems];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [LKSendTrackInfoCell getCellHeight:nil];
    }
    if (indexPath.section==1) {
        return [LKSendTrackInputCell getCellHeight:nil];
    }
    if (indexPath.section==2) {
        return [LKSendTrackTrackCell getCellHeight:self.server.model.addItems];
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        LKTrackOrderListViewController *orderList = [[LKTrackOrderListViewController alloc] init];
        orderList.selectedOrderNo = self.server.model.infoModel.orderNo;
        orderList.selectedBlock = ^(NSDictionary *data) {
            self.server.model.infoModel.orderNo = [NSString stringValue:[data valueForKey:@"orderNo"]];
            self.server.model.infoModel.guider = [NSString stringValue:[data valueForKey:@"guider"]];
            self.server.model.infoModel.travelTime = [NSString stringValue:[data valueForKey:@"travelTime"]];
            self.server.model.infoModel.travelCity = [NSString stringValue:[data valueForKey:@"travelCity"]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.vc.navigationController pushViewController:orderList animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    LKSendTrackInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell && [cell isKindOfClass:[LKSendTrackInputCell class]]) {
        [cell resignTextFieldFirstResponder];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    LKSendTrackInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell && [cell isKindOfClass:[LKSendTrackInputCell class]]) {
        [cell resignTextFieldFirstResponder];
    }
}

///添加图片
- (void)addImage:(LKSendTrackAddModel *)item{
    ///新增一个add
    LKSendTrackAddModel *addItem = [LKSendTrackAddModel new];
    addItem.is_add = YES;
    addItem.itemIndex = self.server.model.addItems.count;
    [addItem calculateLayoutViewFrame];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.server.model.addItems];
    [temp addObject:addItem];
    
    self.server.model.addItems = [NSArray getArray:[temp copy]];
    [self doneLoading];
    [self uploadImage:item];
    [self addContent:item];
}

///添加图片描述
- (void)addContent:(LKSendTrackAddModel *)item{
    LKDialogViewController *dialog =[LKDialogViewController alertWithDialogType:LKDialogType_desc title:@"请输入图片描述"];
    dialog.sureBlock = ^(NSString *inputStr) {
        item.content = inputStr;
        [item calculateLayoutViewFrame];
        [self doneLoading];
    };
    [self.vc presentViewController:dialog animated:YES completion:nil];
}

///上传图片
- (void)uploadImage:(LKSendTrackAddModel *)item{
    item.uploadProcess = LKImageUploadProccess_uploading;
    [LKUploadManager uploadImage:item.city_image completeBlock:^(id ret, NSError *error) {
        LKResult *result = (LKResult*)ret;
        if (!error && result.success) {
            NSLog(@"图片上传成功");
            NSDictionary *dict = [NSDictionary getDictonary:result.data];
            NSString *imageUrl = [NSString stringValue:[dict valueForKey:@"data"]];
            item.city_icon = imageUrl;
            item.uploadProcess = LKImageUploadProccess_finished;
        }else{
            NSLog(@"图片上传失败");
            [LKUtils showMessage:result.replyText];
            item.uploadProcess = LKImageUploadProccess_failed;
        }
    }];
}


- (void)doneLoading{
    [self.tableView endRefreshing];

    [self.tableView reloadData];
}


- (void)resignTextFieldFirstResponder{
    LKSendTrackInputCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell && [cell isKindOfClass:[LKSendTrackInputCell class]]) {
        [cell resignTextFieldFirstResponder];
    }
}
@end
