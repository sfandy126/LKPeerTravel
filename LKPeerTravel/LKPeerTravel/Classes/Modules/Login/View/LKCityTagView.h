//
//  LKCityTagView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/11.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSelectCityModel.h"

@interface LKCityTagView : UIView

@property (nonatomic,copy) void (^selectedBlock)(LKCityTagModel *item);

- (void)configData:(NSArray <LKCityTagModel *>*)dataSource;

@end

@interface LKTagButton: UIButton
@property (nonatomic,strong) LKCityTagModel *item;
+ (LKTagButton *)buttonWithTag: (LKCityTagModel *)item;

@end

@interface LKTagView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) CGFloat regularWidth; //!< 固定宽度
@property (nonatomic,assign ) CGFloat regularHeight; //!< 固定高度
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(LKCityTagModel *item);

- (void)addTag: (LKCityTagModel *)tag;
- (void)removeAllTags;

@end

