//
//  LKMyServerInfoCell.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/18.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  我的服务 基本信息cell
 *
 **/

#import "LKBaseCell.h"
#import "LKMyServerModel.h"

static NSString *kMyServerInfoCellIdentify = @"kMyServerInfoCellIdentify";

@interface LKMyServerInfoCell : UITableViewCell

@property (nonatomic, copy) void (^switchValueChanged) (BOOL isOn);

- (void)configData:(LKMyServerModel *)model  indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeight:(LKMyServerModel *)model indexPath:(NSIndexPath *)indexPath;

/// 获取编辑后的折扣信息
- (NSArray *)obtainDiscoutData;

@end


@interface LKSwitch: UIControl

@property(nonatomic,assign) BOOL isOn;

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage frame:(CGRect)frame;

@end


///折扣输入视图
@interface LKMyServerDiscountView : UIView

- (instancetype)initWithFrame:(CGRect)frame withRowCount:(NSInteger )rowCount;

- (void)configData:(NSArray *)data;

- (NSArray *)obtainEditData;

@end

@interface LKMyServerDiscountSingleView : UIView

- (void)configData:(NSDictionary *)data;

/// 获取更改后的数据
- (NSDictionary *)obtainEditData;

@end

