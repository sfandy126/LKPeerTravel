//
//  LKVoiceView.m
//  LKPeerTravel
//
//  Created by Alex_Rao on 2018/8/6.
//  Copyright © 2018年 LK. All rights reserved.
//

#import "LKVoiceView.h"
#import "LKAudioManager.h"

@implementation LKVoiceView

{
    UIImageView *_voiceIcon;
    UILabel *_voiceTimeLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //语音按钮
        _voiceIcon = [[UIImageView alloc] initWithFrame:self.bounds];
        _voiceIcon.backgroundColor = [UIColor clearColor];
        _voiceIcon.image = [UIImage imageNamed:@"btn_guide_voice_none"];
        [_voiceIcon g_addTapWithTarget:self action:@selector(playVoice)];
        [self addSubview:_voiceIcon];
        
        //语音总时长
        _voiceTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _voiceIcon.width-3, _voiceIcon.height)];
        _voiceTimeLab.text = @"";
        _voiceTimeLab.font = kFont(10);
        _voiceTimeLab.textColor = [UIColor whiteColor];
        _voiceTimeLab.textAlignment = NSTextAlignmentRight;
        [_voiceIcon addSubview:_voiceTimeLab];
    }
    return self;
}

- (void)setVoiceUrl:(NSString *)voiceUrl {
    _voiceUrl = voiceUrl;
    
    if ([[LKAudioManager share].cache objectForKey:voiceUrl]) {
        _voiceTimeLab.text = (NSString *)[[LKAudioManager share].cache objectForKey:voiceUrl];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:voiceUrl] options:nil];
            CMTime audioDuration = audioAsset.duration;
            float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _voiceTimeLab.text = [NSString stringWithFormat:@"%0.1f''",audioDurationSeconds];
                [[LKAudioManager share].cache setObject:_voiceTimeLab.text forKey:voiceUrl];
            });
        });
    }
 
  
}

- (void)startAnimation{
    _voiceIcon.animationImages = @[[UIImage imageNamed:@"btn_guide_voice_cartoon1"],
                                   [UIImage imageNamed:@"btn_guide_voice_cartoon2"],
                                   [UIImage imageNamed:@"btn_guide_voice_cartoon3"],
                                   [UIImage imageNamed:@"btn_guide_voice_cartoon4"]];
    _voiceIcon.animationRepeatCount=-1;
    _voiceIcon.animationDuration = 0.8;
    [_voiceIcon startAnimating];
}

- (void)stopAnimation{
    [_voiceIcon stopAnimating];
}

//播放语音
- (void)playVoice{
    [LKAudioManager share].audioArray = @[[NSString stringValue:self.voiceUrl]];
    [[LKAudioManager share] play];
    [LKAudioManager share].preparePlayBlock = ^{
        [self startAnimation];
    };
    [LKAudioManager share].playOverBlock = ^{
        [self stopAnimation];
    };
}


@end
