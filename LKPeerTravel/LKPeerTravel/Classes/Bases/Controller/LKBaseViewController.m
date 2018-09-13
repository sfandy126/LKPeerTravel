//
//  LKBaseViewController.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseViewController.h"
#import "LKLoadingManager.h"

@interface LKBaseViewController ()
@property (nonatomic,strong) LKLoadingManager *loadingTool;

@property (nonatomic, strong) UIView *loadingView;
@end

@implementation LKBaseViewController

- (void)dealloc{
    NSLog(@"%s %@",__func__,NSStringFromClass([self class]));
}

- (UIView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [UIColor whiteColor];
    }
    return _loadingView;
}
- (LKLoadingManager *)loadingTool{
    if (!_loadingTool) {
        _loadingTool = [[LKLoadingManager alloc] init];
    }
    return _loadingTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    if (kSystemVersion>=11.0) {
        // AppDelegate 进行全局设置
        if (@available(iOS 11.0, *)){
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
            
            [UITableView appearance].estimatedRowHeight = 0;
            [UITableView appearance].estimatedSectionHeaderHeight = 0;
            [UITableView appearance].estimatedSectionFooterHeight = 0;
            [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            [UICollectionView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置返回按钮
    [self performSelector:@selector(setBackBtn) withObject:nil];
}


///显示加载动画
- (void)showLoadingView{
    [self.loadingTool layoutInView:self.view];
    [self.loadingTool showAnimation:LKLoadingAnimationType_Jump];
}

///隐藏加载动画
- (void)hideLoadingView{
    [self.loadingTool hide];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {

}


@end
