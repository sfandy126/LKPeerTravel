//
//  LKOrderDetailFootView.m
//  LKPeerTravel
//
//  Created by CK on 2018/7/17.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailFootView.h"

@interface LKOrderDetailFootView ()
@property (nonatomic,strong) UIButton *startBut;
@property (nonatomic,strong) UIButton *cancleBut;

@end

@implementation LKOrderDetailFootView

{
    DetailOperationType _type;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_order_table"]];
        iv.frame = self.bounds;
        [self addSubview:iv];
        
    
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 80, 34);
        [btn setBackgroundImage:[[UIImage imageNamed:@"btn_loading_code_none"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];

        btn.right = self.right-20;
        btn.bottom = self.height-10;
        _startBut = btn;
        
        
        //取消按钮
        _cancleBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBut.frame = CGRectMake(0, 0, 80,34);
        _cancleBut.right = _startBut.left-10;
        _cancleBut.centerY = btn.centerY;
        [_cancleBut setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancleBut.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_cancleBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [_cancleBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancleBut.hidden = YES;
        
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_skip_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
        [_cancleBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_cancleBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
        [self addSubview:_cancleBut];
    }
    return self;
}

- (void)configData:(LKOrderDetailModel *)model{
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        [self configGuidState:model];
    } else {
        [self configTravelState:model];
    }
}

- (void)configGuidState:(LKOrderDetailModel *)model {
    NSString *title;
    DetailOperationType type = 0;
    if ([model.codOrderStatus isEqualToString:@"3"]) {
        title = @"确认订单";
        type = DetailOperationType_sure;
    }
    if ([model.codOrderStatus isEqualToString:@"4"]) {
        title = @"开始服务";
        type = DetailOperationType_service;
    }
    if ([model.codOrderStatus isEqualToString:@"-1"]) {

    }
    if ([model.codOrderStatus isEqualToString:@"2"]) {
        if (model.commentFlag==1) {
            if (model.replayFlag==1) {
                
            } else {
                title = @"去回复";
                type = DetailOperationType_reply;
            }
        } else {
            _startBut.hidden = YES;
        }
    }
    _type = type;
    [_startBut setTitle:title forState:UIControlStateNormal];
}

- (void)configTravelState:(LKOrderDetailModel *)model {
    NSString *title;
    DetailOperationType type = 0;
    if ([model.codOrderStatus isEqualToString:@"0"]) { // 待支付
        title = @"去支付";
        _cancleBut.hidden = NO;
        type = DetailOperationType_pay;
    }
    if ([model.codOrderStatus isEqualToString:@"1"]) { // 已支付
        title = @"联系客服";
        _cancleBut.hidden = NO;
        type = DetailOperationType_kefu;
    }
    if ([model.codOrderStatus isEqualToString:@"-1"]) { // 已取消
        title = @"再次预定";
        _cancleBut.hidden = YES;
        type = DetailOperationType_rebook;
    }
    if ([model.codOrderStatus isEqualToString:@"4"]) { // 已确认
        title = @"联系客服";
        _cancleBut.hidden = NO;
        type = DetailOperationType_kefu;
    }
    if ([model.codOrderStatus isEqualToString:@"3"]){ // 待确认
        title = @"取消订单";
        _cancleBut.hidden = YES;
        UIImage *bgImage =[UIImage imageNamed:@"btn_loading_skip_none"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
        [_startBut setBackgroundImage:bgImage forState:UIControlStateNormal];
        [_startBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
        type = DetailOperationType_cancel;
    }
    if ([model.codOrderStatus isEqualToString:@"5"]) {
        title = @"完成";
        type = DetailOperationType_complete;
    }
    if ([model.codOrderStatus isEqualToString:@"2"]) { // 已完成
        if (model.commentFlag==1) {
            title = @"再次预定";
            type = DetailOperationType_rebook;
        } else {
            title = @"去评价";
            type = DetailOperationType_comment;
        }
    } else {
        
    }
    [_startBut setTitle:title forState:UIControlStateNormal];
    
    _type = type;
//    [self operationWithType:type];
}



- (void)operationWithType:(DetailOperationType)type {
    if ([self.mainView.delegate respondsToSelector:@selector(stateOperationWithType:)]) {
        [self.mainView.delegate stateOperationWithType:type];
    }
}


- (void)cancelAction {
    [self operationWithType:DetailOperationType_cancel];
}

- (void)startAction {
    [self operationWithType:_type];
}

@end
