//
//  LKCodeInputView.h
//  LKPeerTravel
//
//  Created by CK on 2018/6/7.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

//验证码长度
#define CODECOUNT 6

@interface LKCodeInputView : UIView

@property (nonatomic,copy) NSString *code;
//输入完后的验证码
@property (nonatomic,copy) void (^codeBlock)(NSString *code);

- (void)resignResponder;

@end


@interface LKCodeLabel : UILabel
///框的个数,默认为6
@property (nonatomic,assign) NSInteger codeCount;
///每个框的大小，默认34*40
@property (nonatomic,assign) CGSize codeSize;
///框之间的间距,默认为8
@property (nonatomic,assign) CGFloat codeInval;

@end
