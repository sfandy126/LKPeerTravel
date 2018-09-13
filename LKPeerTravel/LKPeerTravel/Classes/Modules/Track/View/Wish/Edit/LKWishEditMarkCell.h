//
//  LKWishEditMarkCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LKWishEditMarkCellReuseIdentifier = @"LKWishEditMarkCellReuseIdentifier";

@interface LKWishEditMarkCell : UITableViewCell

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) void (^addWishBlock)(void);
@property (nonatomic, copy) void (^deleteWishBlock)(NSDictionary *dict);

+ (CGFloat)cellHeightWidthTags:(NSArray *)tags;

@end
