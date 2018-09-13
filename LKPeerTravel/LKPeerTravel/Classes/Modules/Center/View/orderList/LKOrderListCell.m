//
//  LKOrderListCell.m
//  LKPeerTravel
//
//  Created by CK on 2018/6/12.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderListCell.h"
#import "LKOrderListShopsView.h"

///头部高度
#define kheaderHeight 70.0
///头部高度
#define kfooterHeight 55.0


@class LKOrderListHeaderView,LKOrderListFootView;
@interface LKOrderListCell ()
@property (nonatomic,strong) LKOrderListHeaderView *headerView;
@property (nonatomic,strong) LKOrderListShopsView *shopView;
@property (nonatomic,strong) LKOrderListFootView *footerView;

@end

@implementation LKOrderListCell

- (void)createView{
    [super createView];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    //头部
    _headerView = [[LKOrderListHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kheaderHeight)];
    [self.contentView addSubview:_headerView];
    
    //商品
    _shopView = [[LKOrderListShopsView alloc] initWithFrame:CGRectMake(0, _headerView.bottom, kScreenWidth, 0)];
    [self.contentView addSubview:_shopView];
    
    //尾部
    _footerView = [[LKOrderListFootView alloc] initWithFrame:CGRectMake(0, _shopView.bottom, kScreenWidth, kfooterHeight)];
    [self.contentView addSubview:_footerView];

}

- (void)configData:(LKOrderListModel *)model{
    //头部
    [_headerView configData:model];
    //商品
    [_shopView configData:model];
    //尾部
    [_footerView configData:model];
    _footerView.top = _shopView.bottom;
    @weakify(self);
    _footerView.clickedStateHandleBlock = ^(LKOrderListModel *item, LKOrderHandleType handleType) {
        @strongify(self);
        if (self.clickedStateHandleBlock) {
            self.clickedStateHandleBlock(item, handleType);
        }
    };
}


+ (CGFloat)getCellHeight:(id)data{
    if (data && [data isKindOfClass:[LKOrderListModel class]]) {
        LKOrderListModel *model = (LKOrderListModel*)data;
        return kheaderHeight +kfooterHeight +(ceil(kFont(12).lineHeight) +titleTop+titleAndCollectionInval +model.shopsHeight +collectionBottom);
    }
    return CGFLOAT_MIN;
}

@end


@interface LKOrderListHeaderView ()
@property (nonatomic,strong) UILabel *orderLab;
@property (nonatomic,strong) UILabel *startLab;
@property (nonatomic,strong) UILabel *stateLab;
@property (nonatomic,strong) UIImageView *stateIcon;
@end

@implementation LKOrderListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *orderDesLab = [[UILabel alloc] initWithFrame:CGRectZero];
    orderDesLab.text = @"订单编号";
    orderDesLab.textColor = [UIColor colorWithHexString:@"#333333"];
    orderDesLab.textAlignment = NSTextAlignmentCenter;
    orderDesLab.font = [UIFont systemFontOfSize:12.0];
    orderDesLab.left = 20;
    orderDesLab.top = 17;
    CGSize size = [LKUtils sizeFit:orderDesLab.text withUIFont:orderDesLab.font withFitWidth:100 withFitHeight:orderDesLab.height];
    orderDesLab.size = size;
    [self addSubview:orderDesLab];
    
    _orderLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _orderLab.text = @"";
    _orderLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _orderLab.textAlignment = NSTextAlignmentLeft;
    _orderLab.font = [UIFont boldSystemFontOfSize:12.0];
    _orderLab.left = orderDesLab.right +17;
    _orderLab.height = ceil(_orderLab.font.lineHeight);
    _orderLab.centerY = orderDesLab.centerY;
    [self addSubview:_orderLab];
    
    
    UILabel *startDesLab = [[UILabel alloc] initWithFrame:CGRectZero];
    startDesLab.text = @"出行时间";
    startDesLab.textColor = [UIColor colorWithHexString:@"#333333"];
    startDesLab.textAlignment = NSTextAlignmentCenter;
    startDesLab.font = [UIFont systemFontOfSize:12.0];
    startDesLab.left = orderDesLab.left;
    startDesLab.top = orderDesLab.bottom + 14;
    startDesLab.size = orderDesLab.size;
    [self addSubview:startDesLab];
    
    _startLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _startLab.text = @"";
    _startLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _startLab.textAlignment = NSTextAlignmentLeft;
    _startLab.font = [UIFont boldSystemFontOfSize:12.0];
    _startLab.left = _orderLab.left;
    _startLab.height = ceil(_startLab.font.lineHeight);
    _startLab.centerY = startDesLab.centerY;
    [self addSubview:_startLab];
    
    _stateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _stateLab.text = @"";
    _stateLab.textColor = [UIColor colorWithHexString:@"#ff584f"];
    _stateLab.textAlignment = NSTextAlignmentCenter;
    _stateLab.font = [UIFont systemFontOfSize:12.0];
    _stateLab.height = ceil(_stateLab.font.lineHeight);
    _stateLab.centerY = orderDesLab.centerY;
    [self addSubview:_stateLab];
    
    
    _stateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 203/3, 172/3)];
    _stateIcon.image = [UIImage imageNamed:@"img_visitor_completed"];
    _stateIcon.right = kScreenWidth - 20;
    _stateIcon.hidden = YES;
    [self addSubview:_stateIcon];
}

