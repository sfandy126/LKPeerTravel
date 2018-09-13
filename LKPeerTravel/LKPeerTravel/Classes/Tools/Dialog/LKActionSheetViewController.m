//
//  LKActionSheetViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKActionSheetViewController.h"

#import "LKActionSheetDelegate.h"

@interface LKActionSheetViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) LKActionSheetDelegate *animator;
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIButton *cancelBtn;

@property (nonatomic, strong) NSString *titleString;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation LKActionSheetViewController



- (instancetype)initWithItems:(NSArray<NSString *> *)items delegate:(id<LKActionSheetViewControllerDelegate>)delegate {
    self = [super init];
    self.items = items;
    self.delegate = delegate;
    
    _animator = [[LKActionSheetDelegate alloc] init];
    
    CGFloat x = 0;
    NSInteger count = items.count;
    CGFloat height = 55 + 55 * count;
    if (kScreenHeight > 800) {
        height += 34;
    }
    _animator.presentFrame = CGRectMake(x, kScreenHeight - height, kScreenWidth, height);
    _animator.unClickDismiss = NO;
    _contentHeight = height;
    self.transitioningDelegate = self.animator;
    self.modalPresentationStyle = UIModalPresentationCustom;
    return self;
}

- (instancetype)initWithItems:(NSArray<NSString *> *)items title:(NSString *)title delegate:(id<LKActionSheetViewControllerDelegate>)delegate {
    self = [super init];
    self.items = items;
    self.delegate = delegate;
    self.titleString = title;
    _animator = [[LKActionSheetDelegate alloc] init];
    
    CGFloat x = 0;
    NSInteger count = items.count;
    CGFloat height = 55 + 55 * count + 33;
    if (kScreenHeight > 800) {
        height += 34;
    }
    _contentHeight = height;
    _animator.presentFrame = CGRectMake(x, kScreenHeight - height, kScreenWidth, height);
    _animator.unClickDismiss = NO;
    self.transitioningDelegate = self.animator;
    self.modalPresentationStyle = UIModalPresentationCustom;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    if (self.titleString.length) {
        self.titleLabel.text = self.titleString;
        self.tableView.tableHeaderView = self.titleLabel;
    }
    self.tableView.tableFooterView = self.cancelBtn;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self.view layoutIfNeeded];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JKRACTIONSHEETCELL"];
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textColor = kColorGray1;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.delegate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.delegate actionSheetController:self didClickIndex:indexPath.row];
            });
        }
    }];
}

- (void)cancelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFont(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kColorGray1;
        _titleLabel.frame = CGRectMake(0, 0, kScreenWidth, 33);
    }
    return _titleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _contentHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 55;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = kFont(16);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColorGray2 forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(0, 0, kScreenWidth, 55);
        [_cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
