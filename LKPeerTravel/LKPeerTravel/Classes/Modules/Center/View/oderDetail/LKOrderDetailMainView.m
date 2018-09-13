//
//  LKOrderDetailMainView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailMainView.h"

#import "LKOrderDetailUserInfoCell.h"
#import "LKOrderDetailServiceCell.h"
#import "LKOrderDetailOrderInfoCell.h"
#import "LKOrderDetailEvaluationCell.h"

#import "LKOrderDetailFootView.h"

#import "UIResponder+firstResponder.h"

@interface LKOrderDetailMainView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) LKOrderDetailFootView *footerView;

@end

@implementation LKOrderDetailMainView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
        
//        self.tableview.tableFooterView = self.footerView;
        
        [self addNoticeForKeyboard];
    }
    return self;
}

- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    UIView *firstResponder = [UIResponder lk_currentFirstResponder];
    if ([firstResponder isKindOfClass:NSClassFromString(@"UIImageView")]) {
        CGRect rect = [firstResponder convertRect:firstResponder.frame toView:self];
        NSLog(@"%@",NSStringFromCGRect(rect));
        
        //获取键盘高度，在不同设备上，以及中英文下是不同的
        CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = (rect.origin.y+rect.size.height
                          ) - (self.height - kbHeight);
        
        //    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
                self.top = -offset;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    //    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    self.top = 0;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
        _tableview.separatorColor = [UIColor clearColor];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        [_tableview registerClass:[LKOrderDetailUserInfoCell class] forCellReuseIdentifier:LKOrderDetailUserInfoCellReuseIndentifier];
        [_tableview registerClass:[LKOrderDetailServiceCell class] forCellReuseIdentifier:LKOrderDetailServiceCellReuseIndentifier];
        [_tableview registerClass:[LKOrderDetailOrderInfoCell class] forCellReuseIdentifier:LKOrderDetailOrderInfoCellReuseIndentifier];
        [_tableview registerClass:LKOrderDetailEvaluationCell.class forCellReuseIdentifier:kLKOrderDetailEvaluationCellReuseIndentifier];
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];

    }
    return _tableview;
}

- (LKOrderDetailFootView *)footerView{
    if (!_footerView) {
        _footerView = [[LKOrderDetailFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 62)];
        _footerView.mainView = self;
    }
    return _footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.server.model.codOrderStatus isEqualToString:@"2"]) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section==0) {
        if (row==0) {
            LKOrderDetailUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LKOrderDetailUserInfoCellReuseIndentifier forIndexPath:indexPath];
            [cell configData:self.server.model];
            return cell;
        } else if (row==1) {
            LKOrderDetailServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:LKOrderDetailServiceCellReuseIndentifier forIndexPath:indexPath];
            [cell configData:self.server.model];
            return cell;
        }
    }
    
    if (section==2) {
        LKOrderDetailEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:kLKOrderDetailEvaluationCellReuseIndentifier];
        cell.model = self.server.model;
        cell.mainView = self;
        return cell;
    }
    
    LKOrderDetailOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LKOrderDetailOrderInfoCellReuseIndentifier forIndexPath:indexPath];
    [cell configData:self.server.model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    NSInteger section = indexPath.section;
    
    if (section==0) {
        if (row==0) {
            return 148+15;
        } else if (row==1) {
            return self.server.model.serveHeight+10+ceil(kFont(14).lineHeight)+17+7;
        }
    }
    
    if (section==2) {
        return [LKOrderDetailEvaluationCell heightWithModel:self.server.model];
    }
    return 360+17+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)doneLoading{
    [self.tableview endRefreshing];
    
    [self.footerView configData:self.server.model];
    
    if ([self.server.model.codOrderStatus isEqualToString:@"2"]) {
        self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
    } else {
        self.tableview.tableFooterView = self.footerView;
    }
    [self.tableview reloadData];
    
}

@end