- (void)configData:(LKOrderListModel *)model{
    //订单编号
    _orderLab.text = model.order_display_id;
    CGSize numSize = [LKUtils sizeFit:_orderLab.text withUIFont:_orderLab.font withFitWidth:1000 withFitHeight:_orderLab.height];
    _orderLab.width = numSize.width;
    
    //出行时间
    _startLab.text = [NSString stringWithFormat:@"%@ 至 %@",model.start_time,model.end_time];
    CGSize startSize = [LKUtils sizeFit:_startLab.text withUIFont:_startLab.font withFitWidth:1000 withFitHeight:_startLab.height];
    _startLab.width = startSize.width;
    
    //订单状态
    _stateLab.text = [self getTitleWithState:model];
    CGSize stateSize = [LKUtils sizeFit:_stateLab.text withUIFont:_stateLab.font withFitWidth:1000 withFitHeight:_stateLab.height];
    _stateLab.width = stateSize.width;
    _stateLab.right = kScreenWidth - 20;
    
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        _stateLab.hidden = YES;
    }
    
    if ([model.order_state isEqualToString:@"2"]) {
        _stateIcon.hidden = NO;
        _stateLab.hidden = YES;
    } else {
        _stateIcon.hidden = YES;
    }
}

- (NSString *)getTitleWithState:(LKOrderListModel *)model{
    NSString *title = @"";
    NSString *order_state = model.order_state;
    if ([order_state isEqualToString:@"0"]) {
        title = @"待支付";
    }else if ([order_state isEqualToString:@"3"]){
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            title = @"等待确认";
        } else {
            title = @"等待对方确认";
        }
    }else if ([order_state isEqualToString:@"2"]){
        if (model.commentFlag) {
            title = @"";
        } else {
            title = @"待评价";}
    }else if ([order_state isEqualToString:@"-1"]){
        title = @"已取消";
    }else if ([order_state isEqualToString:@"4"]) {
        title = @"已确认";
    }
    return title;
}

@end

@interface LKOrderListFootView ()
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UIButton *stateBut;
@property (nonatomic,strong) UIButton *cancleBut;

@property (nonatomic,strong) LKOrderListModel *model;
@property (nonatomic,assign) LKOrderHandleType handleType;

@end

