//
//  LKBaseCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/28.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  所有cell基于该类
 *
 *
 **/

#import <UIKit/UIKit.h>


static NSString *kOtherCellIdentify = @"kOtherCellIdentify";

@interface LKBaseCell : UITableViewCell

- (void)createView;

- (void)configData:(id)data;

+ (CGFloat )getCellHeight:(id)data;

@end
