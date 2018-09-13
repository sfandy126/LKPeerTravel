//
//  LKCertifyShowCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKCertifyShowModel.h"

@interface LKCertifyShowCell : UITableViewCell

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) LKCertifyShowModel *model;
@property (nonatomic, copy) void (^addPicFinished) (void);

@end
