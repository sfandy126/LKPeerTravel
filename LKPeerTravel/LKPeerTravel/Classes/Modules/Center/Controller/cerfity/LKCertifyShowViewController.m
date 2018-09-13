//
//  LKCertifyLookViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKCertifyShowViewController.h"

#import "LKCertifyShowCell.h"

#import "UIImage+RemoteSize.h"

static NSString *cellID = @"LKCertifyShowCell";

@interface LKCertifyShowViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation LKCertifyShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEdit) {
        self.title = @"身份认证";
        LKCertifyShowModel *model1 = [LKCertifyShowModel new];
        model1.title = @"身份证正面";
        
        LKCertifyShowModel *model2 = [LKCertifyShowModel new];
        model2.title = @"身份证反面";
        
        LKCertifyShowModel *model3 = [LKCertifyShowModel new];
        model3.title = @"手持身份证";
        
        self.datas = @[model1,model2,model3];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:kColorYellow1 forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 44, 44);
        btn.titleLabel.font = kFont(14);
        [btn addTarget:self action:@selector(commitCertity) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    } else {
        self.title = @"认证查看";
        [self loadData];
    }
    
    [self.view addSubview:self.tableView];
}

- (void)loadData {
     @weakify(self);
    [LKHttpClient POST:@"tx/cif/CifCustomerAuth/get" parameters:@{} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);;
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            LKCertifyShowModel *model1 = [LKCertifyShowModel new];
            model1.title = @"身份证正面";
            model1.url = result.data[@"data"][@"carNoPositive"];
            
            LKCertifyShowModel *model2 = [LKCertifyShowModel new];
            model2.title = @"身份证反面";
            model2.url = result.data[@"data"][@"carNoReverse"];
            
            LKCertifyShowModel *model3 = [LKCertifyShowModel new];
            model3.title = @"手持身份证";
            model3.url = result.data[@"data"][@"carNoMain"];

            self.datas = @[model1,model2,model3];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (LKCertifyShowModel *model in self.datas) {
                    CGSize size = [UIImage getImageSizeWithURL:model.url];
                    model.pic_width = [NSString stringWithFormat:@"%f",size.width];
                    model.pic_height = [NSString stringWithFormat:@"%f",size.height];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 提交认证

- (void)commitCertity {
 

    NSString *alert_msg;
    for (LKCertifyShowModel *model in self.datas) {
        if (model.alert_msg.length>0) {
            alert_msg = model.alert_msg;
            break;
        }
    }
    if (alert_msg) {
        [LKUtils showMessage:alert_msg];
        return;
    }
    LKCertifyShowModel *model0 = self.datas[0];
    LKCertifyShowModel *model1 = self.datas[1];
    LKCertifyShowModel *model2 = self.datas[2];
    
     @weakify(self);
    [LKHttpClient POST:@"tx/cif/CifCustomerAuth/save" parameters:@{@"carNoMain":model2.url,@"carNoPositive":model0.url,@"carNoReverse":model1.url} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            NSLog(@"上传成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKCertifyShowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    LKCertifyShowModel *dict = self.datas[indexPath.row];
    cell.model = dict;
     @weakify(self);
    cell.addPicFinished = ^{
        @strongify(self);
        [self.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKCertifyShowModel *data = self.datas[indexPath.row];
    CGFloat picHeight;
    if (data.url) {
        CGFloat width = [data.pic_width floatValue];
        CGFloat height = [data.pic_height floatValue];
        if (width>0 && height>0) {
            picHeight = (kScreenWidth-40)*height / width;
        } else {
            picHeight = 200;
        }
        
    } else {
        picHeight = 200;
    }
    return 18+ceil([UIFont boldSystemFontOfSize:14].lineHeight)+10+picHeight+2;
}



#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LKCertifyShowCell class] forCellReuseIdentifier:cellID];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    }
    return _tableView;
}

@end
