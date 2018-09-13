//
//  LKOderDetailViewController.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/15.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOderDetailViewController.h"
#import "LKOrderDetailMainView.h"
#import "LKOrderDetailServer.h"

@interface LKOderDetailViewController () <LKOrderDetailMainViewDelegate>
@property (nonatomic,strong) LKOrderDetailMainView *mainView;
@property (nonatomic,strong) LKOrderDetailServer *server;

@end

@implementation LKOderDetailViewController

- (void)setOrder_id:(NSString *)order_id{
    _order_id = order_id;
    self.server.order_id = order_id;
}

- (LKOrderDetailMainView *)mainView {
    if (!_mainView) {
        _mainView = [[LKOrderDetailMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationHeight)];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (LKOrderDetailServer *)server{
    if (!_server) {
        _server = [[LKOrderDetailServer alloc] init];
    }
    return _server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    self.mainView.server = self.server;
    [self.view addSubview:self.mainView];
    
    [self loadData];
}

- (void)loadData{
    [self showLoadingView];
    @weakify(self);
    [self.server obtainOrderDetailDataFinishedBlock:^(LKResult *item, BOOL isFinished) {
        @strongify(self);
        [self hideLoadingView];
        [self.mainView doneLoading];
        if (self.server.model.commentFlag) {
            [self loadCommentData];
        }
    } failedBlock:^(NSError *error) {
        [self hideLoadingView];
        [self.mainView doneLoading];
    }];
}

- (void)loadCommentData {
    LKPageInfo *page = [[LKPageInfo alloc] init];
    page.pageNum = 1;
    
    [LKHttpClient POST:@"tx/cif/OmsOrderComment/list" parameters:@{@"no":self.order_id,@"page":[page modelToJSONObject]} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        NSArray *lists = [NSArray getArray:result.data[@"dataList"]];
        NSDictionary *dict = [lists firstObject];
        for (NSDictionary *info in lists) {
            if ([[NSString stringValue:info[@"orderNo"]] isEqualToString:self.order_id]) {
                dict = info;
                break;
            }
        }
        
        self.server.model.commentDict = [dict copy];
        [self.mainView doneLoading];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark - LKOrderDetailMainViewDelegate

- (void)stateOperationWithType:(DetailOperationType)type {
    NSString *status = @"0";
    switch (type) {
        case DetailOperationType_cancel:
        {
            status = @"-1";
            [self updateOrderStatus:status];
        }
            break;
        case DetailOperationType_pay:
        {
            status = @"3";
            [self updateOrderStatus:status];
        }
            break;
        case DetailOperationType_sure:
        {
            status = @"4";
             [self updateOrderStatus:status];
        }
            break;
            case DetailOperationType_service:
        {
            status = @"5";
            [self updateOrderStatus:status];
        }
            break;
        case DetailOperationType_complete: {
            status = @"2";
            [self updateOrderStatus:status];
        }
            break;
        case DetailOperationType_comment:
        {
            [self openCommentOrReply:YES];
        }
            break;
        case DetailOperationType_reply:
        {
            [self openCommentOrReply:NO];
        }
            break;
        default:
            break;
    }
}

- (void)guideReplyWithInputStr:(NSString *)inputStr level:(NSInteger)level{
    NSDictionary *dict = self.server.model.commentDict;
    
    if ([LKUserInfoUtils getUserType]==LKUserType_Traveler) {
        [LKHttpClient POST:@"tx/cif/OmsOrderComment/save" parameters:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"level":[NSString stringWithFormat:@"%ld",level],@"orderNo":self.order_id,@"txtCommentContent":inputStr} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [self loadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        [LKHttpClient POST:@"tx/cif/OmsOrderComment/replay" parameters:@{@"commentNo":[NSString stringValue:dict[@"omsCommentNo"]],@"replayNumber":[NSString stringValue:[LKUserInfoUtils getUserNumber]],@"txtCommentContent":inputStr} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [self loadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
  
}


#pragma mark - action

- (void)updateOrderStatus:(NSString *)staus {
    [LKHttpClient POST:@"tx/cif/OmsOrderMast/updateStatus" parameters:@{@"no":[NSString stringValue:self.order_id],@"status":staus} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        LKResult *result = [[LKResult alloc] initWithDict:responseObject];
        if (result.success) {
            [self loadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)openCommentOrReply:(BOOL)isComment {
   
}

- (void)replyUrlStr:(NSString *)urlstr inputStr:(NSString *)inputstr {
}

- (void)commentUrlStr:(NSString *)urlstr inputStr:(NSString *)inputStr {
    [LKHttpClient POST:urlstr parameters:@{@"customerNumber":[LKUserInfoUtils getUserNumber],@"level":@"1.0",@"orderNo":self.order_id,@"txtCommentContent":inputStr} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self loadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
