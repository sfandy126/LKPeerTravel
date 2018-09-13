//
//  LKWelcomeViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKWelcomeViewController.h"
#import <SDCycleScrollView.h>

@interface LKWelcomeViewController ()
@property (nonatomic,strong) UIButton *startBut;
@property (nonatomic,strong) SDCycleScrollView *cycleView;
@end

@implementation LKWelcomeViewController

- (UIButton *)startBut{
    if (!_startBut) {
        _startBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBut.frame = CGRectMake(0, 0, 100, 40);
        [_startBut setTitle:@"开始体验" forState:UIControlStateNormal];
        [_startBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startBut.titleLabel.font = kBFont(14);
        _startBut.backgroundColor = [UIColor colorWithHexString:@"#FED631"];
        [_startBut addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBut;
}

- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) imageURLStringsGroup:nil];
        _cycleView.infiniteLoop = NO;
        _cycleView.autoScrollTimeInterval = 2;
        _cycleView.showPageControl = NO;
        _cycleView.hidesForSinglePage = YES;
        @weakify(self);
        _cycleView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
            @strongify(self);
            if (currentIndex>0 && currentIndex == (_cycleView.localizationImageNamesGroup.count-1)) {//imageURLStringsGroup
                self.startBut.alpha = 1;
            }
        };
    }
    return _cycleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.cycleView.imageURLStringsGroup = @[@"https://img.zcool.cn/community/01fa1658d1f5cba801219c77b3bba8.jpg",
//                                            @"https://img.zcool.cn/community/01fa1658d1f5cba801219c77b3bba8.jpg"];
    self.cycleView.localizationImageNamesGroup = @[@"img_welcome_1",@"img_welcome_2",@"img_welcome_3"];
    [self.view addSubview:self.cycleView];

    self.startBut.centerX = self.view.width/2.0;
    self.startBut.bottom = self.view.height - 80;
    self.startBut.alpha = 0;
    [self.view addSubview:self.startBut];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)startAction{
    [LKMediator openLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
