//
//  LKAudioManager.m
//  LKPeerTravel
//
//  Created by CK on 2018/5/30.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKAudioManager.h"

@interface LKAudioManager ()
@property (nonatomic,strong) AVPlayer *player;
@end

@implementation LKAudioManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (LKAudioManager *)share{
    static LKAudioManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LKAudioManager alloc] init];
        }
    });
    return instance;
}

- (YYCache *)cache {
    if (!_cache) {
        _cache = [[YYCache alloc] initWithName:@"speechDuration"];
    }
    return _cache;
}


- (void)setBufferProccess:(CGFloat)bufferProccess{
    _bufferProccess = bufferProccess;
}

- (AVPlayerItem *)getItemWithIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:[NSString stringValue:[self.audioArray objectAt:index]]];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //KVO监听播放状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //KVO监听缓存大小
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //通知监听item播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOver:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    return item;
}

///播放完成
- (void)playOver:(NSNotification *)noti{
//    AVPlayerItem *item =noti.object;
    [self DidPlayEnd];
}

- (void)DidPlayEnd{
    if (self.playOverBlock) {
        self.playOverBlock();
    }
}

///监听状态和缓冲进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem *item = object;
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态，不能播放");
                [LKUtils showMessage:@"未知状态，不能播放"];
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"准备完毕，可以播放");
                if (self.preparePlayBlock) {
                    self.preparePlayBlock();
                }
                break;
            case AVPlayerStatusFailed:
                NSLog(@"加载失败, 网络相关问题");
                [LKUtils showMessage:@"音频加载失败，请检查网络"];
                break;
                
            default:
                break;
        }
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = item.loadedTimeRanges;
        //本次缓存的时间
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        NSTimeInterval totalBufferTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //缓存的总长度
        CGFloat bufferProccess = totalBufferTime / CMTimeGetSeconds(item.duration);
//        self.bufferProgress.progress = bufferProccess;
        self.bufferProccess = bufferProccess;
    }
}

- (AVPlayer *)player {
    if (!_player) {
        //        根据链接数组获取第一个播放的item， 用这个item来初始化AVPlayer
        AVPlayerItem *item = [self getItemWithIndex:self.currentIndex];
        //        初始化AVPlayer
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
        /*
        __weak typeof(self)weakSelf = self;
        // 监听播放的进度的方法，addPeriodicTime: ObserverForInterval: usingBlock:
         //      DMTime 每到一定的时间会回调一次，包括开始和结束播放
         block回调，用来获取当前播放时长
         return 返回一个观察对象，当播放完毕时需要，移除这个观察
        _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            if (current) {
                [weakSelf.progressView setProgress:current / CMTimeGetSeconds(item.duration) animated:YES];
                weakSelf.progressSlide.value = current / CMTimeGetSeconds(item.duration);
            }
        }];
        */
    }
    return _player;
}

///播放
- (void)play{
    //先暂停之前的播放，再开始播放另外一个
    [self pause];
    [self DidPlayEnd];
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.player = nil;
    
    [self.player play];
}

///暂停
- (void)pause{
     [self.player pause];
}


@end
