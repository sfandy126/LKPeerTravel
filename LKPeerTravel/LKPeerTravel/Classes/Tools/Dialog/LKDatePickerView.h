//
//  LKDatePickerView.h
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/7/14.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKDatePickerViewDelegate <NSObject>

- (void)clickSureBtn:(NSString *)age constellation:(NSString *)constellation birthday:(NSString *)birthday;

@end

@interface LKDatePickerView : UIView

@property (nonatomic, weak) id<LKDatePickerViewDelegate> delegate;

@property (nonatomic, strong) NSString *birthday;

- (void)show;
- (void)hide;

@end
