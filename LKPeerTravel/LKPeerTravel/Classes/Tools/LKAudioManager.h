//
//  LKAudioManager.h
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <YYCache.h>

@interface LKAudioManager : NSObject

+ (LKAudioManager *)share;

@property (nonatomic,strong) NSArray<NSString *> *audioArray;

///默认从第一个开始播放
@property (nonatomic,assign) NSInteger currentIndex;

///缓冲进度
@property (nonatomic,assign,readonly) CGFloat bufferProccess;

///播放完成回调
@property (nonatomic,copy) void (^playOverBlock)(void);
///准备播放
@property (nonatomic,copy) void (^preparePlayBlock)(void);

/// 用于保存语言时长，避免重复下载

@property (nonatomic, strong) YYCache *cache;

///播放
- (void)play;

///暂停
- (void)pause;

@end