@implementation LKOrderListFootView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectZero];
    desLab.text = @"总价";
    desLab.textColor = [UIColor colorWithHexString:@"#333333"];
    desLab.textAlignment = NSTextAlignmentLeft;
    desLab.font = [UIFont systemFontOfSize:12.0];
    desLab.left = 20;
    CGSize size = [LKUtils sizeFit:desLab.text withUIFont:desLab.font withFitWidth:100 withFitHeight:desLab.height];
    desLab.size = size;
    desLab.centerY = self.height/2.0;
    [self addSubview:desLab];
    
    _priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLab.text = @"";
    _priceLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _priceLab.textAlignment = NSTextAlignmentLeft;
    _priceLab.font = [UIFont boldSystemFontOfSize:12.0];
    _priceLab.left = desLab.right +17;
    [self addSubview:_priceLab];
    
    //状态按钮
    _stateBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _stateBut.frame = CGRectMake(0, 0, 80,34);
    _stateBut.right = self.width-20;
    _stateBut.centerY = self.height/2.0;
    [_stateBut setTitle:@"" forState:UIControlStateNormal];
    _stateBut.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_stateBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_stateBut addTarget:self action:@selector(stateAciton) forControlEvents:UIControlEventTouchUpInside];
    _stateBut.hidden = YES;
    [self addSubview:_stateBut];
    
    //取消按钮
    _cancleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBut.frame = CGRectMake(0, 0, 80,34);
    _cancleBut.right = _stateBut.left-10;
    _cancleBut.centerY = self.height/2.0;
    [_cancleBut setTitle:@"取消订单" forState:UIControlStateNormal];
    _cancleBut.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_cancleBut setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [_cancleBut addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIImage *bgImage =[UIImage imageNamed:@"btn_loading_skip_none"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
    [_cancleBut setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_cancleBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    _cancleBut.hidden = YES;
    [self addSubview:_cancleBut];
}

- (void)configData:(LKOrderListModel *)model{
    self.model = model;
    //总价
    _priceLab.text = [NSString stringWithFormat:@"¥%@",model.total_price];
    CGSize size = [LKUtils sizeFit:_priceLab.text withUIFont:_priceLab.font withFitWidth:100 withFitHeight:_priceLab.height];
    _priceLab.size = size;
    _priceLab.centerY = self.height/2.0;
    
    //状态按钮
    _stateBut.hidden = NO;
    NSString *title = [self getTitleWithState:model];
    [_stateBut setTitle:title forState:UIControlStateNormal];
    
    if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
        [self configGuideBtnSate:model];
    } else {
        [self configTravelBtnState:model];
    }
}

/// 导游按钮状态
- (void)configGuideBtnSate:(LKOrderListModel *)model {
    _cancleBut.hidden = YES;
    if ([model.order_state isEqualToString:@"3"]) {
        [self setStateButImage:@"yellowColor"];
        _stateBut.hidden = NO;
    }
    if ([model.order_state isEqualToString:@"4"]) {
        _stateBut.hidden = NO;
        [self setStateButImage:@"yellowColor"];
    }
    if ([model.order_state isEqualToString:@"2"]) {
        _stateBut.hidden = NO;
        [self setStateButImage:@"yellowColor"];
        
        if (model.commentFlag == 0) {
            _stateBut.hidden = YES;
        } else {
            if (model.replayFlag==1) {
                _stateBut.hidden = YES;
            } else {
                _stateBut.hidden = NO;
            }
        }
    }
    if ([model.order_state isEqualToString:@"5"]) {
        _stateBut.hidden = YES;
    }
}

/// 设置游客按钮状态
- (void)configTravelBtnState:(LKOrderListModel *)model {
    _cancleBut.hidden = YES;

    [self setStateButImage:@"yellowColor"];
    
    if ([model.order_state isEqualToString:@"0"]) { /// 待支付
        _cancleBut.hidden = NO;
    }
    if ([model.order_state isEqualToString:@"1"]) { /// 已支付
        _cancleBut.hidden = NO;

    }
    if ([model.order_state isEqualToString:@"2"]) { /// 已完成
        if (model.commentFlag==1) {
            [self setStateButImage:@"grayColor"];
        }
    }
    if ([model.order_state isEqualToString:@"-1"]) { /// 已取消

    }
    if ([model.order_state isEqualToString:@"3"]) { /// 待确认
        [self setStateButImage:@"redColor"];
    }
    if ([model.order_state isEqualToString:@"5"]) {

    }
    if ([model.order_state isEqualToString:@"4"]) {
        _cancleBut.hidden = NO;
    }
}

- (void )setStateButImage:(NSString *)style{
    NSString *imageStr = @"";
    if ([style isEqualToString:@"grayColor"]) {
        imageStr = @"btn_loading_skip_none";
    }
    if ([style isEqualToString:@"yellowColor"]) {
        imageStr = @"btn_loading_code_none";
    }
    if ([style isEqualToString:@"redColor"]) {
        imageStr = @"btn_visitor_delete_none";
    }
    UIImage *bgImage =[UIImage imageNamed:imageStr];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeStretch];
    [_stateBut setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_stateBut setBackgroundImage:bgImage forState:UIControlStateHighlighted];
}

- (NSString *)getTitleWithState:(LKOrderListModel *)model{
    NSString *title = @"";
    NSString *order_state = [NSString stringValue:model.order_state];
    _handleType = LKOrderHandleType_none;
    if ([order_state isEqualToString:@"0"]) {
        title = @"去支付";
        _handleType = LKOrderHandleType_pay;
    }else if ([order_state isEqualToString:@"3"]){
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            title = @"确认订单";
            _handleType = LKOrderHandleType_sure;
        } else {
            title = @"取消订单";
            _handleType = LKOrderHandleType_cancel;
        }
    }else if ([order_state isEqualToString:@"2"]){
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            title = @"去回复";
            _handleType = LKOrderHandleType_evaluate;
            if (model.replayFlag ==1) {
                _handleType =  LKOrderHandleType_none;
            }
        } else {
            title = @"去评价";
            _handleType = LKOrderHandleType_evaluate;
            if (model.commentFlag==1) {
                title = @"已评价";
                _handleType = LKOrderHandleType_none;
            }
        }
    }else if ([order_state isEqualToString:@"-1"]){
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            
        } else {
            title = @"再次预定";
            _handleType = LKOrderHandleType_reservation;
        }
       
    }else if([order_state isEqualToString:@"4"]) { // 已确认
        if ([LKUserInfoUtils getUserType]==LKUserType_Guide) {
            title = @"开始服务";
            _handleType = LKOrderHandleType_service;
        } else {
            title = @"联系客服";
            _handleType = LKOrderHandleType_kefu;
        }
    }else if ([order_state isEqualToString:@"5"]) {
        title = @"完成";
        _handleType = LKOrderHandleType_complete;
    }
    return title;
}

- (void)stateAciton{
    if (self.clickedStateHandleBlock) {
        self.clickedStateHandleBlock(self.model, self.handleType);
    }
}

- (void)cancelAction{
    if (self.clickedStateHandleBlock) {
        self.clickedStateHandleBlock(self.model, LKOrderHandleType_cancel);
    }
}

@end



