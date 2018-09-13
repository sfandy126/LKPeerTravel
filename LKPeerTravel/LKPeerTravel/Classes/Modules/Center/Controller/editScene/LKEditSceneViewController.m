//
//  LKEditSceneViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKEditSceneViewController.h"

#import "LKEditSceneMainView.h"

#import "LKWishEditRowModel.h"
#import "LKEditSceneCellModel.h"

@interface LKEditSceneViewController ()

@property (nonatomic, strong) LKEditSceneMainView *mainView;
@property (nonatomic, strong) LKEditSceneModel *sceneModel;

@end

@implementation LKEditSceneViewController

- (LKEditSceneMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LKEditSceneMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight) model:self.sceneModel type:self.point_type];
    }
    return _mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [self setnaviTitle];
    
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 44, 44);
    [rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [rightBut setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBut.titleLabel.font = kBFont(14);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (self.scene_id) {
        [self loadSceneData];
    } else {
        [self.view addSubview:self.mainView];

    }
}

- (void)loadSceneData {
    [LKHttpClient POST:@"tx/cif/CosDestinationPoint/get" parameters:@{@"no":self.scene_id} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            self.sceneModel = [LKEditSceneModel modelWithDictionary:result.data[@"data"]];
            self.point_type = [self.sceneModel.pointType integerValue];
            [self setnaviTitle];
            [self.view addSubview:self.mainView];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)setnaviTitle {
    if (self.point_type==1) {
        self.title = @"编辑景点";
    } else if (self.point_type==2) {
        self.title = @"编辑商场";
    } else if (self.point_type==3) {
        self.title = @"编辑美食";
    }
}

- (void)rightAction {
    
    NSArray *rows = [self.mainView getRowContents];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *cityShow;
    NSString *descShow;
    
    for (int i=0; i<rows.count; i++) {
        LKWishEditRowModel *row = rows[i];
        if (i==0) {
            [params setObject:row.switchState?@"1":@"0" forKey:row.title_desc];
        } else if (i==1) {
            [params setObject:[NSString stringValue:row.city_id] forKey:row.title_desc];
            if ([NSString isEmptyStirng:row.city_id]) {
                cityShow = @"请选择城市";
            }
        } else if (i==2) {
            if ([NSString isEmptyStirng:row.desc]) {
                descShow = @"请输入景点名称";
            }
            [params setObject:[NSString stringValue:row.desc] forKey:row.title_desc];
        }
    }
    
    if (cityShow.length>0) {
        [LKUtils showMessage:cityShow];
        return;
    }
    
    if (descShow.length>0) {
        [LKUtils showMessage:descShow];
        return;
    }
    
    NSArray *contents = [self.mainView getSceneContents];
    
    if ([NSArray isEmptyArray:contents]) {
        [LKUtils showMessage:@"请添加景点介绍"];
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i=0; i<contents.count; i++) {
        NSMutableDictionary *scene =  [NSMutableDictionary dictionary];;

        LKEditSceneCellModel *model = contents[i];
        if (model.type==LKEditRowType_pic) {
            [scene setObject:[NSString stringValue:model.picurl] forKey:@"codImageUrl"];
        }
        if (model.type==LKEditRowType_text) {
            [scene setObject:[NSString stringValue:model.data] forKey:@"codDestination"];
        }
        [temp addObject:scene];
    }
    
    NSMutableArray *temp2 = [NSMutableArray array];
    
    for (NSDictionary *dict in temp) {
        [temp2 addObject:[dict modelToJSONObject]];
    }
    
    [params setObject:[temp2 modelToJSONObject ] forKey:@"cosDestinationImages"];
    
    [params setObject:@(self.point_type) forKey:@"pointType"];
    [params setObject:[LKUserInfoUtils getUserNumber] forKey:@"customerNumber"];
    [params setObject:self.sceneModel?self.sceneModel.codDestinationNo:@"" forKey:@"codDestinationPointNo"];
    
    [LKHttpClient POST:@"tx/cif/CosDestinationPoint/save" parameters:params progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            if (self.successAddBlock) {
                self.successAddBlock(result.data[@"data"]);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
