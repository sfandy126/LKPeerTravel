//
//  LKSceneDetailViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKSceneDetailViewController.h"

#import "LKSceneDetailCell.h"

#import "LKSceneDetailModel.h"

#import "UIImage+RemoteSize.h"

@interface LKSceneDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LKSceneDetailModel *model;
@property (nonatomic, strong) UIButton *rightBtn;

@end

static NSString *cellID = @"LKSceneDetailCell";

@implementation LKSceneDetailViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = TableBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LKSceneDetailCell class] forCellReuseIdentifier:cellID];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    [self.view addSubview:self.tableView];
    
    if (self.is_choose) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setImage:[UIImage imageNamed:@"btn_service_determine_none"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_service_determine_pressed"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(rigtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.rightBtn = btn;
    }
    [self loadData];
}

- (void)rigtnBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)back {
    if (self.is_choose && self.rightBtn.selected) {
        if (self.finishedSelectedBlock) {
            self.finishedSelectedBlock([self.model modelToJSONObject]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
     @weakify(self);
    [LKHttpClient POST:@"tx/cif/CosDestinationPoint/get" parameters:@{@"no":[NSString stringValue:self.scene_no]} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);;
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            self.model = [LKSceneDetailModel modelWithDictionary:result.data[@"data"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (LKSceneDetailPicModel *picModel in self.model.images) {
                    CGSize size = [UIImage getImageSizeWithURL:picModel.codImageUrl];
                    picModel.pic_width = size.width;
                    picModel.pic_height = size.height;
                    
                    CGSize textSize = [LKUtils sizeFit:picModel.txtImageDesc withUIFont:kFont(16) withFitWidth:kScreenWidth-40 withFitHeight:MAXFLOAT];
                    picModel.test_height = textSize.height;
                    
                    CGFloat cellHeight = 0;
                    if (picModel.codImageUrl.length) {
                        cellHeight += 20 + (kScreenWidth-40)*size.height / size.width;
                    }
                    
                    if (picModel.txtImageDesc.length>0) {
                        cellHeight += 20 + textSize.height+20;
                    }
                    
                    picModel.cell_height = cellHeight;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = self.model.codDestinationPointName;
                    [self.tableView reloadData];
                });
            });
           
          
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKSceneDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    LKSceneDetailPicModel *picModel = [self.model.images objectAt:indexPath.row];
    cell.picModel = picModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LKSceneDetailPicModel *picModel = [self.model.images objectAt:indexPath.row];
    return picModel.cell_height;
}

@end
