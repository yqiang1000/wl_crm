//
//  PlayerManager.m
//  Wangli
//
//  Created by yeqiang on 2019/2/28.
//  Copyright © 2019年 jiuyisoft. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, copy) NSString *playingURL;

@end

static PlayerManager *_manager = nil;
static dispatch_once_t onceToken;

@implementation PlayerManager

+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        _manager = [[PlayerManager alloc] init];
    });
    return _manager;
}

+ (void)destoryInstance {
    _manager = nil;
    onceToken = 0;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&err];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackFinished:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 播放

- (void)startPlay {
    // 如果播放地址和正在播放的不一致，则重新播放新的
    // 如果播放器处于暂停状态，则继续播放
    // 如果播放结束了，则继续从0开始播放
    if (![_voiceUrl isEqualToString:_playingURL]) {
        _playingURL = _voiceUrl;
        [self play];
    } else {
        if (self.status == ETPlayer_Pause) {
            self.status = ETPlayer_Playing;
            [self.player play];
        } else if (self.status == ETPlayer_Stop || self.status == ETPlayer_FinishedPlay) {
            [self seekToNewTime:0];
            self.status = ETPlayer_Playing;
            [self.player play];
        }
        [self sendDelegate:ETPlayer_Playing];
    }
}

- (void)play {
    if (_playingURL.length == 0) {
        [Utils showToastMessage:@"音频链接为空"];
        self.status = ETPlayer_PlayFailed;
        [self sendDelegate:ETPlayer_PlayFailed];
    } else {
        // 设置播放的url
        NSURL *url = [NSURL fileURLWithPath:_playingURL];
        if ([_playingURL hasPrefix:@"http://"] || [_playingURL hasPrefix:@"https://"]) {
            url = [NSURL URLWithString:_playingURL];
        }
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self.player play];
    }
}

#pragma mark - 暂停

- (void)pause {
    [_player pause];
    self.status = ETPlayer_Pause;
    [self sendDelegate:ETPlayer_Pause];
}

#pragma mark - 结束

- (void)stop {
    [_player pause];
    [self seekToNewTime:0];
    self.status = ETPlayer_Stop;
    [self sendDelegate:ETPlayer_Stop];
}

#pragma mark - public

- (BOOL)isPlaying {
    // 可以根据值去判断播放还是暂停
    if (_player.rate == 0.0) {
        return NO;
    }
    return YES;
}

- (void)resetPlayer {
    if ([self isPlaying]) {
        [self pause];
    }
    self.status = ETPlayer_Original;
    [self seekToNewTime:0];
    self.voiceUrl = @"";
//    self.player = nil;
}

#pragma mark - provide

- (void)sendDelegate:(ETPlayerStatus)playStatus {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerStatus:)]) {
        [self.delegate currentPlayerStatus:playStatus];
    }
}

- (void)seekToNewTime:(NSUInteger)newTime {
    CMTime time = _player.currentTime;
    time.value = newTime * time.timescale;
    [_player seekToTime:time];
}

- (void)playbackFinished:(NSNotification *)noti {
    self.status = ETPlayer_FinishedPlay;
    [self sendDelegate:ETPlayer_FinishedPlay];
    [_player pause];
    [self seekToNewTime:0];
}

#pragma mark - lazy

- (AVPlayer *)player {
    if (!_player) _player = [[AVPlayer alloc] init];
    return _player;
}

@end
