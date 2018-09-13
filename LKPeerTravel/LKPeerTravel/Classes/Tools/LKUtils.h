//
//  LKUtils.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

/**
 *  自定义工具类
 *
 *
 **/

#import <Foundation/Foundation.h>

typedef void (^ LKScaleImageCompletionBlock)(UIImage *scaledImage, UIImage *thumbnail, CGFloat quality);

@interface LKUtils : NSObject

+ (void)showMessage:(NSString *)msg;

///根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)URL;

///计算NSString 的size
+ (CGSize)sizeFit:(NSString *)string withUIFont:(UIFont *)font withFitWidth:(CGFloat)width withFitHeight:(CGFloat)height;

///计算NSAttributedString的size
+ (CGSize)sizeAttributedString:(NSMutableAttributedString *)attributedString withUIFont:(UIFont *)font withFitWidth:(CGFloat)width withFitHeight:(CGFloat)height;

///校验手机号码
+ (BOOL)validatePhoneNumber:(NSString *)phoneNum;

///md5加密
+ (NSDateFormatter *)customDateFromatter;

//md5加密
+ (NSString *)md5:(NSString *)input;

///字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format;

///日期转字符串
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format;

///字符串日期转换成指定的格式
+ (NSString *)stringDateToString:(NSString *)dateStr withDateFormat:(NSString *)format;

//将时间戳转成日期字符串类型
+ (NSString *)dateStringFromTimeIntervalStr:(NSString *)timeIntervalStr;

+ (void)LKScaleImage:(UIImage *)image completed:(LKScaleImageCompletionBlock)completed;

@end
