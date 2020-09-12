//
//  YQAVPlayer.m
//  KJCamera
//
//  Created by yeqiang on 2018/12/10.
//  Copyright © 2018年 huangkejin. All rights reserved.
//

#import "YQAVPlayer.h"
#import <AVFoundation/AVFoundation.h>


typedef void(^finishplayBlock)(YQAVPlayer *obj);

@interface YQAVPlayer ()

@property (nonatomic, assign) BOOL isNet;
@property (nonatomic, copy) finishplayBlock finishplayblock;

@property (nonatomic,strong) AVPlayer *player;//播放器对象

@end

@implementation YQAVPlayer

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url finishplayblock:(nonnull void (^)(YQAVPlayer * _Nonnull))finishplayblock {
    if (self = [self initWithFrame:frame]) {
        _finishplayblock = finishplayblock;
        //创建播放器层
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = self.bounds;
        
        [self.layer addSublayer:playerLayer];
        if (url) {
            self.videoUrl = url;
        }
    }
    return self;
}

- (void)dealloc {
    [self removeAvPlayerNtf];
    [self stopPlayer];
    self.player = nil;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:[self getAVPlayerItem]];
        [self addAVPlayerNtf:_player.currentItem];
        
    }
    
    return _player;
}

- (AVPlayerItem *)getAVPlayerItem {
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:self.videoUrl];
    return playerItem;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
//    NSString *str = _videoUrl.absoluteString;
//    if ([str containsString:@"http"]) {
//        _isNet = YES;
//    } else {
//        _isNet = NO;
//    }
    [self removeAvPlayerNtf];
    [self nextPlayer];
}

- (void)nextPlayer {
//    if (_isNet) {
//        [self.player seekToTime:CMTimeMake(0, 0)];
//    } else {
//        [self.player seekToTime:CMTimeMakeWithSeconds(0, _player.currentItem.duration.timescale)];
//    }
    [self.player seekToTime:CMTimeMakeWithSeconds(0, _player.currentItem.duration.timescale)];
    [self.player replaceCurrentItemWithPlayerItem:[self getAVPlayerItem]];
    [self addAVPlayerNtf:self.player.currentItem];
    if (self.player.rate == 0) {
        [self.player play];
    }
}

- (void) addAVPlayerNtf:(AVPlayerItem *)playerItem {
    //监控状态属性
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)removeAvPlayerNtf {
    AVPlayerItem *playerItem = self.player.currentItem;
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopPlayer {
    if (self.player.rate == 1) {
        [self.player pause];//如果在播放状态就停止
    }
}

/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (void)playbackFinished:(NSNotification *)ntf {
    NSLog(@"视频播放完成");
    if (self.finishplayblock) {
        [self stopPlayer];
//        self.player = nil;
        self.finishplayblock(self);
    } else {
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self.player play];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.finishplayblock) {
        [self stopPlayer];
        self.finishplayblock(self);
    }
}

@end
