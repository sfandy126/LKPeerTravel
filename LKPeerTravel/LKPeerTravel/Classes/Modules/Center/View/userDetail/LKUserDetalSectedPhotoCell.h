//
//  LKUserDetalSectedPhotoCell.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/28.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LKUserDetalSectedPhotoCellCellReuseIndentifier = @"LKUserDetalSectedPhotoCellCellReuseIndentifier";


@interface LKUserDetailSigleSceneCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) void (^deleteItemBlock) (NSDictionary *item);

@end

@interface LKUserDetalSectedPhotoCell : UITableViewCell

@property (nonatomic, strong) NSArray <NSDictionary *>*scenes;
@property (nonatomic, copy) void (^deleteItemBlock) (NSDictionary *item);

+ (CGFloat)heightWithScenes:(NSArray *)scenes;

@end
