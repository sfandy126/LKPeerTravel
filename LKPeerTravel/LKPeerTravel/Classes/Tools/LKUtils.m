//
//  LKUtils.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/24.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKUtils.h"
#import <MBProgressHUD.h>
#import<CommonCrypto/CommonDigest.h>

#import "UIImage+LKImage.h"

@implementation LKUtils

+ (void)showMessage:(NSString *)msg{
    msg = [NSString stringValue:msg];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.text = msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

///根据图片url获取图片尺寸
+ (CGSize)getImageSizeWithURL:(id)URL {
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;  // url不正确返回CGSizeZero
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        if (imageProperties != NULL) {
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

///计算NSString 的size
+ (CGSize)sizeFit:(NSString *)string withUIFont:(UIFont *)font withFitWidth:(CGFloat)width withFitHeight:(CGFloat)height
{
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

///计算NSAttributedString的size
+ (CGSize)sizeAttributedString:(NSMutableAttributedString *)attributedString withUIFont:(UIFont *)font withFitWidth:(CGFloat)width withFitHeight:(CGFloat)height
{
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

///校验手机号码
+ (BOOL)validatePhoneNumber:(NSString *)phoneNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:phoneNum] == YES)
       || ([regextestcm evaluateWithObject:phoneNum] == YES)
       || ([regextestct evaluateWithObject:phoneNum] == YES)
       || ([regextestcu evaluateWithObject:phoneNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)md5:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

//字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [self customDateFromatter];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [self customDateFromatter];
   
    [dateFormatter setDateFormat:format];
    
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

+ (NSString *)stringDateToString:(NSString *)dateStr withDateFormat:(NSString *)format {
    NSDate *date = [LKUtils stringToDate:dateStr withDateFormat:format];
    NSString *str = [LKUtils dateToString:date withDateFormat:format];
    return str;
}

//将时间戳转成日期字符串类型
+ (NSString *)dateStringFromTimeIntervalStr:(NSString *)timeIntervalStr {
    if (!timeIntervalStr || timeIntervalStr.length==0) {
        return @"";
    }
    if (timeIntervalStr.length>10) {
        timeIntervalStr = [timeIntervalStr substringToIndex:10];
    }
    NSDateFormatter *formatter = [self customDateFromatter];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *stampDate = [NSDate dateWithTimeIntervalSince1970:[timeIntervalStr doubleValue]];
    NSString *dateTime = [formatter stringFromDate:stampDate];
    return dateTime;
}

+ (NSDateFormatter *)customDateFromatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMdd"];
    });
    return dateFormatter;
}

+ (void)LKScaleImage:(UIImage *)originImage completed:(LKScaleImageCompletionBlock)completionBlock {
    
    UIImage *scaledImage, *thumbnail;
    
    CGFloat quality = [LKUtils LKCompressQualityForImage:originImage];
    
    CGFloat maxSide = MAX(originImage.size.width, originImage.size.height);
    CGFloat scale = 640 / maxSide;
    scale = scale < 1 ? scale : 1;
    
    if (scale < 1) {
        CGSize targetSize = CGSizeMake(originImage.size.width * scale, originImage.size.height * scale);
        scaledImage = [originImage imageByScalingToSize:targetSize];
    }
    else {
        scaledImage = originImage;
    }
    
    maxSide = MAX(scaledImage.size.width, scaledImage.size.height);
    CGFloat thumbnailScale = 256 / maxSide;
    thumbnailScale = thumbnailScale < 1 ? thumbnailScale : 1;
    
    if (thumbnailScale < 1) {
        CGSize targetSize = CGSizeMake(scaledImage.size.width * thumbnailScale, scaledImage.size.height * thumbnailScale);
        //                thumbnail = [UIImage coreImageScaleImage:scaledImage scale:thumbnailScale];
        thumbnail = [scaledImage imageByScalingToSize:targetSize];
    }
    else {
        thumbnail = scaledImage;
    }
    scaledImage = [UIImage fixOrientation:scaledImage];
    
    if (completionBlock) {
        completionBlock(scaledImage, thumbnail, quality);
    }
}

+ (BOOL)LKIsLongImage:(UIImage *)image {
    //原始图片尺寸
    CGFloat originWidth = image.size.width;
    CGFloat originHeight = image.size.height;
    
    CGFloat longerSide = MAX(originWidth, originHeight);
    CGFloat shorterSide = MIN(originWidth, originHeight);
    
    //长边和短边的比例
    CGFloat ratio = longerSide / shorterSide;
    
    //判断是否为长图
    if (ratio >= 2.5 && longerSide > 1000) {
        return YES;
    }else {
        return NO;
    }
}

+ (CGFloat)LKCompressQualityForImage:(UIImage *)image
{
    CGFloat quality;
    
    //长图
    if ([LKUtils LKIsLongImage:image]) {
        quality = 0.85f;
    }else {
        
        //原始图片尺寸
        CGFloat originWidth = image.size.width;
        CGFloat originHeight = image.size.height;
        
        CGFloat longerSide = MAX(originWidth, originHeight);
        
        //获取设备最长边分辨率
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat screenLongerSide = MAX(screenWidth, screenHeight);
        
        CGFloat screenResolution = screenLongerSide * screenScale;
        
        //设备分辨率最长边≥2000，图片分辨率最长边＞1280，则按照最长边=1280进行等比例缩放，图片质量为90%
        if (screenResolution >= 2000 && longerSide > 1280) {
            quality = 0.9f;
        }
        //设备分辨率最长边＞1000 且 ＜2000，图片分辨率最长边＞1000，则按照最长边=1000进行等比例缩放，图片质量为85%
        else if (screenResolution > 1000 && screenResolution < 2000 && longerSide > 1000) {
            quality = 0.85f;
        }
        //设备分辨率最长边＜1000，图片分辨率最长边＞1000，则按照最长边=1000进行等比例缩放，图片质量为80%
        else if (screenResolution < 1000 && longerSide > 1000) {
            quality = 0.8f;
        }
        else {
            quality = 0.9;
        }
    }
    
    return quality;
}

@end
