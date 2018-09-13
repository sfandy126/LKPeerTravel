//
//  LKWishTagListView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/6/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKWishTagListView : UIView

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, copy) void (^deleteWishBlock)(NSDictionary *dict);

+ (CGFloat)heightWithTags:(NSArray *)tags;

@end


@interface LKWishTagView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^deleteWishBlock)(NSDictionary *dict);
@property (nonatomic, strong) NSDictionary *dict;

@end
