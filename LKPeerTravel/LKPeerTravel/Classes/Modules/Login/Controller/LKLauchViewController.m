//
//  LKLauchViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/4.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKLauchViewController.h"

@interface LKLauchViewController ()

@property (nonatomic, strong) UIImageView *backgroundView;


@end

@implementation LKLauchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundView.frame = [UIScreen mainScreen].bounds;
    }
    return _backgroundView;
}



@end
