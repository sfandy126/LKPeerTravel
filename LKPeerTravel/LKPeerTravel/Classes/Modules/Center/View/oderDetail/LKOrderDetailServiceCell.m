//
//  LKOrderDetailServiceCell.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKOrderDetailServiceCell.h"

#import "LKOrderListShopsView.h"

@implementation LKOrderDetailServiceCell

{
    LKOrderListShopsView *_shopView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //商品
    _shopView = [[LKOrderListShopsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.contentView addSubview:_shopView];
    
  
}

- (void)configData:(LKOrderDetailModel *)model{
    
//    NSArray *shops = [NSArray getArray:model.selectedServe];
//    NSInteger row =(shops.count/4) +(shops.count%4==0?0:1);
//    CGFloat shopHeight = (92*kWidthRadio)*row+10*row;
    [_shopView configOrderDetailData:model.selectedServe shopsHeight:model.serveHeight];
    
}

@end







