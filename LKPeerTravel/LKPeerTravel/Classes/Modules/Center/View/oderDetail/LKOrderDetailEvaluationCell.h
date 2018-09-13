//
//  LKOrderDetailEvaluationCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/16.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKBaseCell.h"
#import "LKOrderDetailModel.h"
#import "LKOrderDetailMainView.h"

static NSString *kLKOrderDetailEvaluationCellReuseIndentifier = @"kLKOrderDetailEvaluationCellReuseIndentifier";

@interface LKOrderDetailEvaluationCell : LKBaseCell

@property (nonatomic, strong) LKOrderDetailModel *model;
@property (nonatomic, weak) LKOrderDetailMainView *mainView;

+ (CGFloat)heightWithModel:(LKOrderDetailModel *)model;

@end
