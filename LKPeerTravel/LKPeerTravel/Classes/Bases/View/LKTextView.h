//
//  LKTextView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/2.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKTextView : UITextView

@property (nonatomic, strong) NSString *placehoder;
@property (nonatomic, strong) UIColor *placehoderColor;

@property (nonatomic, copy)  NSAttributedString *attriPlaceholder;
@property (nonatomic, assign) CGFloat placehoderLeft;
@property (nonatomic, assign) CGFloat placehoderTop;

@property (nonatomic, strong) UILabel *placehoderLabel;

- (void)textDidChange;

- (void)updatePlacehoderLableFrame;

@end
