//
//  LKOrderDetailServiceCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseCell.h"
#import "LKOrderDetailModel.h"

static NSString *LKOrderDetailServiceCellReuseIndentifier = @"LKOrderDetailServiceCellReuseIndentifier";


@interface LKOrderDetailServiceCell : LKBaseCell

- (void)configData:(LKOrderDetailModel *)model;

@end


