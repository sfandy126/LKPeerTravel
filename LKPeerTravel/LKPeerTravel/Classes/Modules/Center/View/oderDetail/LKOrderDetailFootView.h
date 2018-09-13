//
//  LKOrderDetailFootView.h
//  LKPeerTravel
//
//  Created by CK on 2018/7/17.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKOrderDetailModel.h"
#import "LKOrderDetailMainView.h"

@interface LKOrderDetailFootView : UIView

@property (nonatomic, weak) LKOrderDetailMainView *mainView;

- (void)configData:(LKOrderDetailModel *)model;

@end
