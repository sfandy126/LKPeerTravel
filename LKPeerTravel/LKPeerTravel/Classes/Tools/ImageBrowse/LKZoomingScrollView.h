//
//  LKZoomingScrollView.h
//  LKPeerTravel
//
//  Created by LK on 2018/7/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKImageBrowseModel.h"

@interface LKZoomingScrollView : UIScrollView

@property (nonatomic, strong) UIImageView* bigImg;

- (void)setItem:(LKImageBrowseSingleModel *)item isShowLoading:(BOOL)isShow;

@end
